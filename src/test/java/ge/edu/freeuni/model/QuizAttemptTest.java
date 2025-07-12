package ge.edu.freeuni.model;

import org.junit.jupiter.api.Test;
import java.sql.Timestamp;

import static org.junit.jupiter.api.Assertions.*;

class QuizAttemptTest {

    @Test
    void testQuizAttemptGettersAndPercentage() {
        int attemptId = 1;
        String userName = "alice";
        int quizId = 101;
        int score = 8;
        int totalQuestions = 10;
        int timeTaken = 120;
        Timestamp attemptDate = Timestamp.valueOf("2025-07-10 14:00:00");
        String answers = "A,B,C,D";
        String correctAnswers = "A,B,C,D";
        boolean isPracticeMode = false;

        QuizAttempt attempt = new QuizAttempt(
                attemptId,
                userName,
                quizId,
                score,
                totalQuestions,
                timeTaken,
                attemptDate,
                answers,
                correctAnswers,
                isPracticeMode
        );

        assertEquals(attemptId, attempt.getAttemptId());
        assertEquals(userName, attempt.getUserName());
        assertEquals(quizId, attempt.getQuizId());
        assertEquals(score, attempt.getScore());
        assertEquals(totalQuestions, attempt.getTotalQuestions());
        assertEquals(timeTaken, attempt.getTimeTaken());
        assertEquals(attemptDate, attempt.getAttemptDate());
        assertEquals(answers, attempt.getAnswers());
        assertEquals(correctAnswers, attempt.getCorrectAnswers());
        assertEquals(isPracticeMode, attempt.isPracticeMode());
        assertEquals(80.0, attempt.getPercentage(), 0.001);
    }

    @Test
    void testGetPercentageWhenTotalQuestionsIsZero() {
        QuizAttempt attempt = new QuizAttempt(
                2,
                "bob",
                102,
                0,
                0,
                90,
                Timestamp.valueOf("2025-07-10 15:30:00"),
                "A,B,C",
                "A,B,C",
                true
        );

        assertEquals(0.0, attempt.getPercentage(), 0.001);
    }
}

