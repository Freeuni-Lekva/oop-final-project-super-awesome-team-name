package ge.edu.freeuni.model.QuizEngine.Question;

import java.util.Objects;

public abstract class Question {

    // private fields
    private int questionID;
    private int quizID;
    private String question;
    private String questiontype;
    private String CreatorUsername;

    public Question(){}

    public Question(String question, String questiontype) {
        this.question = question;
        this.questiontype = questiontype;
    }

    public int getQuizID(){
        return quizID;
    }

    public void setQuizID(int QuizID) {
        this.quizID = QuizID;
    }

    public int getQuestionID() {
        return questionID;
    }

    public void setQuestionID(int questionID) {
        this.questionID = questionID;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getQuestionType(){
        return questiontype;
    }

    public void setQuestionType(String questionType) {
        this.questiontype = questionType;
    }

    public String getCreatorUsername() {
        return CreatorUsername;
    }

    public void setCreatorUsername(String CreatorUsername) {
        this.CreatorUsername = CreatorUsername;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Question question1 = (Question) o;

        return questionID == question1.questionID &&
                quizID == question1.quizID &&
                question.equals(question1.question) &&
                questiontype.equals(question1.questiontype) &&
                CreatorUsername.equals(question1.CreatorUsername);
    }

    @Override
    public int hashCode() {
        return Objects.hash(questionID, quizID, question, questiontype, CreatorUsername);
    }

    @Override
    public String toString() {
        return "Question{" +
                "questionID=" + questionID +
                ", quizID=" + quizID +
                ", question='" + question + '\'' +
                ", questionType='" + questiontype + '\'' +
                ", creator='" + CreatorUsername + '\'' +
                '}';
    }



    public abstract boolean isCorrect(String userAnswer);

    public abstract Object getCorrectAnswer();

}
