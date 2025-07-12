package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.FriendRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Component
public class FriendRequestDao {

    @Autowired
    private BasicDataSource db;

    public boolean insertRequest(String requester, String requestee) {
        String sql = "INSERT INTO FriendRequests (requester_name, requestee_name) VALUES (?, ?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, requester);
            ps.setString(2, requestee);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert friend request.", e);
        }
    }

    public boolean updateStatus(int requestId, String status) {
        String sql = "UPDATE FriendRequests SET status = ? WHERE id = ?";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, requestId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update friend request status.", e);
        }
    }

    public List<FriendRequest> findPendingFor(String requestee) {
        String sql = "SELECT id, requester_name, requestee_name, status, created_at, updated_at " +
                "FROM FriendRequests WHERE requestee_name = ? AND status = 'PENDING'";
        List<FriendRequest> list = new ArrayList<>();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, requestee);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FriendRequest fr = new FriendRequest();
                    fr.setId(rs.getInt("id"));
                    fr.setRequesterName(rs.getString("requester_name"));
                    fr.setRequesteeName(rs.getString("requestee_name"));
                    fr.setStatus(rs.getString("status"));
                    fr.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    fr.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    list.add(fr);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to fetch pending friend requests.", e);
        }
        return list;
    }

    public FriendRequest findById(int id) {
        String sql = "SELECT id, requester_name, requestee_name, status, created_at, updated_at "
                + "FROM FriendRequests WHERE id = ?";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                FriendRequest fr = new FriendRequest();
                fr.setId(rs.getInt("id"));
                fr.setRequesterName(rs.getString("requester_name"));
                fr.setRequesteeName(rs.getString("requestee_name"));
                fr.setStatus(rs.getString("status"));
                fr.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                fr.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                return fr;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to fetch FriendRequest with id=" + id, e);
        }
    }


    public List<FriendRequest> findSentBy(String requester) {
        String sql = "SELECT id, requester_name, requestee_name, status, created_at, updated_at " +
                "FROM FriendRequests WHERE requester_name = ? AND status = 'PENDING'";
        List<FriendRequest> list = new ArrayList<>();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, requester);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FriendRequest fr = new FriendRequest();
                    fr.setId(rs.getInt("id"));
                    fr.setRequesterName(rs.getString("requester_name"));
                    fr.setRequesteeName(rs.getString("requestee_name"));
                    fr.setStatus(rs.getString("status"));
                    fr.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    fr.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    list.add(fr);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to fetch sent friend requests.", e);
        }
        return list;
    }
}
