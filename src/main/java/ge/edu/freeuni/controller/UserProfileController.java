package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.*;
import ge.edu.freeuni.model.*;
import ge.edu.freeuni.model.QuizEngine.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class UserProfileController {

    @Autowired
    private UserDao users;

    @Autowired
    private QuizDAO quizzes;

    @Autowired
    private QuizAttemptDao quizAttempts;

    @Autowired
    private AchievementDao achievements;

    @Autowired
    private FriendshipDao friendships;

    @Autowired
    private FriendRequestDao friendRequests;

    @Autowired
    private MessageDao messages;

    // View another user's profile
    @GetMapping("/user/{username}")
    public ModelAndView viewUserProfile(@PathVariable String username, HttpSession session) {
        String currentUser = (String) session.getAttribute("name");
        if (currentUser == null) {
            return new ModelAndView("redirect:/welcome");
        }

        ModelAndView mav = new ModelAndView("user-profile");

        try {
            // Check if user exists
            if (!users.exists(username)) {
                mav.setViewName("redirect:/friends/search");
                mav.addObject("error", "User '" + username + "' not found.");
                return mav;
            }

            // Get user's basic info
            mav.addObject("profileUser", username);
            mav.addObject("currentUser", currentUser);
            mav.addObject("isOwnProfile", currentUser.equals(username));

            // Get friendship status
            String friendshipStatus = getFriendshipStatus(currentUser, username);
            mav.addObject("friendshipStatus", friendshipStatus);

            // Get user's public stats
            List<QuizAttempt> userAttempts = quizAttempts.getAttemptsForUser(username);
            List<Quiz> allQuizzes = quizzes.getAllQuizzes();
            List<Quiz> userCreatedQuizzes = allQuizzes.stream()
                    .filter(quiz -> username.equals(quiz.getCreatorUsername()))
                    .collect(Collectors.toList());
            List<UserAchievement> userAchievements = achievements.getUserAchievements(username);

            // Calculate stats
            int totalAttempts = userAttempts.size();
            double averageScore = 0;
            if (!userAttempts.isEmpty()) {
                double totalScore = userAttempts.stream()
                        .mapToDouble(QuizAttempt::getPercentage)
                        .sum();
                averageScore = totalScore / totalAttempts;
            }

            mav.addObject("totalAttempts", totalAttempts);
            mav.addObject("totalCreatedQuizzes", userCreatedQuizzes.size());
            mav.addObject("totalAchievements", userAchievements.size());
            mav.addObject("averageScore", averageScore);

            // Get user's recent quiz creations (public)
            List<Quiz> recentCreatedQuizzes = userCreatedQuizzes.stream()
                    .sorted((q1, q2) -> q2.getQuizID() - q1.getQuizID())
                    .limit(5)
                    .collect(Collectors.toList());
            mav.addObject("recentCreatedQuizzes", recentCreatedQuizzes);

            // Get user's recent achievements (public)
            List<UserAchievement> recentAchievements = userAchievements.stream()
                    .sorted((a1, a2) -> a2.getEarnedDate().compareTo(a1.getEarnedDate()))
                    .limit(5)
                    .collect(Collectors.toList());
            mav.addObject("recentAchievements", recentAchievements);

            return mav;

        } catch (Exception e) {
            e.printStackTrace();
            mav.setViewName("redirect:/friends/search");
            mav.addObject("error", "Error loading user profile: " + e.getMessage());
            return mav;
        }
    }

    // Send friend request
    @PostMapping("/user/{username}/add-friend")
    @ResponseBody
    public Map<String, String> sendFriendRequest(@PathVariable String username, HttpSession session) {
        String currentUser = (String) session.getAttribute("name");
        Map<String, String> result = new HashMap<>();

        if (currentUser == null) {
            result.put("status", "error");
            result.put("message", "Please log in to send friend requests.");
            return result;
        }

        try {
            // Check if user exists
            if (!users.exists(username)) {
                result.put("status", "error");
                result.put("message", "User not found.");
                return result;
            }

            // Can't add yourself
            if (currentUser.equals(username)) {
                result.put("status", "error");
                result.put("message", "You cannot add yourself as a friend.");
                return result;
            }

            // Check if already friends
            List<Friendship> existingFriendships = friendships.findByUser(currentUser);
            boolean alreadyFriends = existingFriendships.stream()
                    .anyMatch(f -> f.getFriendName().equals(username));

            if (alreadyFriends) {
                result.put("status", "error");
                result.put("message", "You are already friends with " + username + ".");
                return result;
            }

            // Check if request already exists
            List<FriendRequest> existingRequests = friendRequests.findSentBy(currentUser);
            boolean requestExists = existingRequests.stream()
                    .anyMatch(fr -> fr.getRequesteeName().equals(username));

            if (requestExists) {
                result.put("status", "error");
                result.put("message", "Friend request already sent to " + username + ".");
                return result;
            }

            // Create friend request
            boolean requestCreated = friendRequests.insertRequest(currentUser, username);

            if (!requestCreated) {
                result.put("status", "error");
                result.put("message", "Failed to create friend request.");
                return result;
            }

            // Find the created request to get its ID (for the message)
            List<FriendRequest> sentRequests = friendRequests.findSentBy(currentUser);
            FriendRequest newRequest = sentRequests.stream()
                    .filter(fr -> fr.getRequesteeName().equals(username))
                    .findFirst()
                    .orElse(null);

            if (newRequest != null) {
                // Send friend request message
                messages.sendFriendRequest(currentUser, username, newRequest.getId());
            }

            result.put("status", "success");
            result.put("message", "Friend request sent to " + username + "!");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "Failed to send friend request: " + e.getMessage());
        }

        return result;
    }

    // Remove friend
    @PostMapping("/user/{username}/remove-friend")
    @ResponseBody
    public Map<String, String> removeFriend(@PathVariable String username, HttpSession session) {
        String currentUser = (String) session.getAttribute("name");
        Map<String, String> result = new HashMap<>();

        if (currentUser == null) {
            result.put("status", "error");
            result.put("message", "Please log in to manage friends.");
            return result;
        }

        try {
            // Remove bidirectional friendship
            boolean removed1 = friendships.deleteFriendship(currentUser, username);
            boolean removed2 = friendships.deleteFriendship(username, currentUser);

            if (removed1 || removed2) {
                result.put("status", "success");
                result.put("message", "Removed " + username + " from your friends list.");
            } else {
                result.put("status", "error");
                result.put("message", "You are not friends with " + username + ".");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "Failed to remove friend: " + e.getMessage());
        }

        return result;
    }

    // Helper method to determine friendship status
    private String getFriendshipStatus(String currentUser, String targetUser) {
        try {
            // Check if already friends
            List<Friendship> friendships = this.friendships.findByUser(currentUser);
            boolean alreadyFriends = friendships.stream()
                    .anyMatch(f -> f.getFriendName().equals(targetUser));

            if (alreadyFriends) {
                return "friends";
            }

            // Check if request already sent
            List<FriendRequest> sentRequests = friendRequests.findSentBy(currentUser);
            boolean requestSent = sentRequests.stream()
                    .anyMatch(fr -> fr.getRequesteeName().equals(targetUser));

            if (requestSent) {
                return "request_sent";
            }

            // Check if received request from them
            List<FriendRequest> receivedRequests = friendRequests.findPendingFor(currentUser);
            boolean requestReceived = receivedRequests.stream()
                    .anyMatch(fr -> fr.getRequesterName().equals(targetUser));

            if (requestReceived) {
                return "request_received";
            }

            return "none";

        } catch (Exception e) {
            return "none";
        }
    }
}