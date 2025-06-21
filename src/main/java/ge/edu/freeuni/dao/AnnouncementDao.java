package ge.edu.freeuni.dao;


import ge.edu.freeuni.model.Announcement;
import ge.edu.freeuni.model.PasswordHasher;
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

    public boolean add(String title, String author, String text, Timestamp date) {

        String sql = "INSERT INTO announcements (title,author,text,date) VALUES (?,?,?,?)";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, author);
            ps.setString(3, text);
            ps.setTimestamp(4, date);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new RuntimeException("Failed to add announcement: " + title, e);
        }
    }

    public List<Announcement> get() {
        List<Announcement> announcements = new ArrayList<>();
        String sql = "SELECT COUNT(*) FROM announcements;";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                announcements.add(new Announcement(rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("text"),
                        rs.getTimestamp("date")));
            }

            return announcements;

        } catch (SQLException e) {
            throw new RuntimeException("Failed to count users." + e);
        }
    }

}
