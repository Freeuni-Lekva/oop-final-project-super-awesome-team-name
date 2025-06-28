package Quiz_Engine;

import Quiz_Engine.Question.*;
import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


import java.sql.*;
import java.util.*;


@Component("quizzes")
public class QuizDAO {
    private final Connection conn;


    //@Autowired
    private BasicDataSource dataSource;


    public QuizDAO(Connection conn) {
        this.conn = conn;
    }

    // INSERT a new quiz and return its generated ID
    public int insertQuiz(Quiz quiz) throws SQLException {
        String sql = "INSERT INTO quizzes (name, description, num_questions, random_order, one_page,immediate_correction, practice_mode) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, quiz.getQuizzName());
            stmt.setString(2, quiz.getDescription());
            stmt.setBoolean(3, quiz.isRandomOrder());
            stmt.setBoolean(4, quiz.isOnePage());
            stmt.setBoolean(5, quiz.isImmediateCorrection());
            stmt.setBoolean(6, quiz.isPracticeMode());
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // return the generated quiz ID
                }
            }
        }
        throw new SQLException("Failed to insert quiz.");
    }

    // INSERT multiple questions for a quiz
    public void insertQuestions(int quizId, List<Question> questions) throws SQLException {
        String sql = "INSERT INTO questions (quiz_id, question_text, question_type, possible_answers, correct_answer, imageURL, order_matters) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (Question question : questions) {
                stmt.setInt(1, quizId);
                stmt.setString(2, question.getQuestion());
                stmt.setString(3, question.getQuestionType());

                // Defaults
                String possibleAnswers = null;
                String correctAnswer = null;
                String imageURL = null;
                boolean orderMatters = false;

                if (question instanceof Question_Response || question instanceof Fill_In_The_Blank) {
                    correctAnswer = (String) question.getCorrectAnswer();
                } else if (question instanceof Multiple_Choice) {
                    Multiple_Choice mc = (Multiple_Choice) question;
                    possibleAnswers = String.join(",", mc.getPossibleAnswers());
                    correctAnswer = mc.getCorrectAnswer();
                } else if (question instanceof Picture_Response) {
                    Picture_Response pr = (Picture_Response) question;
                    imageURL = pr.getImageURL();
                    correctAnswer = pr.getCorrectAnswer();
                } else if (question instanceof Multi_Answer) {
                    Multi_Answer ma = (Multi_Answer) question;
                    correctAnswer = String.join(",", ma.getCorrectAnswer());
                    orderMatters = ma.orderMatters();
                } else if (question instanceof Multi_Choice_Multi_Answer) {
                    Multi_Choice_Multi_Answer mcm = (Multi_Choice_Multi_Answer) question;
                    possibleAnswers = String.join(",", mcm.getPossbileAnswers());
                    correctAnswer = String.join(",", mcm.getCorrectAnswer());
                } else if (question instanceof Matching) {
                    Matching match = (Matching) question;
                    Map<String,String> pairs = match.getCorrectAnswer();
                    StringBuilder sb = new StringBuilder();

                    for (var entry : pairs.entrySet()) {
                        sb.append(entry.getKey()).append("=").append(entry.getValue()).append(";");
                    }
                    correctAnswer = sb.toString(); // reuse correct_answer column
                }

                stmt.setString(4, possibleAnswers);
                stmt.setString(5, correctAnswer);
                stmt.setString(6, imageURL);
                stmt.setBoolean(7, orderMatters);

                stmt.addBatch();
            }

            stmt.executeBatch();
        }
    }


    // DELETE a quiz by ID (with ON DELETE CASCADE to auto-remove questions)
    public void deleteQuiz(int quizId) throws SQLException {
        String sql = "DELETE FROM quizzes WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizId);
            stmt.executeUpdate();
        }
    }

    // GET a quiz by ID
    public Quiz getQuiz(int quizId) throws SQLException {
        String sql = "SELECT * FROM quizzes WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Quiz quiz = new Quiz();
                    quiz.setQuizzID(rs.getInt("id"));
                    quiz.setQuizzName(rs.getString("title"));
                    quiz.setDescription(rs.getString("description"));
                    quiz.setRandomOrder(rs.getBoolean("random_order"));
                    quiz.setOnePage(rs.getBoolean("one_page"));
                    quiz.setImmediateCorrection(rs.getBoolean("immediate_correction"));
                    quiz.setPracticeMode(rs.getBoolean("practice_mode"));
                    quiz.setQuestions(getQuestions(quizId));
                    return quiz;
                }
            }
        }
        return null;
    }

    // GET all questions for a quiz
    public List<Question> getQuestions(int quizId) throws SQLException {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE quiz_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String prompt = rs.getString("question_text");
                    String type = rs.getString("question_type");
                    String correct = rs.getString("correct_answer");
                    String choices = rs.getString("possible_answers");
                    String image = rs.getString("imageURL");
                    boolean orderMatters = rs.getBoolean("order_matters");
                    String extra = rs.getString("extra_data"); // for things like matching pairs or multi-answers

                    Question q;

                    switch (type) {
                        case "Question-Response":
                            q = new Question_Response(prompt, type, correct);
                            break;
                        case "Fill in the Blank":
                            q = new Fill_In_The_Blank(prompt, type, correct);
                            break;
                        case "Multiple Choice":
                            List<String> choiceList = Arrays.asList(choices.split(","));
                            q = new Multiple_Choice(prompt, type,choiceList,correct);
                            break;
                        case "Picture-Response":
                            q = new Picture_Response(prompt, type, image,correct);
                            break;
                        case "Multi-Answer":
                            List<String> correctAnswers = Arrays.asList(correct.split(","));
                            q = new Multi_Answer(prompt, type,orderMatters ,correctAnswers);
                            break;
                        case "Multiple Choice with Multiple Answers":
                            List<String> multiChoices = Arrays.asList(choices.split(","));
                            List<String> multiCorrect = Arrays.asList(correct.split(","));
                            q = new Multi_Choice_Multi_Answer(prompt, type, multiChoices, multiCorrect);
                            break;
                        case "Matching":
                            // Assume extra is like: "term1=match1;term2=match2"
                            q = new Matching(prompt,type,new HashMap<String,String>());

                            break;
                        default:
                            throw new SQLException("Unknown question type: " + type);
                    }

                    q.setQuestionID(id);
                    q.setQuizzID(rs.getInt("quiz_id"));
                    questions.add(q);
                }
            }
        }
        return questions;
    }



    // GET all quizzes
    public List<Quiz> getAllQuizzes() throws SQLException {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quizzes";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Quiz quiz = new Quiz();
                int quizId = rs.getInt("id");
                quiz.setQuizzID(quizId);
                quiz.setQuizzName(rs.getString("title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setRandomOrder(rs.getBoolean("random_order"));
                quiz.setOnePage(rs.getBoolean("one_page"));
                quiz.setImmediateCorrection(rs.getBoolean("immediate_correction"));
                quiz.setPracticeMode(rs.getBoolean("practice_mode"));
                quiz.setQuestions(getQuestions(quizId));
                quizzes.add(quiz);
            }
        }
        return quizzes;
    }
}
