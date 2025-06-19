package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.User;
import ge.edu.freeuni.model.PasswordHasher;
import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Component()
public class UserDao {

    @Autowired
    private BasicDataSource db;

    public BasicDataSource getBasicDataSource() {
        return db;
    }

    public User get(String login) {
        String sql = "SELECT login,hashedpassword,isadmin FROM users WHERE login = ?;";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, login);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(rs.getString("login"),
                                    rs.getString("hashedpassword"),
                                    rs.getBoolean("isadmin"));
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get user: " + login, e);
        }
    }

    public boolean contains(String login) {
        return get(login) != null;
    }

    public boolean add(String login, String password) {
        if (contains(login)) return false;

        String sql = "INSERT INTO users (login, hashedpassword, isadmin) VALUES (?,?, false)";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, login);
            ps.setString(2, PasswordHasher.hashPassword(password));

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new RuntimeException("Failed to create user: " + login, e);
        }
    }


    public boolean correctPassword(String login, String suggestedPassword) {
        if (!contains(login)) return false;

        String sql = "SELECT hashedpassword FROM users WHERE login = ?;";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, login);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return PasswordHasher.checkPassword(suggestedPassword, rs.getString("hashedpassword"));
                } else {
                    return false;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Password check failed for user: " + login, e);
        }
    }




}
