package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.User;
import ge.edu.freeuni.model.PasswordHasher;
import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.PreparedStatement;
import java.sql.SQLException;

@Component()
public class UserDao {

    @Autowired
    private BasicDataSource db;

    public void create(String login, String password, String name, String surname) {
        PreparedStatement ps = null;
        try {
            ps = db.getConnection().prepareStatement("INSERT INTO users (login, hashedpassword, isadmin) VALUES (?,?, false)");
            ps.setString(1, login);
            ps.setString(2, PasswordHasher.hashPassword(password));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
