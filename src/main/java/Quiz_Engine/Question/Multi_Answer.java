package Quiz_Engine.Question;

import java.util.Arrays;
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
        // Assume answers are submitted as comma-separated
        String[] parts = userAnswer.split(",");
        if (parts.length != correctAnswers.size()) return false;

        for (int i = 0; i < parts.length; i++) {
            if (orderMatters) {
                if (!parts[i].trim().equalsIgnoreCase(correctAnswers.get(i))) return false;
            } else {
                if (!correctAnswers.contains(parts[i].trim())) return false;
            }
        }

        return !orderMatters || isSameSet(parts, correctAnswers);
    }


    private boolean isSameSet(String[] a, List<String> b) {
        return b.containsAll(Arrays.asList(a)) && a.length == b.size();
    }
}
