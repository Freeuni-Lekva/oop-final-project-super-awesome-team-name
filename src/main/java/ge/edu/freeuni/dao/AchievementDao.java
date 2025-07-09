package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.Achievement;
import ge.edu.freeuni.model.UserAchievement;
import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component("achievements")
public class AchievementDao {

    @Autowired
    private BasicDataSource db;

    @Autowired
    private QuizAttemptDao quizAttempts;

    public List<UserAchievement> getUserAchievements(String userName) {
        List<UserAchievement> userAchievements = new ArrayList<>();
        String sql = "SELECT ua.user_achievement_id, ua.user_name, ua.achievement_id, ua.earned_date, " +
                "a.name, a.description, a.icon_url, a.condition_type, a.condition_value " +
                "FROM user_achievements ua " +
                "JOIN achievements a ON ua.achievement_id = a.achievement_id " +
                "WHERE ua.user_name = ? " +
                "ORDER BY ua.earned_date DESC";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Achievement achievement = new Achievement(
                            rs.getInt("achievement_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getString("icon_url"),
                            rs.getString("condition_type"),
                            rs.getInt("condition_value")
                    );

                    userAchievements.add(new UserAchievement(
                            rs.getInt("user_achievement_id"),
                            rs.getString("user_name"),
                            rs.getInt("achievement_id"),
                            rs.getTimestamp("earned_date"),
                            achievement
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get user achievements for: " + userName, e);
        }
        return userAchievements;
    }

    public boolean hasAchievement(String userName, int achievementId) {
        String sql = "SELECT COUNT(*) FROM user_achievements WHERE user_name = ? AND achievement_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);
            ps.setInt(2, achievementId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to check achievement for user: " + userName, e);
        }
        return false;
    }

    public int awardAchievement(String userName, int achievementId) {
        if (hasAchievement(userName, achievementId)) {
            return -1; // Already has achievement
        }

        String sql = "INSERT INTO user_achievements (user_name, achievement_id) VALUES (?, ?)";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, userName);
            ps.setInt(2, achievementId);

            if (ps.executeUpdate() == 0) {
                throw new RuntimeException("Failed to award achievement");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new RuntimeException("Failed to retrieve user achievement ID");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to award achievement to user: " + userName, e);
        }
    }

    // Check and award achievements automatically
    public List<Achievement> checkAndAwardAchievements(String userName) {
        List<Achievement> newAchievements = new ArrayList<>();

        try {
            // Check Amateur Author (created 1 quiz)
            if (!hasAchievement(userName, 1)) {
                int quizCreatedCount = getQuizCreatedCount(userName);
                if (quizCreatedCount >= 1) {
                    awardAchievement(userName, 1);
                    newAchievements.add(getAchievement(1));
                }
            }

            // Check Prolific Author (created 5 quizzes)
            if (!hasAchievement(userName, 2)) {
                int quizCreatedCount = getQuizCreatedCount(userName);
                if (quizCreatedCount >= 5) {
                    awardAchievement(userName, 2);
                    newAchievements.add(getAchievement(2));
                }
            }

            // Check Prodigious Author (created 10 quizzes)
            if (!hasAchievement(userName, 3)) {
                int quizCreatedCount = getQuizCreatedCount(userName);
                if (quizCreatedCount >= 10) {
                    awardAchievement(userName, 3);
                    newAchievements.add(getAchievement(3));
                }
            }

            // Check Quiz Machine (took 10 quizzes)
            if (!hasAchievement(userName, 4)) {
                int quizCount = quizAttempts.getUserQuizCount(userName);
                if (quizCount >= 10) {
                    awardAchievement(userName, 4);
                    newAchievements.add(getAchievement(4));
                }
            }

            // Check I am the Greatest (highest score on any quiz)
            if (!hasAchievement(userName, 5)) {
                if (hasHighestScore(userName)) {
                    awardAchievement(userName, 5);
                    newAchievements.add(getAchievement(5));
                }
            }

            // Check Practice Makes Perfect (took quiz in practice mode)
            if (!hasAchievement(userName, 6)) {
                if (hasPracticeMode(userName)) {
                    awardAchievement(userName, 6);
                    newAchievements.add(getAchievement(6));
                }
            }

            // Check Perfectionist (scored 100% on any quiz)
            if (!hasAchievement(userName, 7)) {
                if (hasPerfectScore(userName)) {
                    awardAchievement(userName, 7);
                    newAchievements.add(getAchievement(7));
                }
            }

            // Check Speed Demon (completed quiz in under 30 seconds)
            if (!hasAchievement(userName, 8)) {
                if (hasSpeedRun(userName)) {
                    awardAchievement(userName, 8);
                    newAchievements.add(getAchievement(8));
                }
            }

            // Check Dedicated Learner (took 25 quizzes)
            if (!hasAchievement(userName, 9)) {
                int quizCount = quizAttempts.getUserQuizCount(userName);
                if (quizCount >= 25) {
                    awardAchievement(userName, 9);
                    newAchievements.add(getAchievement(9));
                }
            }

            // Check Quiz Master (took 50 quizzes)
            if (!hasAchievement(userName, 10)) {
                int quizCount = quizAttempts.getUserQuizCount(userName);
                if (quizCount >= 50) {
                    awardAchievement(userName, 10);
                    newAchievements.add(getAchievement(10));
                }
            }

            // Check Consistent Performer (scored 80%+ on 5 quizzes in a row)
            if (!hasAchievement(userName, 11)) {
                if (hasConsistentPerformance(userName)) {
                    awardAchievement(userName, 11);
                    newAchievements.add(getAchievement(11));
                }
            }

        } catch (Exception e) {
            System.err.println("Error checking achievements: " + e.getMessage());
        }

        return newAchievements;
    }

    // Helper method to count quizzes created by user
    private int getQuizCreatedCount(String userName) {
        String sql = "SELECT COUNT(*) FROM quizzes WHERE creator_name = ?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to count created quizzes for user: " + userName, e);
        }
        return 0;
    }

    // Helper method to check if user has highest score on any quiz
    private boolean hasHighestScore(String userName) {
        String sql = "SELECT COUNT(*) FROM quiz_attempts qa1 " +
                "WHERE qa1.user_name = ? AND qa1.is_practice_mode = FALSE " +
                "AND (qa1.score/qa1.total_questions) = (" +
                "  SELECT MAX(qa2.score/qa2.total_questions) " +
                "  FROM quiz_attempts qa2 " +
                "  WHERE qa2.quiz_id = qa1.quiz_id AND qa2.is_practice_mode = FALSE" +
                ")";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to check highest scores for user: " + userName, e);
        }
        return false;
    }

    private boolean hasPerfectScore(String userName) {
        String sql = "SELECT COUNT(*) FROM quiz_attempts WHERE user_name = ? AND score = total_questions AND is_practice_mode = FALSE";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to check perfect scores for user: " + userName, e);
        }
        return false;
    }

    private boolean hasSpeedRun(String userName) {
        // Note: Database shows 30 seconds, but your original code used 60
        // Using 30 seconds to match the database description
        String sql = "SELECT COUNT(*) FROM quiz_attempts WHERE user_name = ? AND time_taken <= 30 AND is_practice_mode = FALSE";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to check speed runs for user: " + userName, e);
        }
        return false;
    }

    private boolean hasPracticeMode(String userName) {
        String sql = "SELECT COUNT(*) FROM quiz_attempts WHERE user_name = ? AND is_practice_mode = TRUE";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to check practice mode for user: " + userName, e);
        }
        return false;
    }

    private boolean hasConsistentPerformance(String userName) {
        String sql = "SELECT (score/total_questions*100) as percentage FROM quiz_attempts " +
                "WHERE user_name = ? AND is_practice_mode = FALSE " +
                "ORDER BY attempt_date DESC LIMIT 5";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);

            try (ResultSet rs = ps.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    double percentage = rs.getDouble("percentage");
                    if (percentage >= 80.0) {
                        count++;
                    } else {
                        return false; // Not consecutive
                    }
                }
                return count >= 5; // Must have at least 5 consecutive 80%+ scores
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to check consistent performance for user: " + userName, e);
        }
    }

    private Achievement getAchievement(int achievementId) {
        String sql = "SELECT * FROM achievements WHERE achievement_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, achievementId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Achievement(
                            rs.getInt("achievement_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getString("icon_url"),
                            rs.getString("condition_type"),
                            rs.getInt("condition_value")
                    );
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get achievement: " + achievementId, e);
        }
        return null;
    }
}