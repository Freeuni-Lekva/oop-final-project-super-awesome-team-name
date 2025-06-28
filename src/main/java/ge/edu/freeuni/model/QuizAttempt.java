package ge.edu.freeuni.model;

import java.sql.Timestamp;

public class QuizAttempt {
    private final int attemptId;
    private final String userName;
    private final int quizId;
    private final int score;
    private final int totalQuestions;
    private final int timeTaken;
    private final Timestamp attemptDate;
    private final String answers;
    private final String correctAnswers;
    private final boolean isPracticeMode;

    public QuizAttempt(int attemptId, String userName, int quizId, int score, int totalQuestions,
                       int timeTaken, Timestamp attemptDate, String answers, String correctAnswers,
                       boolean isPracticeMode) {
        this.attemptId = attemptId;
        this.userName = userName;
        this.quizId = quizId;
        this.score = score;
        this.totalQuestions = totalQuestions;
        this.timeTaken = timeTaken;
        this.attemptDate = attemptDate;
        this.answers = answers;
        this.correctAnswers = correctAnswers;
        this.isPracticeMode = isPracticeMode;
    }

    public double getPercentage() {
        return totalQuestions > 0 ? (double) score / totalQuestions * 100 : 0;
    }

    // Getters
    public int getAttemptId() { return attemptId; }
    public String getUserName() { return userName; }
    public int getQuizId() { return quizId; }
    public int getScore() { return score; }
    public int getTotalQuestions() { return totalQuestions; }
    public int getTimeTaken() { return timeTaken; }
    public Timestamp getAttemptDate() { return attemptDate; }
    public String getAnswers() { return answers; }
    public String getCorrectAnswers() { return correctAnswers; }
    public boolean isPracticeMode() { return isPracticeMode; }
}