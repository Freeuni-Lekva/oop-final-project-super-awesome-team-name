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

@Component("users")
public class UserDao {

    @Autowired
    private BasicDataSource db;

    public BasicDataSource getBasicDataSource() {
        return db;
    }

    public User get(String name) {
        String sql = "SELECT name,hashedpassword,isadmin FROM users WHERE name = ?;";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(rs.getString("name"),
                                    rs.getString("hashedpassword"),
                                    rs.getBoolean("isadmin"));
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get user: " + name, e);
        }
    }

    public boolean contains(String name) {
        return get(name) != null;
    }

    public boolean add(String name, String password) {
        if (contains(name)) return false;

        String sql = "INSERT INTO users (name, hashedpassword, isadmin) VALUES (?,?, false)";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, PasswordHasher.hashPassword(password));

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new RuntimeException("Failed to create user: " + name, e);
        }
    }


    public boolean correctPassword(String name, String suggestedPassword) {
        if (!contains(name)) return false;

        String sql = "SELECT hashedpassword FROM users WHERE name = ?;";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return PasswordHasher.checkPassword(suggestedPassword, rs.getString("hashedpassword"));
                } else {
                    return false;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Password check failed for user: " + name, e);
        }
    }




}
