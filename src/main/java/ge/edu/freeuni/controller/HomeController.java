package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.*;
import ge.edu.freeuni.model.*;
import ge.edu.freeuni.model.QuizEngine.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class HomeController {

    @Autowired
    private QuizDAO quizzes;

    @Autowired
    private QuizAttemptDao quizAttempts;

    @Autowired
    private AchievementDao achievements;

    @Autowired
    private AnnouncementDao announcements;

    @GetMapping({"/", "/home"})
    public ModelAndView home(HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            return new ModelAndView("redirect:/welcome");
        }

        ModelAndView mav = new ModelAndView("home");

        try {
            // Get announcements
            List<Announcement> recentAnnouncements = announcements.getReversedList();
            if (recentAnnouncements.size() > 5) {
                recentAnnouncements = recentAnnouncements.subList(0, 5);
            }
            mav.addObject("announcements", recentAnnouncements);

            // Get popular quizzes
            List<Quiz> popularQuizzes = quizzes.getPopularQuizzes(5);
            mav.addObject("popularQuizzes", popularQuizzes);

            // Get recently created quizzes
            List<Quiz> allQuizzes = quizzes.getAllQuizzes();
            List<Quiz> recentQuizzes = allQuizzes.stream()
                    .limit(5)
                    .collect(Collectors.toList());
            mav.addObject("recentQuizzes", recentQuizzes);

            // Get user's recent quiz attempts
            List<QuizAttempt> userAttempts = quizAttempts.getAttemptsForUser(userName);
            List<QuizAttempt> recentAttempts = userAttempts.stream()
                    .limit(5)
                    .collect(Collectors.toList());
            mav.addObject("recentAttempts", recentAttempts);

            // Get user's created quizzes
            List<Quiz> userCreatedQuizzes = allQuizzes.stream()
                    .filter(quiz -> userName.equals(quiz.getCreatorUsername()))
                    .limit(5)
                    .collect(Collectors.toList());
            mav.addObject("userCreatedQuizzes", userCreatedQuizzes);

            // Get user's achievements
            List<UserAchievement> userAchievements = achievements.getUserAchievements(userName);
            mav.addObject("userAchievements", userAchievements);

            // Calculate some basic stats for the user
            int totalAttempts = userAttempts.size();
            double averageScore = 0;
            if (!userAttempts.isEmpty()) {
                double totalScore = userAttempts.stream()
                        .mapToDouble(QuizAttempt::getPercentage)
                        .sum();
                averageScore = totalScore / totalAttempts;
            }

            mav.addObject("userName", userName);
            mav.addObject("totalAttempts", totalAttempts);
            mav.addObject("averageScore", averageScore);
            mav.addObject("totalAchievements", userAchievements.size());

            return mav;

        } catch (Exception e) {
            e.printStackTrace();
            mav.addObject("error", "Failed to load homepage data: " + e.getMessage());
            return mav;
        }
    }

    @GetMapping("/profile")
    public ModelAndView profile(HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            return new ModelAndView("redirect:/welcome");
        }

        ModelAndView mav = new ModelAndView("profile");

        try {
            // Get user's quiz attempts
            List<QuizAttempt> userAttempts = quizAttempts.getAttemptsForUser(userName);
            mav.addObject("userAttempts", userAttempts);

            // Get user's achievements
            List<UserAchievement> userAchievements = achievements.getUserAchievements(userName);
            mav.addObject("userAchievements", userAchievements);

            // Get user's created quizzes
            List<Quiz> allQuizzes = quizzes.getAllQuizzes();
            List<Quiz> userCreatedQuizzes = allQuizzes.stream()
                    .filter(quiz -> userName.equals(quiz.getCreatorUsername()))
                    .collect(Collectors.toList());
            mav.addObject("userCreatedQuizzes", userCreatedQuizzes);

            // Calculate detailed statistics
            int totalAttempts = userAttempts.size();
            int totalQuizzesCreated = userCreatedQuizzes.size();

            double averageScore = 0;
            double bestScore = 0;
            int totalTimeTaken = 0;

            if (!userAttempts.isEmpty()) {
                averageScore = userAttempts.stream()
                        .mapToDouble(QuizAttempt::getPercentage)
                        .average()
                        .orElse(0);

                bestScore = userAttempts.stream()
                        .mapToDouble(QuizAttempt::getPercentage)
                        .max()
                        .orElse(0);

                totalTimeTaken = userAttempts.stream()
                        .mapToInt(QuizAttempt::getTimeTaken)
                        .sum();
            }

            mav.addObject("userName", userName);
            mav.addObject("totalAttempts", totalAttempts);
            mav.addObject("totalQuizzesCreated", totalQuizzesCreated);
            mav.addObject("averageScore", averageScore);
            mav.addObject("bestScore", bestScore);
            mav.addObject("totalTimeTaken", totalTimeTaken);
            mav.addObject("totalAchievements", userAchievements.size());

            return mav;

        } catch (Exception e) {
            e.printStackTrace();
            mav.addObject("error", "Failed to load profile data: " + e.getMessage());
            return mav;
        }
    }
}