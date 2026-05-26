package dao;

import model.NguoiDung;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NguoiDungDAO {

    public NguoiDung checkLogin(String tenDangNhap, String matKhau) {
        String sql = "SELECT id, hoTen, email, dienThoai, tenDangNhap, role, status FROM NguoiDung WHERE tenDangNhap = ? AND matKhau = ? AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, tenDangNhap);
            ps.setString(2, matKhau);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    NguoiDung nd = new NguoiDung();
                    nd.setId(rs.getInt("id"));
                    nd.setHoTen(rs.getString("hoTen"));
                    nd.setEmail(rs.getString("email"));
                    nd.setDienThoai(rs.getString("dienThoai"));
                    nd.setTenDangNhap(rs.getString("tenDangNhap"));
                    nd.setRole(rs.getString("role"));
                    nd.setStatus(rs.getString("status"));
                    return nd;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public List<NguoiDung> getAll() {
        List<NguoiDung> list = new ArrayList<>();
        String sql = "SELECT id, hoTen, email, dienThoai, tenDangNhap, role, status FROM NguoiDung WHERE is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                NguoiDung nd = new NguoiDung();
                nd.setId(rs.getInt("id"));
                nd.setHoTen(rs.getString("hoTen"));
                nd.setEmail(rs.getString("email"));
                nd.setDienThoai(rs.getString("dienThoai"));
                nd.setTenDangNhap(rs.getString("tenDangNhap"));
                nd.setRole(rs.getString("role"));
                nd.setStatus(rs.getString("status"));
                list.add(nd);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public List<NguoiDung> getFilteredUsers(String keyword) {
        List<NguoiDung> list = new ArrayList<>();
        String sql = "SELECT id, hoTen, email, dienThoai, tenDangNhap, role, status FROM NguoiDung WHERE is_deleted = 0";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (id LIKE ? OR hoTen LIKE ? OR email LIKE ? OR dienThoai LIKE ?)";
        }
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                String likeKeyword = "%" + keyword.trim() + "%";
                ps.setString(1, likeKeyword);
                ps.setString(2, likeKeyword);
                ps.setString(3, likeKeyword);
                ps.setString(4, likeKeyword);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    NguoiDung nd = new NguoiDung();
                    nd.setId(rs.getInt("id"));
                    nd.setHoTen(rs.getString("hoTen"));
                    nd.setEmail(rs.getString("email"));
                    nd.setDienThoai(rs.getString("dienThoai"));
                    nd.setTenDangNhap(rs.getString("tenDangNhap"));
                    nd.setRole(rs.getString("role"));
                    nd.setStatus(rs.getString("status"));
                    list.add(nd);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public NguoiDung getById(int id) {
        String sql = "SELECT id, hoTen, email, dienThoai, tenDangNhap, role, status FROM NguoiDung WHERE id = ? AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    NguoiDung nd = new NguoiDung();
                    nd.setId(rs.getInt("id"));
                    nd.setHoTen(rs.getString("hoTen"));
                    nd.setEmail(rs.getString("email"));
                    nd.setDienThoai(rs.getString("dienThoai"));
                    nd.setTenDangNhap(rs.getString("tenDangNhap"));
                    nd.setRole(rs.getString("role"));
                    nd.setStatus(rs.getString("status"));
                    return nd;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public NguoiDung getByEmail(String email) {
        String sql = "SELECT id, hoTen, email, dienThoai, tenDangNhap, role, status FROM NguoiDung WHERE email = ? AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    NguoiDung nd = new NguoiDung();
                    nd.setId(rs.getInt("id"));
                    nd.setHoTen(rs.getString("hoTen"));
                    nd.setEmail(rs.getString("email"));
                    nd.setDienThoai(rs.getString("dienThoai"));
                    nd.setTenDangNhap(rs.getString("tenDangNhap"));
                    nd.setRole(rs.getString("role"));
                    nd.setStatus(rs.getString("status"));
                    return nd;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean insert(NguoiDung nd) {
        String sql = "INSERT INTO NguoiDung (hoTen, email, dienThoai, tenDangNhap, matKhau, role, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nd.getHoTen());
            ps.setString(2, nd.getEmail());
            ps.setString(3, nd.getDienThoai());
            ps.setString(4, nd.getTenDangNhap());
            ps.setString(5, nd.getMatKhau());
            ps.setString(6, nd.getRole() != null ? nd.getRole() : "CUSTOMER");
            ps.setString(7, nd.getStatus() != null ? nd.getStatus() : "ACTIVE");
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean update(NguoiDung nd) {
        // If password is provided, update it. Otherwise, keep old password.
        String sql;
        boolean updatePassword = nd.getMatKhau() != null && !nd.getMatKhau().trim().isEmpty();
        if (updatePassword) {
            sql = "UPDATE NguoiDung SET hoTen=?, email=?, dienThoai=?, role=?, status=?, matKhau=? WHERE id=?";
        } else {
            sql = "UPDATE NguoiDung SET hoTen=?, email=?, dienThoai=?, role=?, status=? WHERE id=?";
        }
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nd.getHoTen());
            ps.setString(2, nd.getEmail());
            ps.setString(3, nd.getDienThoai());
            ps.setString(4, nd.getRole());
            ps.setString(5, nd.getStatus());
            
            if (updatePassword) {
                ps.setString(6, nd.getMatKhau());
                ps.setInt(7, nd.getId());
            } else {
                ps.setInt(6, nd.getId());
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "UPDATE NguoiDung SET is_deleted = 1 WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean updateProfile(int id, String hoTen, String email, String dienThoai) {
        String sql = "UPDATE NguoiDung SET hoTen = ?, email = ?, dienThoai = ? WHERE id = ? AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hoTen);
            ps.setString(2, email);
            ps.setString(3, dienThoai);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean checkPassword(int id, String rawPassword) {
        String sql = "SELECT id FROM NguoiDung WHERE id = ? AND matKhau = ? AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setString(2, rawPassword);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int id, String newPassword) {
        String sql = "UPDATE NguoiDung SET matKhau = ? WHERE id = ? AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }
}
