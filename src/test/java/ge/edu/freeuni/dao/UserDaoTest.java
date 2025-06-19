package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.PasswordHasher;
import ge.edu.freeuni.model.User;
import org.apache.commons.dbcp2.BasicDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringJUnitConfig
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/dispatcher-servlet.xml"})
public class UserDaoTest {

    @Autowired
    UserDao dao;

    @BeforeEach
    public void setUp() throws Exception {
        User user = new User("Davit", "1234");
        User Admin = new User("Admin", "fm", true);

        List<User> users = new ArrayList<>();
        users.add(user);
        users.add(Admin);

        for (User us : users) {

            String sql = "INSERT INTO users (login, hashedpassword, isadmin) VALUES (?,?,?)";

            try (Connection con = dao.getBasicDataSource().getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, us.getName());
                ps.setString(2, PasswordHasher.hashPassword(us.getHashedPassword()));
                ps.setBoolean(3, us.isAdmin());

                ps.executeUpdate();

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

        }
    }

    @AfterEach
    public void tearDown() throws Exception {
        try (Connection conn = dao.getBasicDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM users")) {
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete all users", e);
        }
    }

    @Test
    public void get() {
        assertTrue(dao.get("Admin").getName().equals("Admin"));
        assertTrue(dao.get("Davit").getName().equals("Davit"));
        assertFalse(dao.get("Davit").getName().equals("Admin"));
        assertTrue(dao.get("Giorgi") == null);
    }

    @Test
    public void contains() {
        assertTrue(dao.contains("Davit"));
        assertFalse(dao.contains("Giorgi"));
        assertTrue(dao.contains("Admin"));
        assertFalse(dao.contains("2025"));
    }

    @Test
    public void add() {
        assertFalse(dao.add("Davit", "56g8"));
        assertTrue(dao.add("Giorgi", "56g8"));
        assertFalse(dao.add("Giorgi", "56ee"));

        String sql = "SELECT * FROM users WHERE login = 'Giorgi'";

        try (Connection con = dao.getBasicDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            try (ResultSet rs = ps.executeQuery()) {
                assertTrue(rs.next());
                assertEquals("Giorgi", rs.getString("login"));
                assertEquals(rs.getString("hashedpassword"), PasswordHasher.hashPassword("56g8"));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    public void correctPassword() {
        assertTrue(dao.correctPassword("Davit", "1234"));
        assertTrue(dao.correctPassword("Admin", "fm"));
        assertFalse(dao.correctPassword("Davit", "1235"));
        assertFalse(dao.correctPassword("Giorgi", "fm"));
    }


}