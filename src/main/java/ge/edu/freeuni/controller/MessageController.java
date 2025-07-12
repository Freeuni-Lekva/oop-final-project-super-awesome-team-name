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

        ModelAndView mav = new ModelAndView("messages/inbox");

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

        ModelAndView mav = new ModelAndView("messages/sent");

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

        ModelAndView mav = new ModelAndView("messages/compose");
        mav.addObject("userName", userName);
        mav.addObject("recipientName", to != null ? to : "");
        mav.addObject("subject", subject != null ? subject : "");

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
                ModelAndView mav = new ModelAndView("messages/compose");
                mav.addObject("error", "User '" + recipientName + "' does not exist.");
                mav.addObject("recipientName", recipientName);
                mav.addObject("subject", subject);
                mav.addObject("messageText", messageText);
                return mav;
            }

            // Send the message
            messages.sendNote(userName, recipientName, subject, messageText);

            ModelAndView mav = new ModelAndView("redirect:/messages/sent");
            mav.addObject("success", "Message sent successfully!");
            return mav;

        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mav = new ModelAndView("messages/compose");
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
                ModelAndView mav = new ModelAndView("redirect:/messages");
                mav.addObject("error", "Message not found.");
                return mav;
            }

            // Check if user has permission to view this message
            if (!userName.equals(message.getRecipientName()) && !userName.equals(message.getSenderName())) {
                ModelAndView mav = new ModelAndView("redirect:/messages");
                mav.addObject("error", "You don't have permission to view this message.");
                return mav;
            }

            // Mark as read if user is the recipient
            if (userName.equals(message.getRecipientName()) && !message.isRead()) {
                messages.markAsRead(messageId, userName);
            }

            ModelAndView mav = new ModelAndView("messages/view");
            mav.addObject("message", message);
            mav.addObject("userName", userName);

            // Add additional data for specific message types
            if (message.getMessageType() == Message.MessageType.CHALLENGE && message.getQuizId() != null) {
                Quiz quiz = quizzes.getQuiz(message.getQuizId());
                mav.addObject("quiz", quiz);
            }

            return mav;

        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mav = new ModelAndView("redirect:/messages");
            mav.addObject("error", "Failed to load message: " + e.getMessage());
            return mav;
        }
    }

    // Handle friend request response
    @PostMapping("/{messageId}/friend-request")
    @ResponseBody
    public Map<String, String> handleFriendRequest(@PathVariable int messageId,
                                                   @RequestParam String action,
                                                   HttpSession session) {
        String userName = (String) session.getAttribute("name");
        Map<String, String> result = new HashMap<>();

        try {
            Message message = messages.getMessage(messageId);

            if (message == null || !userName.equals(message.getRecipientName()) ||
                    message.getMessageType() != Message.MessageType.FRIEND_REQUEST) {
                result.put("status", "error");
                result.put("message", "Invalid friend request.");
                return result;
            }

            if (message.getFriendRequestId() == null) {
                result.put("status", "error");
                result.put("message", "Friend request ID not found.");
                return result;
            }

            FriendRequest friendRequest = friendRequests.findById(message.getFriendRequestId());

            if (friendRequest == null) {
                result.put("status", "error");
                result.put("message", "Friend request not found.");
                return result;
            }

            if ("accept".equals(action)) {
                // Accept the friend request
                friendRequests.updateStatus(message.getFriendRequestId(), "ACCEPTED");

                // Create friendship entries (bidirectional)
                friendships.insertFriendship(friendRequest.getRequesterName(), friendRequest.getRequesteeName());
                friendships.insertFriendship(friendRequest.getRequesteeName(), friendRequest.getRequesterName());

                result.put("status", "success");
                result.put("message", "Friend request accepted! You are now friends with " + message.getSenderName());

            } else if ("decline".equals(action)) {
                // Decline the friend request
                friendRequests.updateStatus(message.getFriendRequestId(), "DECLINED");

                result.put("status", "success");
                result.put("message", "Friend request declined.");
            } else {
                result.put("status", "error");
                result.put("message", "Invalid action.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "Failed to process friend request: " + e.getMessage());
        }

        return result;
    }

    // Send a challenge
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

    // Delete a message
    @PostMapping("/{messageId}/delete")
    @ResponseBody
    public Map<String, String> deleteMessage(@PathVariable int messageId, HttpSession session) {
        String userName = (String) session.getAttribute("name");
        Map<String, String> result = new HashMap<>();

        try {
            boolean deleted = messages.deleteMessage(messageId, userName);

            if (deleted) {
                result.put("status", "success");
                result.put("message", "Message deleted successfully.");
            } else {
                result.put("status", "error");
                result.put("message", "Failed to delete message or message not found.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "Failed to delete message: " + e.getMessage());
        }

        return result;
    }

    // Get unread message count (for AJAX)
    @GetMapping("/unread-count")
    @ResponseBody
    public Map<String, Integer> getUnreadCount(HttpSession session) {
        String userName = (String) session.getAttribute("name");
        Map<String, Integer> result = new HashMap<>();

        if (userName != null) {
            try {
                int count = messages.getUnreadCount(userName);
                result.put("count", count);
            } catch (Exception e) {
                result.put("count", 0);
            }
        } else {
            result.put("count", 0);
        }

        return result;
    }
}