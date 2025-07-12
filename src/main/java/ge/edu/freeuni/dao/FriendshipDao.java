package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.Friendship;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component
public class FriendshipDao {

    @Autowired
    private BasicDataSource db;

    public boolean insertFriendship(String user, String friend) {
        String sql = "INSERT INTO Friendships (user_name, friend_name) VALUES (?, ?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, friend);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert friendship.", e);
        }
    }

    public boolean deleteFriendship(String user, String friend) {
        String sql = "DELETE FROM Friendships WHERE user_name = ? AND friend_name = ?";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, friend);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete friendship.", e);
        }
    }

    public List<Friendship> findByUser(String user) {
        String sql = "SELECT user_name, friend_name, since FROM Friendships WHERE user_name = ?";
        List<Friendship> list = new ArrayList<>();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Friendship f = new Friendship();
                    f.setUserName(rs.getString("user_name"));
                    f.setFriendName(rs.getString("friend_name"));
                    f.setSince(rs.getTimestamp("since").toLocalDateTime());
                    list.add(f);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to fetch friendships.", e);
        }
        return list;
    }
}
