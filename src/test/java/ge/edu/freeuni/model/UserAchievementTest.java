package ge.edu.freeuni.model;

import org.junit.jupiter.api.Test;
import java.sql.Timestamp;

import static org.junit.jupiter.api.Assertions.*;

class UserAchievementTest {

    @Test
    void testUserAchievementWithRealAchievement() {
        Achievement achievement = new Achievement(
                1,
                "Quiz Master",
                "Completed 100 quizzes",
                "/images/quiz_master.png",
                "quizzesCompleted",
                100
        );

        Timestamp earnedDate = Timestamp.valueOf("2025-07-11 14:30:00");
        UserAchievement userAchievement = new UserAchievement(
                10,
                "alice",
                1,
                earnedDate,
                achievement
        );

        assertEquals(10, userAchievement.getUserAchievementId());
        assertEquals("alice", userAchievement.getUserName());
        assertEquals(1, userAchievement.getAchievementId());
        assertEquals(earnedDate, userAchievement.getEarnedDate());
        assertEquals(achievement, userAchievement.getAchievement());
        assertEquals("Quiz Master", userAchievement.getAchievement().getName());
    }

    @Test
    void testUserAchievementWithDifferentData() {
        Achievement achievement = new Achievement(
                2,
                "Fast Finisher",
                "Completed a quiz in under 1 minute",
                "/images/fast_finisher.png",
                "timeUnder",
                60
        );

        Timestamp earnedDate = Timestamp.valueOf("2025-07-12 09:00:00");
        UserAchievement userAchievement = new UserAchievement(
                20,
                "bob",
                2,
                earnedDate,
                achievement
        );

        assertEquals(20, userAchievement.getUserAchievementId());
        assertEquals("bob", userAchievement.getUserName());
        assertEquals(2, userAchievement.getAchievementId());
        assertEquals(earnedDate, userAchievement.getEarnedDate());
        assertEquals(achievement, userAchievement.getAchievement());
        assertEquals("Fast Finisher", userAchievement.getAchievement().getName());
    }
}
