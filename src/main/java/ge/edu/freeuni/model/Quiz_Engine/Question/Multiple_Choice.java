package ge.edu.freeuni.model.Quiz_Engine.Question;

import java.util.List;

public class Multiple_Choice extends Question {

    //private fields
    private List<String> possibleAnswers;
    private String correctAnswer;

    public Multiple_Choice(String question,String questionType, List<String> possibleAnswers,String correctAnswer) {
        super(question, questionType);
        this.correctAnswer = correctAnswer;
        this.possibleAnswers = possibleAnswers;
    }

    public List<String> getPossibleAnswers() {
        return possibleAnswers;
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
