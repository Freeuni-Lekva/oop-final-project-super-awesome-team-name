package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.Quiz;
import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component("quizzes")
public class QuizDao {

    @Autowired
    private BasicDataSource db;

    public Quiz get(int quizId) {
        String sql = "SELECT * FROM quizzes WHERE quiz_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quizId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Quiz(
                            rs.getInt("quiz_id"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getString("creator_name"),
                            rs.getTimestamp("created_date"),
                            rs.getBoolean("is_random_order"),
                            rs.getBoolean("is_single_page"),
                            rs.getBoolean("immediate_correction"),
                            rs.getBoolean("allow_practice_mode")
                    );
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get quiz: " + quizId, e);
        }
        return null;
    }

    public List<Quiz> getAllQuizzes() {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quizzes ORDER BY created_date DESC";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                quizzes.add(new Quiz(
                        rs.getInt("quiz_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("creator_name"),
                        rs.getTimestamp("created_date"),
                        rs.getBoolean("is_random_order"),
                        rs.getBoolean("is_single_page"),
                        rs.getBoolean("immediate_correction"),
                        rs.getBoolean("allow_practice_mode")
                ));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get all quizzes", e);
        }
        return quizzes;
    }

    public List<Quiz> getPopularQuizzes(int limit) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT q.*, COUNT(qa.attempt_id) as attempt_count " +
                "FROM quizzes q " +
                "LEFT JOIN quiz_attempts qa ON q.quiz_id = qa.quiz_id " +
                "GROUP BY q.quiz_id " +
                "ORDER BY attempt_count DESC, q.created_date DESC " +
                "LIMIT ?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    quizzes.add(new Quiz(
                            rs.getInt("quiz_id"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getString("creator_name"),
                            rs.getTimestamp("created_date"),
                            rs.getBoolean("is_random_order"),
                            rs.getBoolean("is_single_page"),
                            rs.getBoolean("immediate_correction"),
                            rs.getBoolean("allow_practice_mode")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get popular quizzes", e);
        }
        return quizzes;
    }
}