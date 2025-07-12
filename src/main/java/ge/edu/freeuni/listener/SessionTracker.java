package ge.edu.freeuni.listener;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@WebListener
public class SessionTracker implements HttpSessionListener {

    private static final Map<String, HttpSession> sessions = new ConcurrentHashMap<>();

    @Override
    public void sessionCreated(HttpSessionEvent event) {
        sessions.put(event.getSession().getId(), event.getSession());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent event) {
        sessions.remove(event.getSession().getId());
    }

    public static void invalidateSession(String username) {
        for (HttpSession session : sessions.values()) {
            if (username.equals(session.getAttribute("name"))) {
                session.invalidate();
                break;
            }
        }
    }
}
