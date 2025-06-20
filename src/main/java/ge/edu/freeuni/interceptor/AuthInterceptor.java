package ge.edu.freeuni.interceptor;

import ge.edu.freeuni.model.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        if (request.getSession().getAttribute("name") == null) {
            response.sendRedirect("/login");
            return false;
        }
        return true;
    }
}
