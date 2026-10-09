package com.smartbuilding.dao;

import com.smartbuilding.model.MaintenanceRequest;
import com.smartbuilding.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MaintenanceRequestDAO {

    // =========================================================
    // ADD NEW MAINTENANCE REQUEST
    // =========================================================
    public boolean addRequest(MaintenanceRequest request) {
        String sql = "INSERT INTO maintenance_requests "
                + "(user_id, title, description, category, status) "
                + "VALUES (?, ?, ?, ?, 'PENDING')";

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                return false;
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, request.getUserId());
            ps.setString(2, request.getTitle());
            ps.setString(3, request.getDescription());
            ps.setString(4, request.getCategory());

            int result = ps.executeUpdate();

            ps.close();
            con.close();

            return result > 0;
        } catch (Exception e) {
            System.out.println("MAINTENANCE REQUEST ERROR:");
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // GET ALL MAINTENANCE REQUESTS (WITH USER NAME & TIMESTAMP)
    // =========================================================
    public List<MaintenanceRequest> getAllRequests() {
        List<MaintenanceRequest> list = new ArrayList<>();
        String sql = "SELECT mr.request_id, mr.user_id, u.name AS user_name, "
                + "mr.title, mr.description, mr.category, mr.status, mr.created_at "
                + "FROM maintenance_requests mr "
                + "LEFT JOIN users u ON mr.user_id = u.user_id "
                + "ORDER BY mr.created_at DESC";

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                return list;
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MaintenanceRequest request = new MaintenanceRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setUserId(rs.getInt("user_id"));
                request.setUserName(rs.getString("user_name"));
                request.setTitle(rs.getString("title"));
                request.setDescription(rs.getString("description"));
                request.setCategory(rs.getString("category"));
                request.setStatus(rs.getString("status"));
                request.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(request);
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            System.out.println("GET ALL REQUESTS ERROR:");
            e.printStackTrace();
        }

        return list;
    }

    // =========================================================
    // UPDATE MAINTENANCE REQUEST STATUS
    // =========================================================
    public boolean updateStatus(int requestId, String status) {
        String sql = "UPDATE maintenance_requests "
                + "SET status = ? "
                + "WHERE request_id = ?";

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                return false;
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, requestId);

            int result = ps.executeUpdate();

            ps.close();
            con.close();

            return result > 0;
        } catch (Exception e) {
            System.out.println("UPDATE STATUS ERROR:");
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // GET MAINTENANCE REQUESTS FOR ONE USER
    // =========================================================
    public List<MaintenanceRequest> getRequestsByUser(int userId) {
        List<MaintenanceRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM maintenance_requests "
                + "WHERE user_id = ? "
                + "ORDER BY created_at DESC";

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                return list;
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MaintenanceRequest request = new MaintenanceRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setUserId(rs.getInt("user_id"));
                request.setTitle(rs.getString("title"));
                request.setDescription(rs.getString("description"));
                request.setCategory(rs.getString("category"));
                request.setStatus(rs.getString("status"));
                request.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(request);
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            System.out.println("GET USER REQUESTS ERROR:");
            e.printStackTrace();
        }

        return list;
    }

    // =========================================================
    // GET TOTAL REQUEST COUNT
    // =========================================================
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM maintenance_requests";
        return executeCountQuery(sql);
    }

    // =========================================================
    // GET COUNT BY STATUS (GLOBAL)
    // =========================================================
    public int getCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM maintenance_requests WHERE status = ?";
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return 0;

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            int count = 0;
            if (rs.next()) count = rs.getInt(1);

            rs.close();
            ps.close();
            con.close();
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // =========================================================
    // GET USER'S TOTAL REQUEST COUNT
    // =========================================================
    public int getUserRequestCount(int userId) {
        String sql = "SELECT COUNT(*) FROM maintenance_requests WHERE user_id = ?";
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return 0;

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            int count = 0;
            if (rs.next()) count = rs.getInt(1);

            rs.close();
            ps.close();
            con.close();
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // =========================================================
    // GET USER'S COUNT BY STATUS
    // =========================================================
    public int getUserCountByStatus(int userId, String status) {
        String sql = "SELECT COUNT(*) FROM maintenance_requests WHERE user_id = ? AND status = ?";
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return 0;

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            int count = 0;
            if (rs.next()) count = rs.getInt(1);

            rs.close();
            ps.close();
            con.close();
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // =========================================================
    // GET CATEGORY BREAKDOWN COUNTS
    // =========================================================
    public Map<String, Integer> getCategoryCounts() {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT category, COUNT(*) FROM maintenance_requests GROUP BY category";

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return map;

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                map.put(rs.getString(1), rs.getInt(2));
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }

    private int executeCountQuery(String sql) {
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return 0;

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            int count = 0;
            if (rs.next()) count = rs.getInt(1);

            rs.close();
            ps.close();
            con.close();
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}