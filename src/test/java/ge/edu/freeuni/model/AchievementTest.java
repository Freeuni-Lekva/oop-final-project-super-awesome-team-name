package ge.edu.freeuni.model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class AchievementTest {

    @Test
    void testAchievementGetters1() {
        int achievementId = 1;
        String name = "Quiz Master";
        String description = "Completed 100 quizzes";
        String iconUrl = "/images/quiz_master.png";
        String conditionType = "quizzesCompleted";
        int conditionValue = 100;

        Achievement achievement = new Achievement(
                achievementId,
                name,
                description,
                iconUrl,
                conditionType,
                conditionValue
        );

        assertEquals(achievementId, achievement.getAchievementId());
        assertEquals(name, achievement.getName());
        assertEquals(description, achievement.getDescription());
        assertEquals(iconUrl, achievement.getIconUrl());
        assertEquals(conditionType, achievement.getConditionType());
        assertEquals(conditionValue, achievement.getConditionValue());
    }


    @Test
    void testAchievementGetters2() {
        Achievement highScorer = new Achievement(
                2,
                "High Scorer",
                "Scored 90% or higher on 10 quizzes",
                "/images/achievements/high_scorer.png",
                "highScoresCount",
                10
        );

        assertEquals(2, highScorer.getAchievementId());
        assertEquals("High Scorer", highScorer.getName());
        assertEquals("Scored 90% or higher on 10 quizzes", highScorer.getDescription());
        assertEquals("/images/achievements/high_scorer.png", highScorer.getIconUrl());
        assertEquals("highScoresCount", highScorer.getConditionType());
        assertEquals(10, highScorer.getConditionValue());

    }
}
