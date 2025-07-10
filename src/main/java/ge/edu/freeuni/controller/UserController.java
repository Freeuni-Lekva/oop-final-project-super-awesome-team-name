package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.UserDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserDao users;

    @GetMapping("/welcome")
    public String welcome() {
        return "welcome";
    }

    @PostMapping("/welcome")
    @ResponseBody
    public Map<String, String> welcome(HttpSession session,
                                       @RequestParam String name,
                                       @RequestParam String password,
                                       @RequestParam String mode) throws IOException {
        Map<String, String> result = new HashMap<String, String>();

        if ("login".equals(mode)) {
            if (!users.exists(name)) {
                result.put("status", "error");
                result.put("message", "User does not exist: " + name);
            } else if (!users.correctPassword(name, password)) {
                result.put("status", "error");
                result.put("message", "Incorrect password for user: " + name);
            } else {
                session.setAttribute("name", name);
                result.put("status", "success");
                result.put("redirectUrl", "/home"); //homepageURl
                if (users.isAdmin(name)) {
                    session.setAttribute("isAdmin", true);
                }
            }
        } else if ("signup".equals(mode)) {
            if (!users.add(name, password)) {
                result.put("status", "error");
                result.put("message", "User already exists: " + name);
            } else {
                session.setAttribute("name", name);
                result.put("status", "success");
                result.put("redirectUrl", "/home"); //homepageURl
            }
        }
        return result;
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "welcome";
    }

}