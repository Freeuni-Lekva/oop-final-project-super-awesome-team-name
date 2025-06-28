package Quiz_Engine.Question;

public class Picture_Response extends Question {

    //private fields
    private String imageURL;
    private String correctAnswer;

    public Picture_Response(String question, String questiontype, String imageURL, String correctAnswer) {
        super(question, questiontype);
        this.imageURL = imageURL;
        this.correctAnswer = correctAnswer;
    }

    public String getImageURL() {
        return imageURL;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    @Override
    public boolean isCorrect(String userAnswer) {
        return correctAnswer.equalsIgnoreCase(userAnswer.trim());
    }
}
