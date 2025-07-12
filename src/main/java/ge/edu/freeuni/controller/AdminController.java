package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.AnnouncementDao;
import ge.edu.freeuni.dao.QuizDAO;
import ge.edu.freeuni.dao.UserDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import ge.edu.freeuni.listener.SessionTracker;

import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final static int NUM_VISIBLE_SYMBOLS = 15;

    @Autowired
    private UserDao users;

    @Autowired
    private QuizDAO quizzes;

    @Autowired
    private AnnouncementDao announcements;

    @GetMapping
    public String adminPanel(HttpSession session) {
        return "admin";
    }

    @PostMapping
    @ResponseBody
    public Map<String, String> adminAction(HttpSession session,
                                           @RequestParam("adminFunc") String action,
                                           @RequestParam(value = "text", required = false) String text,
                                           @RequestParam(value = "bigText", required = false) String bigText) {
        Map<String, String> result = new HashMap<String, String>();

        String reducedText = text.length() > NUM_VISIBLE_SYMBOLS ? text.substring(0, NUM_VISIBLE_SYMBOLS) + "..." : text;

        switch (action) {
            case "announce": {
                try {
                    announcements.add(text, (String) session.getAttribute("name"),
                            bigText, Timestamp.from(Instant.now()));
                    result.put("status", "success");
                    result.put("message", "Announcement added: \"" + reducedText + "...\"");
                } catch (RuntimeException e) {
                    result.put("status", "error");
                    result.put("message", "Announcement failed: \"" + reducedText + "...\"");
                }
                break;
            }

            case "removeUser": {
                if (users.removeUser(text)) {
                    SessionTracker.invalidateSession(text);
                    result.put("status", "success");
                    result.put("message", "User removed: " + reducedText);
                } else {
                    result.put("status", "error");
                    result.put("message", "User does not exist: " + reducedText);
                }
                break;
            }

            case "removeQuiz": {
                if (quizzes.removeQuiz(Integer.parseInt(text))) {
                    result.put("status", "success");
                    result.put("message", "Quiz removed: #" + reducedText);
                } else {
                    result.put("status", "error");
                    result.put("message", "Quiz does not exist: #" + reducedText);
                }
                break;
            }

            case "clearHistory": {
                break;
            }

            case "promoteUser": {
                if (users.setAdmin(text)) {
                    result.put("status", "success");
                    result.put("message", "User promoted: " + reducedText);
                } else {
                    result.put("status", "error");
                    result.put("message", "User not found: " + reducedText);
                }
                break;
            }

            case "seeStatistics": {
                result.put("status", "success");
                result.put("message", "Number of users: " + users.numberOfUsers() +
                        "<br>"+"Number of quizzes: " + quizzes.numberOfQuizzes());
                break;
            }

        }
        return result;
    }

}
