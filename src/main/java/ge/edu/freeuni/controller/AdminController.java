package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.AnnouncementDao;
import ge.edu.freeuni.dao.UserDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.sql.Timestamp;

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
    public ModelAndView adminAction(HttpSession session,
                                    @RequestParam("adminFunc") String action,
                                    @RequestParam(value = "text", required = false) String text,
                                    @RequestParam(value = "bigText", required = false) String bigText) {
        ModelAndView mav = new ModelAndView("admin");

        switch (action) {
            case "announce": {
                try {
                    announcements.add(text, (String) session.getAttribute("name"),
                            bigText, new Timestamp(System.currentTimeMillis()));
                    mav.addObject("result", "Announcement added");
                } catch (RuntimeException e) {
                    mav.addObject("error", "Announcement failed");
                }
                break;
            }

            case "removeUser": {
                if (users.removeUser(text)) {
                    mav.addObject("result", "User removed: " + text);
                } else {
                    mav.addObject("error", "User not found.");
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
                    mav.addObject("result", "User promoted: " + text);
                } else {
                    mav.addObject("error", "User not found.");
                }
                break;
            }

            case "seeStatistics": {
                mav.addObject("result", "Number of users: " + users.numberOfUsers());
                break;
            }

        }

        return mav;
    }
}
