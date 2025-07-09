package ge.edu.freeuni.model.QuizEngine.Question;

import java.util.StringTokenizer;

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
        boolean answer =  correctAnswer.equalsIgnoreCase(userAnswer.trim());

        //if the userAnswer and Correct answer don't match, try checking if it's a short version of the answer
        if(!answer){
            int spaceIndex = correctAnswer.indexOf(' ');
            if(spaceIndex == -1)return false;
            String before = correctAnswer.substring(0, spaceIndex);
            String after = correctAnswer.substring(spaceIndex+1);

            answer = before.equalsIgnoreCase(userAnswer.trim()) || after.equalsIgnoreCase(userAnswer.trim());
        }

        //if simple space separation doesn't work try every single separation
        if(!answer){
            StringTokenizer tokens = new StringTokenizer(correctAnswer," ");
            while(tokens.hasMoreTokens()){
                String token = tokens.nextToken();
                if(token.trim().equals(userAnswer.trim())){
                    answer = true;
                    break;
                }
            }
        }
        return answer;
    }



}
