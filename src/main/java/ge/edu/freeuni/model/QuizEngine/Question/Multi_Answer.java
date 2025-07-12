package ge.edu.freeuni.model.QuizEngine.Question;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Multi_Answer extends Question {

    //private literals

    private List<String> correctAnswers;
    private boolean orderMatters;

    public Multi_Answer(String question, String questiontype, boolean orderMatters ,List<String> correctAnswer) {
        super(question, questiontype);
        this.correctAnswers = correctAnswer;
        this.orderMatters = orderMatters;
    }

    public boolean orderMatters() {
        return orderMatters;
    }

    @Override
    public List<String> getCorrectAnswer() {
        return correctAnswers;
    }


    @Override
    public boolean isCorrect(String userAnswer) {
        String[] parts = userAnswer.split(",");
        if (parts.length != correctAnswers.size()) return false;

        List<String> userAnswers = new ArrayList<>();
        for (String part : parts) {
            userAnswers.add(part.trim());
        }

        if (orderMatters) {
            for (int i = 0; i < userAnswers.size(); i++) {
                if (!userAnswers.get(i).equalsIgnoreCase(correctAnswers.get(i).trim())) {
                    return false;
                }
            }
            return true;
        } else {
            if (userAnswers.size() != correctAnswers.size()) return false;

            Collections.sort(userAnswers, String.CASE_INSENSITIVE_ORDER);
            Collections.sort(correctAnswers, String.CASE_INSENSITIVE_ORDER);

            for (int i = 0; i < userAnswers.size(); i++) {
                if (!userAnswers.get(i).equalsIgnoreCase(correctAnswers.get(i).trim())) {
                    return false;
                }
            }
            return true;
        }
    }
}
