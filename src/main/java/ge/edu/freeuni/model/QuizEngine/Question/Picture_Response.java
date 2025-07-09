package ge.edu.freeuni.model.QuizEngine.Question;

import java.util.StringTokenizer;

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
