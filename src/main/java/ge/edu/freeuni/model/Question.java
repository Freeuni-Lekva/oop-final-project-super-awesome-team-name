package ge.edu.freeuni.model;

public class Question {
    private final int questionId;
    private final int quizId;
    private final String questionText;
    private final String questionType;
    private final int questionOrder;
    private final String correctAnswers; // JSON string
    private final String choices; // JSON string for multiple choice
    private final String imageUrl;

    public Question(int questionId, int quizId, String questionText, String questionType,
                    int questionOrder, String correctAnswers, String choices, String imageUrl) {
        this.questionId = questionId;
        this.quizId = quizId;
        this.questionText = questionText;
        this.questionType = questionType;
        this.questionOrder = questionOrder;
        this.correctAnswers = correctAnswers;
        this.choices = choices;
        this.imageUrl = imageUrl;
    }

    // Getters
    public int getQuestionId() { return questionId; }
    public int getQuizId() { return quizId; }
    public String getQuestionText() { return questionText; }
    public String getQuestionType() { return questionType; }
    public int getQuestionOrder() { return questionOrder; }
    public String getCorrectAnswers() { return correctAnswers; }
    public String getChoices() { return choices; }
    public String getImageUrl() { return imageUrl; }
}
