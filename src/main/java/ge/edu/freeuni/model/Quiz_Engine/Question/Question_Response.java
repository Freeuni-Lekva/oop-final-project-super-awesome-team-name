package ge.edu.freeuni.model.Quiz_Engine.Question;

public class Question_Response extends Question {

    //private literals
    private String correctAnswer;

    public Question_Response(String question, String questiontype, String correctAnswer) {
        super(question, questiontype);
        this.correctAnswer = correctAnswer;
    }

    @Override
    public String getCorrectAnswer() {
        return correctAnswer;
    }

    @Override
    public boolean isCorrect(String userAnswer) {
        return correctAnswer.equalsIgnoreCase(userAnswer.trim());
    }


}
