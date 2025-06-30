package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.AnnouncementDao;
import ge.edu.freeuni.dao.UserDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserDao users;

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

        switch (action) {
            case "announce": {
                try {
                    announcements.add(text, (String) session.getAttribute("name"),
                            bigText, Timestamp.from(Instant.now()));
                    result.put("status", "success");
                    result.put("message", "Announcement added: \"" + text.split(" ", 2)[0] + "...\"");
                } catch (RuntimeException e) {
                    result.put("status", "error");
                    result.put("message", "Announcement failed: \"" + text.split(" ", 2)[0] + "...\"");
                }
                break;
            }

            case "removeUser": {
                if (users.removeUser(text)) {
                    result.put("status", "success");
                    result.put("message", "User removed: " + text);
                } else {
                    result.put("status", "error");
                    result.put("message", "User does not exist: " + text);
                }
                break;
            }

            case "removeQuiz": {
                break;
            }

            case "clearHistory": {
                break;
            }

            case "promoteUser": {
                if (users.setAdmin(text)) {
                    result.put("status", "success");
                    result.put("message", "User promoted: " + text);
                } else {
                    result.put("status", "error");
                    result.put("message", "User not found.");
                }
                break;
            }

            case "seeStatistics": {
                result.put("status", "success");
                result.put("message", "Number of users: " + users.numberOfUsers());
                break;
            }

        }

        return result;
    }
}