package ge.edu.freeuni.model.Quiz_Engine.Question;

import java.util.Arrays;
import java.util.List;

public class Multi_Choice_Multi_Answer extends Question {

    //private fields
    private List<String> correctAnswers;
    private List<String> possbileAnswers;


    public Multi_Choice_Multi_Answer(String question, String questiontype, List<String> possbileAnswers,List<String> correctAnswers) {
        super(question, questiontype);
        this.correctAnswers = correctAnswers;
        this.possbileAnswers = possbileAnswers;
    }

    @Override
    public List<String> getCorrectAnswer() {
        return correctAnswers;
    }

    public List<String> getPossbileAnswers() {
        return possbileAnswers;
    }

    @Override
    public boolean isCorrect(String userAnswer) {
        List<String> submitted = Arrays.asList(userAnswer.trim().split(","));
        return correctAnswers.containsAll(submitted) && submitted.containsAll(correctAnswers);
    }

}
