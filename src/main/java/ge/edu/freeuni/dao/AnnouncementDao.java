package ge.edu.freeuni.dao;


import ge.edu.freeuni.model.Announcement;
import ge.edu.freeuni.model.PasswordHasher;
import ge.edu.freeuni.model.User;
import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component("announcements")
public class AnnouncementDao {

    @Autowired
    private BasicDataSource db;

    //Only for testing purposes
    public BasicDataSource getDataSource() {
        return db;
    }

    public Announcement get(int id) {
        String sql = "SELECT * FROM announcements WHERE id = ?";
        Announcement announcement = null;

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, Integer.toString(id));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Announcement(id, rs.getString("title"),
                            rs.getString("name"),
                            rs.getString("text"),
                            rs.getTimestamp("date"));
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get the announcement N" + id, e);
        }
    }

    public int add(String title, String name, String text, Timestamp date) {

        String sql = "INSERT INTO announcements (title,name,text,date) VALUES (?,?,?,?)";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, title);
            ps.setString(2, name);
            ps.setString(3, text);
            ps.setTimestamp(4, date);

            if (ps.executeUpdate() == 0) {
                throw new RuntimeException("Failed to add the announcement");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new RuntimeException("Failed to retrieve id.");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to add announcement: " + title, e);
        }
    }

    public List<Announcement> get() {
        List<Announcement> announcements = new ArrayList<>();
        String sql = "SELECT * FROM announcements;";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                announcements.add(new Announcement(rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("name"),
                        rs.getString("text"),
                        rs.getTimestamp("date")));
            }

            return announcements;

        } catch (SQLException e) {
            throw new RuntimeException("Failed to count users." + e);
        }
    }

}
