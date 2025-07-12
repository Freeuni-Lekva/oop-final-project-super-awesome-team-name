package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.*;
import ge.edu.freeuni.model.*;
import ge.edu.freeuni.model.QuizEngine.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class ProfileController {

    @Autowired
    private QuizDAO quizzes;

    @Autowired
    private QuizAttemptDao quizAttempts;

    @Autowired
    private AchievementDao achievements;

    @Autowired
    private MessageDao messages;

    @Autowired
    private FriendshipDao friendships;

    @GetMapping("/profile")
    public ModelAndView profile(HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            return new ModelAndView("redirect:/welcome");
        }

        ModelAndView mav = new ModelAndView("profile");
        mav.addObject("userName", userName);

        try {
            // 1. GET USER'S RECENT QUIZ CREATING ACTIVITIES
            List<Quiz> allQuizzes = quizzes.getAllQuizzes();
            List<Quiz> userCreatedQuizzes = allQuizzes.stream()
                    .filter(quiz -> userName.equals(quiz.getCreatorUsername()))
                    .sorted((q1, q2) -> q2.getQuizID() - q1.getQuizID()) // Most recent first
                    .collect(Collectors.toList());

            // Only send the recent 5 to display in the activities section
            List<Quiz> recentUserQuizzes = userCreatedQuizzes.stream()
                    .limit(5)
                    .collect(Collectors.toList());

            if (!recentUserQuizzes.isEmpty()) {
                mav.addObject("userCreatedQuizzes", recentUserQuizzes);
            }

            // 2. GET MESSAGE NOTIFICATIONS
            List<Message> allMessages = messages.getMessagesForUser(userName);
            List<Message> unreadMessages = allMessages.stream()
                    .filter(message -> !message.isRead())
                    .collect(Collectors.toList());
            List<Message> recentMessages = allMessages.stream()
                    .limit(5)
                    .collect(Collectors.toList());

            mav.addObject("unreadMessageCount", unreadMessages.size());
            mav.addObject("recentMessages", recentMessages);
            mav.addObject("hasMessages", !recentMessages.isEmpty());

            // 3. GET FRIEND'S RECENT ACTIVITIES
            List<Friendship> userFriends = friendships.findByUser(userName);
            List<FriendActivity> friendActivities = new ArrayList<>();

            for (Friendship friendship : userFriends) {
                String friendName = friendship.getFriendName();

                // Get friend's recent quiz attempts
                List<QuizAttempt> friendAttempts = quizAttempts.getAttemptsForUser(friendName)
                        .stream()
                        .limit(3)
                        .collect(Collectors.toList());

                // Get friend's recent quiz creations
                List<Quiz> friendQuizzes = allQuizzes.stream()
                        .filter(quiz -> friendName.equals(quiz.getCreatorUsername()))
                        .sorted((q1, q2) -> q2.getQuizID() - q1.getQuizID())
                        .limit(3)
                        .collect(Collectors.toList());

                // Get friend's recent achievements
                List<UserAchievement> friendAchievements = achievements.getUserAchievements(friendName)
                        .stream()
                        .sorted((a1, a2) -> a2.getEarnedDate().compareTo(a1.getEarnedDate()))
                        .limit(3)
                        .collect(Collectors.toList());

                if (!friendAttempts.isEmpty() || !friendQuizzes.isEmpty() || !friendAchievements.isEmpty()) {
                    FriendActivity activity = new FriendActivity();
                    activity.setFriendName(friendName);
                    activity.setRecentAttempts(friendAttempts);
                    activity.setRecentQuizzes(friendQuizzes);
                    activity.setRecentAchievements(friendAchievements);
                    friendActivities.add(activity);
                }
            }

            mav.addObject("friendActivities", friendActivities);
            mav.addObject("hasFriends", !friendActivities.isEmpty());

            // 4. GET USER'S BASIC STATS FOR DISPLAY
            List<QuizAttempt> userAttempts = quizAttempts.getAttemptsForUser(userName);
            List<UserAchievement> userAchievements = achievements.getUserAchievements(userName);

            mav.addObject("totalAttempts", userAttempts.size());
            mav.addObject("totalCreatedQuizzes", userCreatedQuizzes.size()); // Use the full list for the count
            mav.addObject("totalAchievements", userAchievements.size());
            mav.addObject("totalFriends", userFriends.size());

            double averageScore = 0;
            if (!userAttempts.isEmpty()) {
                double totalScore = userAttempts.stream()
                        .mapToDouble(QuizAttempt::getPercentage)
                        .sum();
                averageScore = totalScore / userAttempts.size();
            }
            mav.addObject("averageScore", averageScore);

            return mav;

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error loading profile data: " + e.getMessage());

            // Provide fallbacks
            mav.addObject("userCreatedQuizzes", new ArrayList<>());
            mav.addObject("recentMessages", new ArrayList<>());
            mav.addObject("friendActivities", new ArrayList<>());
            mav.addObject("unreadMessageCount", 0);
            mav.addObject("hasMessages", false);
            mav.addObject("hasFriends", false);

            return mav;
        }
    }

    // Helper class for friend activities
    public static class FriendActivity {
        private String friendName;
        private List<QuizAttempt> recentAttempts;
        private List<Quiz> recentQuizzes;
        private List<UserAchievement> recentAchievements;

        // Getters and setters
        public String getFriendName() { return friendName; }
        public void setFriendName(String friendName) { this.friendName = friendName; }

        public List<QuizAttempt> getRecentAttempts() { return recentAttempts; }
        public void setRecentAttempts(List<QuizAttempt> recentAttempts) { this.recentAttempts = recentAttempts; }

        public List<Quiz> getRecentQuizzes() { return recentQuizzes; }
        public void setRecentQuizzes(List<Quiz> recentQuizzes) { this.recentQuizzes = recentQuizzes; }

        public List<UserAchievement> getRecentAchievements() { return recentAchievements; }
        public void setRecentAchievements(List<UserAchievement> recentAchievements) { this.recentAchievements = recentAchievements; }
    }
}