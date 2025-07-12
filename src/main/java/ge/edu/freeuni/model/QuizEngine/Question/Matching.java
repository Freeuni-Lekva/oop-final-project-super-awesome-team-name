package ge.edu.freeuni.model.QuizEngine.Question;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

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


    public Object getPossibleAnswers() {
        ArrayList<String> keys = new ArrayList<String>(correctPairs.keySet());
        ArrayList<String> values = new ArrayList<>(correctPairs.values());
        HashMap<String,String> possibleAnswers = new HashMap<String,String>();

        while(!keys.isEmpty()){
            int keyIndex = new Random().nextInt(keys.size());
            int valueIndex = new Random().nextInt(values.size());
            possibleAnswers.put(keys.get(keyIndex),values.get(valueIndex));
            keys.remove(keyIndex);
            values.remove(valueIndex);
        }
        return possibleAnswers;
    }
}
