package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.UserDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

@Controller
public class UserController {

    @Autowired
    private UserDao users;

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @PostMapping("/login")
    public ModelAndView login(HttpSession session, @RequestParam String name, @RequestParam String password) {
        ModelAndView mav = new ModelAndView("login");
        if (!users.exists(name)) {
            mav.addObject("error", "User does not exist.");
        } else if (!users.correctPassword(name, password)) {
            mav.addObject("error", "Incorrect password.");
        } else {
            session.setAttribute("name", name);
        }
        return mav;
    }

    @GetMapping("/register")
    public String register() {
        return "register";
    }

    @PostMapping("/register")
    public ModelAndView register(@RequestParam String name, @RequestParam String password) {
        ModelAndView mav = new ModelAndView("register");
        if (!users.add(name, password)) {
            mav.addObject("error", "User already exists.");
            return mav;
        }
        return new ModelAndView("redirect:/login");
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "login";
    }


}
