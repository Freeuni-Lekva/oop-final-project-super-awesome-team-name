package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.Message;
import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component("messages")
public class MessageDao {

    @Autowired
    private BasicDataSource db;

    // Send a simple note message
    public int sendNote(String senderName, String recipientName, String subject, String messageText) {
        String sql = "INSERT INTO messages (sender_name, recipient_name, message_type, subject, message_text) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, senderName);
            ps.setString(2, recipientName);
            ps.setString(3, "NOTE");
            ps.setString(4, subject);
            ps.setString(5, messageText);

            if (ps.executeUpdate() == 0) {
                throw new RuntimeException("Failed to send message");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new RuntimeException("Failed to retrieve message ID");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to send note message", e);
        }
    }

    // Send a friend request message
    public int sendFriendRequest(String senderName, String recipientName, int friendRequestId) {
        String sql = "INSERT INTO messages (sender_name, recipient_name, message_type, subject, message_text, friend_request_id) VALUES (?, ?, ?, ?, ?, ?)";

        String subject = "Friend Request from " + senderName;
        String messageText = senderName + " wants to be your friend. Click the buttons below to accept or decline this request.";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, senderName);
            ps.setString(2, recipientName);
            ps.setString(3, "FRIEND_REQUEST");
            ps.setString(4, subject);
            ps.setString(5, messageText);
            ps.setInt(6, friendRequestId);

            if (ps.executeUpdate() == 0) {
                throw new RuntimeException("Failed to send friend request message");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new RuntimeException("Failed to retrieve message ID");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to send friend request message", e);
        }
    }

    // Send a challenge message
    public int sendChallenge(String senderName, String recipientName, int quizId,
                             String quizName, int challengerScore, int challengerTotalQuestions) {
        String sql = "INSERT INTO messages (sender_name, recipient_name, message_type, subject, message_text, quiz_id, challenger_score, challenger_total_questions) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        String subject = "Quiz Challenge: " + quizName;
        double percentage = challengerTotalQuestions > 0 ? (double) challengerScore / challengerTotalQuestions * 100 : 0;
        String messageText = String.format("%s has challenged you to beat their score on '%s'! " +
                        "They scored %d/%d (%.1f%%). Think you can do better?",
                senderName, quizName, challengerScore, challengerTotalQuestions, percentage);

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, senderName);
            ps.setString(2, recipientName);
            ps.setString(3, "CHALLENGE");
            ps.setString(4, subject);
            ps.setString(5, messageText);
            ps.setInt(6, quizId);
            ps.setInt(7, challengerScore);
            ps.setInt(8, challengerTotalQuestions);

            if (ps.executeUpdate() == 0) {
                throw new RuntimeException("Failed to send challenge message");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new RuntimeException("Failed to retrieve message ID");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to send challenge message", e);
        }
    }

    // Get messages for a user (inbox)
    public List<Message> getMessagesForUser(String recipientName) {
        String sql = "SELECT * FROM messages WHERE recipient_name = ? ORDER BY created_at DESC";
        List<Message> messages = new ArrayList<Message>();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, recipientName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    messages.add(createMessageFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to get messages for user: " + recipientName, e);
        }

        return messages;
    }

    // Get sent messages for a user
    public List<Message> getSentMessagesForUser(String senderName) {
        String sql = "SELECT * FROM messages WHERE sender_name = ? ORDER BY created_at DESC";
        List<Message> messages = new ArrayList<Message>();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, senderName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    messages.add(createMessageFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to get sent messages for user: " + senderName, e);
        }

        return messages;
    }

    // Get a specific message by ID
    public Message getMessage(int messageId) {
        String sql = "SELECT * FROM messages WHERE message_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, messageId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return createMessageFromResultSet(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to get message: " + messageId, e);
        }

        return null;
    }

    // Mark a message as read
    public boolean markAsRead(int messageId, String recipientName) {
        String sql = "UPDATE messages SET is_read = TRUE WHERE message_id = ? AND recipient_name = ?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, messageId);
            ps.setString(2, recipientName);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Failed to mark message as read: " + messageId, e);
        }
    }

    // Get unread message count for a user
    public int getUnreadCount(String recipientName) {
        String sql = "SELECT COUNT(*) FROM messages WHERE recipient_name = ? AND is_read = FALSE";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, recipientName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to get unread count for user: " + recipientName, e);
        }

        return 0;
    }

    // Delete a message
    public boolean deleteMessage(int messageId, String userName) {
        String sql = "DELETE FROM messages WHERE message_id = ? AND (sender_name = ? OR recipient_name = ?)";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, messageId);
            ps.setString(2, userName);
            ps.setString(3, userName);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete message: " + messageId, e);
        }
    }

    // Helper method to create Message object from ResultSet
    private Message createMessageFromResultSet(ResultSet rs) throws SQLException {
        Message.MessageType messageType = Message.MessageType.valueOf(rs.getString("message_type"));

        Integer friendRequestId = rs.getObject("friend_request_id") != null ? rs.getInt("friend_request_id") : null;
        Integer quizId = rs.getObject("quiz_id") != null ? rs.getInt("quiz_id") : null;
        Integer challengerScore = rs.getObject("challenger_score") != null ? rs.getInt("challenger_score") : null;
        Integer challengerTotalQuestions = rs.getObject("challenger_total_questions") != null ? rs.getInt("challenger_total_questions") : null;

        return new Message(
                rs.getInt("message_id"),
                rs.getString("sender_name"),
                rs.getString("recipient_name"),
                messageType,
                rs.getString("subject"),
                rs.getString("message_text"),
                rs.getBoolean("is_read"),
                rs.getTimestamp("created_at"),
                friendRequestId,
                quizId,
                challengerScore,
                challengerTotalQuestions
        );
    }
}