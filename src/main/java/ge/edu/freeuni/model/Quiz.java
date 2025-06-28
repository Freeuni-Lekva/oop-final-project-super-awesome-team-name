// Quiz.java
package ge.edu.freeuni.model;

import java.sql.Timestamp;

public class Quiz {
    private final int quizId;
    private final String title;
    private final String description;
    private final String creatorName;
    private final Timestamp createdDate;
    private final boolean isRandomOrder;
    private final boolean isSinglePage;
    private final boolean immediateCorrection;
    private final boolean allowPracticeMode;

    public Quiz(int quizId, String title, String description, String creatorName,
                Timestamp createdDate, boolean isRandomOrder, boolean isSinglePage,
                boolean immediateCorrection, boolean allowPracticeMode) {
        this.quizId = quizId;
        this.title = title;
        this.description = description;
        this.creatorName = creatorName;
        this.createdDate = createdDate;
        this.isRandomOrder = isRandomOrder;
        this.isSinglePage = isSinglePage;
        this.immediateCorrection = immediateCorrection;
        this.allowPracticeMode = allowPracticeMode;
    }

    // Getters
    public int getQuizId() { return quizId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getCreatorName() { return creatorName; }
    public Timestamp getCreatedDate() { return createdDate; }
    public boolean isRandomOrder() { return isRandomOrder; }
    public boolean isSinglePage() { return isSinglePage; }
    public boolean isImmediateCorrection() { return immediateCorrection; }
    public boolean isAllowPracticeMode() { return allowPracticeMode; }
}


