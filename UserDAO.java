package com.smartbuilding.dao;

import com.smartbuilding.model.User;
import com.smartbuilding.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // =========================================================
    // REGISTER USER
    // =========================================================
    public boolean register(User user) {
        String sql = "INSERT INTO users (name, email, password, phone, role) VALUES (?, ?, ?, ?, 'USER')";

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                return false;
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());

            int result = ps.executeUpdate();

            ps.close();
            con.close();

            return result > 0;
        } catch (Exception e) {
            System.out.println("REGISTRATION ERROR:");
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // USER LOGIN
    // =========================================================
    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                return null;
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email.trim());
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                rs.close();
                ps.close();
                con.close();

                return user;
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            System.out.println("LOGIN ERROR:");
            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // CHECK IF EMAIL EXISTS
    // =========================================================
    public boolean emailExists(String email) {
        String sql = "SELECT user_id FROM users WHERE email = ?";

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                return false;
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email.trim());

            ResultSet rs = ps.executeQuery();
            boolean exists = rs.next();

            rs.close();
            ps.close();
            con.close();

            return exists;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // GET ALL REGISTERED USERS
    // =========================================================
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                return list;
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(user);
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            System.out.println("GET ALL USERS ERROR:");
            e.printStackTrace();
        }

        return list;
    }

    // =========================================================
    // GET TOTAL REGISTERED USERS COUNT
    // =========================================================
    public int getTotalUsersCount() {
        String sql = "SELECT COUNT(*) FROM users";

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                return 0;
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }

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