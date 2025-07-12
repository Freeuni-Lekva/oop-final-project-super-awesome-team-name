package ge.edu.freeuni.model;

import java.sql.Timestamp;

public class Message {
    public enum MessageType {
        FRIEND_REQUEST, CHALLENGE, NOTE
    }

    private final int messageId;
    private final String senderName;
    private final String recipientName;
    private final MessageType messageType;
    private final String subject;
    private final String messageText;
    private final boolean isRead;
    private final Timestamp createdAt;

    // Optional fields for specific message types
    private final Integer friendRequestId;
    private final Integer quizId;
    private final Integer challengerScore;
    private final Integer challengerTotalQuestions;

    public Message(int messageId, String senderName, String recipientName,
                   MessageType messageType, String subject, String messageText,
                   boolean isRead, Timestamp createdAt, Integer friendRequestId,
                   Integer quizId, Integer challengerScore, Integer challengerTotalQuestions) {
        this.messageId = messageId;
        this.senderName = senderName;
        this.recipientName = recipientName;
        this.messageType = messageType;
        this.subject = subject;
        this.messageText = messageText;
        this.isRead = isRead;
        this.createdAt = createdAt;
        this.friendRequestId = friendRequestId;
        this.quizId = quizId;
        this.challengerScore = challengerScore;
        this.challengerTotalQuestions = challengerTotalQuestions;
    }

    // Getters
    public int getMessageId() { return messageId; }
    public String getSenderName() { return senderName; }
    public String getRecipientName() { return recipientName; }
    public MessageType getMessageType() { return messageType; }
    public String getSubject() { return subject; }
    public String getMessageText() { return messageText; }
    public boolean isRead() { return isRead; }
    public Timestamp getCreatedAt() { return createdAt; }
    public Integer getFriendRequestId() { return friendRequestId; }
    public Integer getQuizId() { return quizId; }
    public Integer getChallengerScore() { return challengerScore; }
    public Integer getChallengerTotalQuestions() { return challengerTotalQuestions; }

    // Helper methods
    public double getChallengerPercentage() {
        if (challengerScore != null && challengerTotalQuestions != null && challengerTotalQuestions > 0) {
            return (double) challengerScore / challengerTotalQuestions * 100;
        }
        return 0;
    }

    public String getFormattedChallengerScore() {
        if (challengerScore != null && challengerTotalQuestions != null) {
            return challengerScore + "/" + challengerTotalQuestions;
        }
        return "";
    }
}