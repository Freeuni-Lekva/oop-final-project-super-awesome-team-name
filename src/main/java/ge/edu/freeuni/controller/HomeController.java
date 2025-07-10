package ge.edu.freeuni.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import javax.servlet.http.HttpSession;

@Controller
public class HomeController {

    @GetMapping("/home")
    public String home() {
        return "home";        // home.jsp
    }

    @GetMapping("/home/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/welcome";
    }

    @GetMapping("/profile")
    public String profile() {
        return "profile";     // profile.jsp
    }
}
