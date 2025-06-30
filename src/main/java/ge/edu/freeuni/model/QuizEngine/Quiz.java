package ge.edu.freeuni.model.QuizEngine;

import ge.edu.freeuni.model.QuizEngine.Question.Question;

import java.util.ArrayList;
import java.util.List;

public class Quiz {

    // private literals
    private int QuizzID;
    private String QuizzName;
    private String Description;
    private int NQuestions;
    private boolean RandomOrder;
    private boolean OnePage;
    private boolean ImmediateCorrection;
    private boolean PracticeMode;
    private List<Question> Questions;
    private String CreatorUsername;

    public Quiz() {}

    public Quiz(String QuizzName, String Description, int NQuestions, boolean RandomOrder,
                boolean OnePage, boolean ImmediateCorrection, boolean PracticeMode, List<Question> Questions,
                 String CreatorUsername) {
        this.QuizzName = QuizzName;
        this.Description = Description;
        this.NQuestions = NQuestions;
        this.RandomOrder = RandomOrder;
        this.OnePage = OnePage;
        this.ImmediateCorrection = ImmediateCorrection;
        this.PracticeMode = PracticeMode;
        this.Questions = Questions;
        this.CreatorUsername = CreatorUsername;
    }

    public int getQuizzID() {
        return QuizzID;
    }

    public void setQuizzID(int QuizzID) {
        this.QuizzID = QuizzID;
    }

    public String getQuizzName() {
        return QuizzName;
    }

    public void setQuizzName(String QuizzName) {
        this.QuizzName = QuizzName;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String Description) {
        this.Description = Description;
    }

    public int getNQuestions() {
        return NQuestions;
    }

    public void setNQuestions(int NQuestions) {
        this.NQuestions = NQuestions;
    }

    public boolean isRandomOrder() {
        return RandomOrder;
    }

    public void setRandomOrder(boolean RandomOrder) {
        this.RandomOrder = RandomOrder;
    }

    public boolean isOnePage() {
        return OnePage;
    }

    public void setOnePage(boolean OnePage) {
        this.OnePage = OnePage;
    }

    public boolean isImmediateCorrection() {
        return ImmediateCorrection;
    }

    public void setImmediateCorrection(boolean ImmediateCorrection) {
        this.ImmediateCorrection = ImmediateCorrection;
    }

    public boolean isPracticeMode() {
        return PracticeMode;
    }

    public void setPracticeMode(boolean PracticeMode) {
        this.PracticeMode = PracticeMode;
    }

    public List<Question> getQuestions() {
        return Questions;
    }

    public void setQuestions(List<Question> Questions) {
        this.Questions = Questions;
    }

    public List<List<String>> getCorrectAnswer() {
        List<List<String>> ans = new ArrayList<>();
        for(int i=0; i < NQuestions; i++) {


        }
        return ans;
    }

    public List<List<String>> getPotentialAnswersList() {
        List<List<String>> ans = new ArrayList<>();
        for(int i=0; i < NQuestions; i++) {

        }
        return ans;
    }

    public String getCreatorUsername() {
        return CreatorUsername;
    }

    public void setCreatorUsername(String CreatorUsername) {
        this.CreatorUsername = CreatorUsername;
    }

}
