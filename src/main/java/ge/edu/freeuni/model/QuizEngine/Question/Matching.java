package ge.edu.freeuni.model.QuizEngine.Question;

import java.util.Map;

public class Matching extends Question {

    //private fields
    private Map<String,String> correctPairs;

    public Matching(String question,String questionType ,Map<String,String> correctPairs) {
        super(question,questionType);
        this.correctPairs = correctPairs;
    }


    @Override
    public boolean isCorrect(String userAnswer) {
        String[] pairs = userAnswer.split(";");
        if (pairs.length != correctPairs.size()) return false;

        for (String pair : pairs) {
            String[] kv = pair.split("=");
            if (kv.length != 2) return false;
            if (!correctPairs.containsKey(kv[0].trim())) return false;
            if (!correctPairs.get(kv[0].trim()).equalsIgnoreCase(kv[1].trim())) return false;
        }

        return true;
    }

    @Override
    public Map<String,String> getCorrectAnswer() {
        return correctPairs;
    }
}
