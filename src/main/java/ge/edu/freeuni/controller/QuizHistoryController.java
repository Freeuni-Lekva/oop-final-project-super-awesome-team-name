package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.QuizAttemptDao;
import ge.edu.freeuni.dao.AchievementDao;
import ge.edu.freeuni.model.QuizAttempt;
import ge.edu.freeuni.model.Achievement;
import ge.edu.freeuni.model.UserAchievement;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/history")
public class QuizHistoryController {

    @Autowired
    private QuizAttemptDao quizAttempts;

    @Autowired
    private AchievementDao achievements;

    @GetMapping("/ping")
    @ResponseBody
    public String ping() {
        return "pong - Spring found your controller with achievements!";
    }

    @GetMapping
    public ModelAndView showHistory(HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            userName = "TestUser"; // Use test user since auth is disabled
        }

        ModelAndView mav = new ModelAndView("quiz-history");

        // Get user's quiz attempts
        List<QuizAttempt> attempts = quizAttempts.getAttemptsForUser(userName);
        mav.addObject("attempts", attempts);
        mav.addObject("userName", userName);

        // Get user's achievements
        List<UserAchievement> userAchievements = achievements.getUserAchievements(userName);
        mav.addObject("achievements", userAchievements);

        // Calculate some basic stats
        int totalAttempts = attempts.size();
        double averageScore = 0;
        if (!attempts.isEmpty()) {
            double totalScore = 0;
            for (QuizAttempt attempt : attempts) {
                totalScore += attempt.getPercentage();
            }
            averageScore = totalScore / totalAttempts;
        }

        mav.addObject("totalAttempts", totalAttempts);
        mav.addObject("averageScore", averageScore);

        return mav;
    }

    // Test method to add a sample quiz attempt AND check for new achievements
    @GetMapping("/test")
    public ModelAndView testAddAttempt(HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            userName = "TestUser"; // Use test user if not logged in
        }

        // Add a sample quiz attempt
        int attemptId = quizAttempts.add(userName, 1, 3, 4, 120,
                "[\"Paris\", \"South America\", \"Atlantic Ocean\", \"Nile\"]",
                "[\"Paris\", \"South America\", \"Pacific Ocean\", \"Nile\"]",
                false);

        // Check for new achievements after adding the attempt
        List<Achievement> newAchievements = achievements.checkAndAwardAchievements(userName);

        ModelAndView mav = new ModelAndView("quiz-history");

        String message = "Test quiz attempt added with ID: " + attemptId;
        if (!newAchievements.isEmpty()) {
            message += " | NEW ACHIEVEMENTS UNLOCKED: ";
            for (Achievement achievement : newAchievements) {
                message += achievement.getName() + " ";
            }
        }
        mav.addObject("message", message);

        // Get updated attempts
        List<QuizAttempt> attempts = quizAttempts.getAttemptsForUser(userName);
        mav.addObject("attempts", attempts);
        mav.addObject("userName", userName);

        // Get updated achievements
        List<UserAchievement> userAchievements = achievements.getUserAchievements(userName);
        mav.addObject("achievements", userAchievements);

        // Calculate stats
        int totalAttempts = attempts.size();
        double averageScore = 0;
        if (!attempts.isEmpty()) {
            double totalScore = 0;
            for (QuizAttempt attempt : attempts) {
                totalScore += attempt.getPercentage();
            }
            averageScore = totalScore / totalAttempts;
        }

        mav.addObject("totalAttempts", totalAttempts);
        mav.addObject("averageScore", averageScore);

        return mav;
    }
}