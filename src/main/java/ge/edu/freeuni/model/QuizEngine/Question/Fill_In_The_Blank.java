package ge.edu.freeuni.model.QuizEngine.Question;

public class Fill_In_The_Blank extends Question {

    //private fields
    private String correctAnswer;


    public Fill_In_The_Blank(String question, String questiontype, String correctAnswer) {
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
