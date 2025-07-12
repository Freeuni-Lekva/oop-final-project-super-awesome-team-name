package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.*;
import ge.edu.freeuni.model.*;
import ge.edu.freeuni.model.QuizEngine.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/messages")
public class MessageController {

    @Autowired
    private MessageDao messages;

    @Autowired
    private UserDao users;

    @Autowired
    private FriendRequestDao friendRequests;

    @Autowired
    private FriendshipDao friendships;

    @Autowired
    private QuizDAO quizzes;

    @Autowired
    private QuizAttemptDao quizAttempts;

    // Show inbox
    @GetMapping({"/", "/inbox"})
    public ModelAndView inbox(HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            return new ModelAndView("redirect:/welcome");
        }

        ModelAndView mav = new ModelAndView("inbox");

        try {
            List<Message> userMessages = messages.getMessagesForUser(userName);
            int unreadCount = messages.getUnreadCount(userName);

            mav.addObject("messages", userMessages);
            mav.addObject("unreadCount", unreadCount);
            mav.addObject("userName", userName);

            return mav;
        } catch (Exception e) {
            e.printStackTrace();
            mav.addObject("error", "Failed to load messages: " + e.getMessage());
            return mav;
        }
    }

    // Show sent messages
    @GetMapping("/sent")
    public ModelAndView sentMessages(HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            return new ModelAndView("redirect:/welcome");
        }

        ModelAndView mav = new ModelAndView("sent");

        try {
            List<Message> sentMessages = messages.getSentMessagesForUser(userName);
            mav.addObject("messages", sentMessages);
            mav.addObject("userName", userName);

            return mav;
        } catch (Exception e) {
            e.printStackTrace();
            mav.addObject("error", "Failed to load sent messages: " + e.getMessage());
            return mav;
        }
    }

    // Show compose message form
    @GetMapping("/compose")
    public ModelAndView composeMessage(@RequestParam(required = false) String to,
                                       @RequestParam(required = false) String subject,
                                       HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            return new ModelAndView("redirect:/welcome");
        }

        ModelAndView mav = new ModelAndView("compose");
        mav.addObject("userName", userName);
        mav.addObject("recipientName", to != null ? to : "");
        mav.addObject("subject", subject != null ? subject : "");

        // Get user's friends for the dropdown
        try {
            List<Friendship> userFriends = friendships.findByUser(userName);
            mav.addObject("friends", userFriends);
        } catch (Exception e) {
            mav.addObject("friends", new ArrayList<Friendship>());
        }

        return mav;
    }

    // Send a message
    @PostMapping("/send")
    public ModelAndView sendMessage(@RequestParam String recipientName,
                                    @RequestParam String subject,
                                    @RequestParam String messageText,
                                    HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            return new ModelAndView("redirect:/welcome");
        }

        try {
            // Check if recipient exists
            if (!users.exists(recipientName)) {
                ModelAndView mav = new ModelAndView("compose");
                mav.addObject("error", "User '" + recipientName + "' does not exist.");
                mav.addObject("recipientName", recipientName);
                mav.addObject("subject", subject);
                mav.addObject("messageText", messageText);
                return mav;
            }

            // Send the message using the correct DAO method
            messages.sendNote(userName, recipientName, subject, messageText);

            return new ModelAndView("redirect:/messages/sent?success=Message sent successfully");

        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mav = new ModelAndView("compose");
            mav.addObject("error", "Failed to send message: " + e.getMessage());
            mav.addObject("recipientName", recipientName);
            mav.addObject("subject", subject);
            mav.addObject("messageText", messageText);
            return mav;
        }
    }

    // View a specific message
    @GetMapping("/{messageId}")
    public ModelAndView viewMessage(@PathVariable int messageId, HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            return new ModelAndView("redirect:/welcome");
        }

        try {
            Message message = messages.getMessage(messageId);

            if (message == null) {
                return new ModelAndView("redirect:/messages?error=Message not found");
            }

            // Check if user has permission to view this message
            if (!userName.equals(message.getRecipientName()) && !userName.equals(message.getSenderName())) {
                return new ModelAndView("redirect:/messages?error=You don't have permission to view this message");
            }

            // Mark as read if user is the recipient
            if (userName.equals(message.getRecipientName()) && !message.isRead()) {
                messages.markAsRead(messageId, userName);
            }

            ModelAndView mav = new ModelAndView("view");
            mav.addObject("message", message);
            mav.addObject("userName", userName);

            // Add additional data for specific message types
            if (message.getMessageType() == Message.MessageType.CHALLENGE && message.getQuizId() != null) {
                try {
                    Quiz quiz = quizzes.getQuiz(message.getQuizId());
                    mav.addObject("quiz", quiz);
                } catch (Exception e) {
                    // Quiz might not exist anymore, ignore
                }
            }

            return mav;

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/messages?error=Failed to load message");
        }
    }

    // Delete message
    @PostMapping("/{messageId}/delete")
    @ResponseBody
    public Map<String, String> deleteMessage(@PathVariable int messageId, HttpSession session) {
        Map<String, String> result = new HashMap<String, String>();
        String userName = (String) session.getAttribute("name");

        if (userName == null) {
            result.put("status", "error");
            result.put("message", "Not authenticated");
            return result;
        }

        try {
            // CORRECT: Using both messageId AND userName parameters
            boolean deleted = messages.deleteMessage(messageId, userName);

            if (deleted) {
                result.put("status", "success");
                result.put("message", "Message deleted successfully");
            } else {
                result.put("status", "error");
                result.put("message", "Message not found or access denied");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "Failed to delete message: " + e.getMessage());
        }

        return result;
    }

    // Handle friend request response
    @PostMapping("/{messageId}/friend-request")
    @ResponseBody
    public Map<String, String> handleFriendRequest(@PathVariable int messageId,
                                                   @RequestParam String action,
                                                   HttpSession session) {
        String userName = (String) session.getAttribute("name");
        Map<String, String> result = new HashMap<String, String>();

        if (userName == null) {
            result.put("status", "error");
            result.put("message", "Not authenticated");
            return result;
        }

        try {
            Message message = messages.getMessage(messageId);

            if (message == null || !userName.equals(message.getRecipientName()) ||
                    message.getMessageType() != Message.MessageType.FRIEND_REQUEST) {
                result.put("status", "error");
                result.put("message", "Invalid friend request");
                return result;
            }

            if (message.getFriendRequestId() == null) {
                result.put("status", "error");
                result.put("message", "Friend request ID not found");
                return result;
            }

            FriendRequest friendRequest = friendRequests.findById(message.getFriendRequestId());

            if (friendRequest == null) {
                result.put("status", "error");
                result.put("message", "Friend request not found");
                return result;
            }

            if ("accept".equals(action)) {
                // Accept the friend request - create bidirectional friendship
                String requesterName = message.getSenderName();

                friendships.insertFriendship(userName, requesterName);
                friendships.insertFriendship(requesterName, userName);

                // Update friend request status
                friendRequests.updateStatus(message.getFriendRequestId(), "ACCEPTED");

                result.put("status", "success");
                result.put("message", "Friend request accepted");

            } else if ("decline".equals(action)) {
                // Decline the friend request
                friendRequests.updateStatus(message.getFriendRequestId(), "DECLINED");

                result.put("status", "success");
                result.put("message", "Friend request declined");

            } else {
                result.put("status", "error");
                result.put("message", "Invalid action");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "Failed to process friend request: " + e.getMessage());
        }

        return result;
    }

    // Send challenge message (can be called from quiz pages)
    @PostMapping("/challenge")
    public ModelAndView sendChallenge(@RequestParam String recipientName,
                                      @RequestParam int quizId,
                                      HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            return new ModelAndView("redirect:/welcome");
        }

        try {
            // Check if recipient exists
            if (!users.exists(recipientName)) {
                ModelAndView mav = new ModelAndView("redirect:/quiz/" + quizId);
                mav.addObject("error", "User '" + recipientName + "' does not exist.");
                return mav;
            }

            // Get the quiz
            Quiz quiz = quizzes.getQuiz(quizId);
            if (quiz == null) {
                ModelAndView mav = new ModelAndView("redirect:/quiz");
                mav.addObject("error", "Quiz not found.");
                return mav;
            }

            // Get the challenger's best score on this quiz
            List<QuizAttempt> userAttempts = quizAttempts.getAttemptsForUser(userName);
            QuizAttempt bestAttempt = null;

            for (QuizAttempt attempt : userAttempts) {
                if (attempt.getQuizId() == quizId && !attempt.isPracticeMode()) {
                    if (bestAttempt == null || attempt.getPercentage() > bestAttempt.getPercentage()) {
                        bestAttempt = attempt;
                    }
                }
            }

            if (bestAttempt == null) {
                ModelAndView mav = new ModelAndView("redirect:/quiz/" + quizId);
                mav.addObject("error", "You must complete this quiz before challenging someone.");
                return mav;
            }

            // Send the challenge message
            messages.sendChallenge(userName, recipientName, quizId, quiz.getQuizName(),
                    bestAttempt.getScore(), bestAttempt.getTotalQuestions());

            ModelAndView mav = new ModelAndView("redirect:/quiz/" + quizId);
            mav.addObject("success", "Challenge sent to " + recipientName + "!");
            return mav;

        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mav = new ModelAndView("redirect:/quiz/" + quizId);
            mav.addObject("error", "Failed to send challenge: " + e.getMessage());
            return mav;
        }
    }
}