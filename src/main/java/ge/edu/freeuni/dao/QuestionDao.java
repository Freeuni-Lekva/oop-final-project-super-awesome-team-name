package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.Question;
import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Component("questions")
public class QuestionDao {

    @Autowired
    private BasicDataSource db;

    public List<Question> getQuestionsForQuiz(int quizId, boolean randomOrder) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE quiz_id = ? ORDER BY question_order";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quizId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    questions.add(new Question(
                            rs.getInt("question_id"),
                            rs.getInt("quiz_id"),
                            rs.getString("question_text"),
                            rs.getString("question_type"),
                            rs.getInt("question_order"),
                            rs.getString("correct_answers"),
                            rs.getString("choices"),
                            rs.getString("image_url")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get questions for quiz: " + quizId, e);
        }

        if (randomOrder) {
            Collections.shuffle(questions);
        }

        return questions;
    }

    public Question get(int questionId) {
        String sql = "SELECT * FROM questions WHERE question_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, questionId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Question(
                            rs.getInt("question_id"),
                            rs.getInt("quiz_id"),
                            rs.getString("question_text"),
                            rs.getString("question_type"),
                            rs.getInt("question_order"),
                            rs.getString("correct_answers"),
                            rs.getString("choices"),
                            rs.getString("image_url")
                    );
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get question: " + questionId, e);
        }
        return null;
    }

    public int getQuestionCount(int quizId) {
        String sql = "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quizId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to count questions for quiz: " + quizId, e);
        }
        return 0;
    }
}