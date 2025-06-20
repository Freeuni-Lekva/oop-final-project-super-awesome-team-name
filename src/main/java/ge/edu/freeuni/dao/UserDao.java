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

    //Only for testing purposes
    public BasicDataSource getBasicDataSource() {
        return db;
    }

    private User get(String name) {
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

    public boolean exists(String name) {
        return get(name) != null;
    }

    public boolean add(String name, String password) {
        User user = get(name);
        if (user != null) return false;

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
        User user = get(name);
        if (user == null) return false;
        return user.checkHashedPassword(suggestedPassword);
    }

/*    public boolean isAdmin(String name) {
        User user = get(name);
        if (user == null) return false;
        return user.isAdmin();
    }*/

}
