package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.PasswordHasher;
import ge.edu.freeuni.model.User;
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
@ContextConfiguration(locations = {"file:src/test/resources/test-context.xml"})
//@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/dispatcher-servlet.xml"})
public class UserDaoTest {

    @Autowired
    private UserDao users;

    @BeforeEach
    public void setUp() throws Exception {

        String createTableSQL = "CREATE TABLE IF NOT EXISTS users " +
                "(name VARCHAR(100) PRIMARY KEY, " +
                "hashedpassword VARCHAR(255) NOT NULL, " +
                "isadmin BOOLEAN NOT NULL)";

        try (Connection con = users.getBasicDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(createTableSQL)) {
            ps.execute();
        }

        User user = new User("Davit", "1234");
        User Admin = new User("Admin", "fm", true);

        List<User> users = new ArrayList<>();
        users.add(user);
        users.add(Admin);

        for (User us : users) {

            String sql = "INSERT INTO users (name, hashedpassword, isadmin) VALUES (?,?,?)";

            try (Connection con = this.users.getBasicDataSource().getConnection();
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
        try (Connection conn = users.getBasicDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM users")) {
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete all users", e);
        }
    }

    @Test
    public void exists() {
        assertTrue(users.exists("Davit"));
        assertFalse(users.exists("Giorgi"));
        assertTrue(users.exists("Admin"));
        assertFalse(users.exists("2025"));
        assertTrue(users.exists("Davit"));
        assertFalse(users.exists("Giorgi"));
        assertTrue(users.exists("Admin"));
        assertFalse(users.exists("2025"));
    }

    @Test
    public void add() {
        assertFalse(users.add("Davit", "56g8"));
        assertTrue(users.add("Giorgi", "56g8"));
        assertFalse(users.add("Giorgi", "56ee"));

        String sql = "SELECT * FROM users WHERE name = 'Giorgi'";

        try (Connection con = users.getBasicDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            try (ResultSet rs = ps.executeQuery()) {
                assertTrue(rs.next());
                assertEquals("Giorgi", rs.getString("name"));
                assertEquals(rs.getString("hashedpassword"), PasswordHasher.hashPassword("56g8"));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    public void correctPassword() {
        assertTrue(users.correctPassword("Davit", "1234"));
        assertTrue(users.correctPassword("Admin", "fm"));
        assertFalse(users.correctPassword("Davit", "1235"));
        assertFalse(users.correctPassword("Giorgi", "fm"));
    }

}