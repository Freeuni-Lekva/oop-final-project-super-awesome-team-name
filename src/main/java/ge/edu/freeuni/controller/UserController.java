package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.UserDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.io.IOException;

@Controller
public class UserController {

    @Autowired
    private UserDao users;

    @GetMapping("/welcome")
    public String welcome() {
        return "welcome";
    }

    @PostMapping("/welcome")
    public ModelAndView welcome(HttpSession session,
                                @RequestParam String name,
                                @RequestParam String password,
                                @RequestParam String mode) throws IOException {
        ModelAndView mav = new ModelAndView("welcome");
        if ("login".equals(mode)) {
            mav.addObject("mode", "login");
            if (!users.exists(name)) {
                mav.addObject("error", "User does not exist: " + name);
            } else if (!users.correctPassword(name, password)) {
                mav.addObject("error", "Incorrect password for user: " + name);
            } else {
                session.setAttribute("name", name);
                if (users.isAdmin(name)) {
                    session.setAttribute("isAdmin", true);
                    mav = new ModelAndView("redirect:/"); //homepage
                }
            }
            return mav;
        } else if ("signup".equals(mode)) {
            mav.addObject("mode", "signup");
            if (!users.add(name, password)) {
                mav.addObject("error", "User already exists: "+name);
                return mav;
            }
            session.setAttribute("name", name);
            mav = new ModelAndView("redirect:/"); //homepage
        }
        return mav;
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "welcome";
    }


}