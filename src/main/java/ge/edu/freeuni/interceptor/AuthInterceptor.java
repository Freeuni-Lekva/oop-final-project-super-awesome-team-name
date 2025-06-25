package ge.edu.freeuni.interceptor;

import ge.edu.freeuni.model.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession session = request.getSession();
        String name = (session != null) ? (String) session.getAttribute("name") : null;
        Boolean isAdmin = (session != null) ? (Boolean) session.getAttribute("isAdmin") : null;
        String uri = request.getRequestURI();

        if (uri.startsWith("/css") || uri.startsWith("/js") || uri.startsWith("/images")) {
            return true;
        }

        if (name == null && !uri.equals("/welcome")) {
            response.sendRedirect("/welcome");
            return false;
        }

        if (name != null && uri.equals("/welcome")) {
            response.sendRedirect("/"); // homepage
            return false;
        }

        if (!Boolean.TRUE.equals(isAdmin) && uri.startsWith("/admin")) {
            response.sendRedirect("/"); // homepage
            return false;
        }

        return true;

    }
}
