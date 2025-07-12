package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.*;
import ge.edu.freeuni.model.*;
import ge.edu.freeuni.model.QuizEngine.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
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
            // Get announcements (latest 5)
            List<Announcement> recentAnnouncements = announcements.getReversedList();
            System.out.println("DEBUG: Found " + recentAnnouncements.size() + " announcements");
            if (recentAnnouncements.size() > 5) {
                recentAnnouncements = recentAnnouncements.subList(0, 5);
            }
            mav.addObject("announcements", recentAnnouncements);

            // Get popular quizzes (top 5 by number of attempts)
            List<Quiz> popularQuizzes = quizzes.getPopularQuizzes(5);
            mav.addObject("popularQuizzes", popularQuizzes);

            // Get recently created quizzes (latest 5)
            List<Quiz> allQuizzes = quizzes.getAllQuizzes();
            List<Quiz> recentQuizzes = allQuizzes.stream()
                    .sorted((q1, q2) -> q2.getQuizID() - q1.getQuizID()) // Sort by ID descending (assuming higher ID = more recent)
                    .limit(5)
                    .collect(Collectors.toList());
            mav.addObject("recentQuizzes", recentQuizzes);

        } catch (Exception e) {
            // Log error and provide empty lists as fallback
            System.err.println("Error loading homepage data: " + e.getMessage());
            e.printStackTrace();

            // Provide empty fallbacks (Java 8 compatible)
            mav.addObject("announcements", new ArrayList<>());
            mav.addObject("popularQuizzes", new ArrayList<>());
            mav.addObject("recentQuizzes", new ArrayList<>());
        }

        return mav;
    }
}