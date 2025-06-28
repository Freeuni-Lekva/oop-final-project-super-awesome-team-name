package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.AnnouncementDao;
import ge.edu.freeuni.dao.UserDao;
import ge.edu.freeuni.model.Announcement;
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
                                    @RequestParam String action,
                                    @RequestParam(required = false) String name,
                                    @RequestParam(required = false) String title,
                                    @RequestParam(required = false) String text) {
        ModelAndView mav = new ModelAndView("admin");

        switch (action) {
            case "announce": {
                try {
                    int key = announcements.add(title, (String) session.getAttribute("name"),
                            text, new Timestamp(System.currentTimeMillis()));
                    mav.addObject("announcement", announcements.get(key));
                } catch (RuntimeException e) {
                    mav.addObject("error", "Announcement failed.");
                }
            }
            break;

            case "remove": {
                if (users.removeUser(name)) {
                    mav.addObject("removed", name);
                } else {
                    mav.addObject("error", "User not found.");
                }
            }
            break;

            case "promote": {
                if (users.setAdmin(name)) {
                    mav.addObject("promoted", name);
                } else {
                    mav.addObject("error", "User not found.");
                }

            }
            break;

        }

        return mav;
    }
}
