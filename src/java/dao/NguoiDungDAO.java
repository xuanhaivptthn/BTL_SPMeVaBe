package dao;

import model.NguoiDung;
import utils.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NguoiDungDAO {

    public NguoiDung checkLogin(String tenDangNhap, String matKhau) {
        // Fetch the stored (hashed) password alongside user data
        String sql = "SELECT id, hoTen, email, dienThoai, tenDangNhap, matKhau, role, status FROM NguoiDung WHERE tenDangNhap = ? AND is_deleted = 0 AND status = 'ACTIVE'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, tenDangNhap);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("matKhau");
                    // BCrypt verify — works for both hashed and legacy plain-text
                    if (!PasswordUtil.verify(matKhau, storedPassword)) return null;

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
            // Hash password before storing — never persist plain text
            String rawPwd = nd.getMatKhau();
            ps.setString(5, PasswordUtil.isBcryptHash(rawPwd) ? rawPwd : PasswordUtil.hash(rawPwd));
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
        String sql = "SELECT matKhau FROM NguoiDung WHERE id = ? AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return PasswordUtil.verify(rawPassword, rs.getString("matKhau"));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(int id, String newPassword) {
        String sql = "UPDATE NguoiDung SET matKhau = ? WHERE id = ? AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hash(newPassword));
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    /**
     * One-time migration helper: finds all users whose stored password is NOT
     * already a BCrypt hash and re-hashes them.
     * Safe to call multiple times — already-hashed rows are skipped.
     *
     * @return number of passwords migrated
     */
    public int migratePasswordsToHash() {
        String selectSql = "SELECT id, matKhau FROM NguoiDung WHERE is_deleted = 0";
        String updateSql = "UPDATE NguoiDung SET matKhau = ? WHERE id = ?";
        int count = 0;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement sel = conn.prepareStatement(selectSql);
             ResultSet rs = sel.executeQuery()) {
            while (rs.next()) {
                String stored = rs.getString("matKhau");
                if (!PasswordUtil.isBcryptHash(stored)) {
                    try (PreparedStatement upd = conn.prepareStatement(updateSql)) {
                        upd.setString(1, PasswordUtil.hash(stored));
                        upd.setInt(2, rs.getInt("id"));
                        upd.executeUpdate();
                        count++;
                    }
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return count;
    }
}
