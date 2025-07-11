package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.QuizAttempt;
import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component("quizAttempts")
public class QuizAttemptDao {

    @Autowired
    private BasicDataSource db;

    public int add(String userName, int quizId, int score, int totalQuestions,
                   int timeTaken, String answers, String correctAnswers, boolean isPracticeMode) {
        String sql = "INSERT INTO quiz_attempts (user_name, quiz_id, score, total_questions, " +
                "time_taken, answers, correct_answers, is_practice_mode) VALUES (?,?,?,?,?,?,?,?)";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, userName);
            ps.setInt(2, quizId);
            ps.setInt(3, score);
            ps.setInt(4, totalQuestions);
            ps.setInt(5, timeTaken);
            ps.setString(6, answers);
            ps.setString(7, correctAnswers);
            ps.setBoolean(8, isPracticeMode);

            if (ps.executeUpdate() == 0) {
                throw new RuntimeException("Failed to add quiz attempt");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new RuntimeException("Failed to retrieve attempt ID");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to add quiz attempt", e);
        }
    }

    public List<QuizAttempt> getAttemptsForUser(String userName) {
        List<QuizAttempt> attempts = new ArrayList<>();
        String sql = "SELECT * FROM quiz_attempts WHERE user_name = ? ORDER BY attempt_date DESC";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    attempts.add(new QuizAttempt(
                            rs.getInt("attempt_id"),
                            rs.getString("user_name"),
                            rs.getInt("quiz_id"),
                            rs.getInt("score"),
                            rs.getInt("total_questions"),
                            rs.getInt("time_taken"),
                            rs.getTimestamp("attempt_date"),
                            rs.getString("answers"),
                            rs.getString("correct_answers"),
                            rs.getBoolean("is_practice_mode")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to getQuiz attempts for user: " + userName, e);
        }
        return attempts;
    }

    public List<QuizAttempt> getTopScoresForQuiz(int quizId, int limit) {
        List<QuizAttempt> attempts = new ArrayList<>();
        String sql = "SELECT * FROM quiz_attempts " +
                "WHERE quiz_id = ? AND is_practice_mode = FALSE " +
                "ORDER BY (score/total_questions) DESC, time_taken ASC " +
                "LIMIT ?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    attempts.add(new QuizAttempt(
                            rs.getInt("attempt_id"),
                            rs.getString("user_name"),
                            rs.getInt("quiz_id"),
                            rs.getInt("score"),
                            rs.getInt("total_questions"),
                            rs.getInt("time_taken"),
                            rs.getTimestamp("attempt_date"),
                            rs.getString("answers"),
                            rs.getString("correct_answers"),
                            rs.getBoolean("is_practice_mode")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to getQuiz top scores for quiz: " + quizId, e);
        }
        return attempts;
    }

    public int getUserQuizCount(String userName) {
        String sql = "SELECT COUNT(*) FROM quiz_attempts WHERE user_name = ? AND is_practice_mode = FALSE";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to getQuiz quiz count for user: " + userName, e);
        }
        return 0;
    }

    public boolean deleteQuizHistory(int quizId){
        String sql = "DELETE FROM quiz_attempts WHERE quiz_id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement stmt =  conn.prepareStatement(sql)) {
            stmt.setInt(1, quizId);

            return stmt.executeUpdate()==1;

        }catch (SQLException e){
            throw new RuntimeException("Failed to delete quiz attempt", e);
        }

    }

}