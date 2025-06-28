package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.PasswordHasher;
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

        String insertSQL = "INSERT INTO users (name, hashedpassword, isadmin) VALUES (?, ?, ?)";

        String passwordHash1 = PasswordHasher.hashPassword("1234");
        String passwordHash2 = PasswordHasher.hashPassword("fm");

        try (Connection con = users.getBasicDataSource().getConnection()) {

            try (PreparedStatement ps1 = con.prepareStatement(createTableSQL)) {
                ps1.execute();
            }

            try (PreparedStatement ps2 = con.prepareStatement(insertSQL)) {
                ps2.setString(1, "Davit");
                ps2.setString(2, passwordHash1);
                ps2.setBoolean(3, false);
                ps2.executeUpdate();

                ps2.setString(1, "Admin");
                ps2.setString(2, passwordHash2);
                ps2.setBoolean(3, true);
                ps2.executeUpdate();
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

    @Test
    public void isAdmin() {
        assertTrue(users.isAdmin("Admin"));
        assertFalse(users.isAdmin("Giorgi"));
        assertFalse(users.isAdmin("Davit"));
    }

    @Test
    public void removeUser() {
        assertTrue(users.removeUser("Davit"));
        assertFalse(users.removeUser("Giorgi"));
        assertFalse(users.removeUser("Davit"));
        users.add("Giorgi", "56g8");
        assertTrue(users.removeUser("Giorgi"));
        assertTrue(users.removeUser("Admin"));
    }

    @Test
    public void setAdmin() {
        assertTrue(users.setAdmin("Davit"));
        assertFalse(users.setAdmin("Giorgi"));
        assertTrue(users.setAdmin("Davit"));
        assertTrue(users.isAdmin("Admin"));
        assertTrue(users.isAdmin("Davit"));
    }

    @Test
    public void numberOfUsers() {
        assertTrue(users.numberOfUsers() == 2);
        users.add("Giorgi", "56g8");
        assertTrue(users.numberOfUsers() == 3);
        users.removeUser("Admin");
        assertTrue(users.numberOfUsers() == 2);
        users.add("Davit", "56g8");
        assertTrue(users.numberOfUsers() == 2);
    }

    //RuntimeException test

}