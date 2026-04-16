package Controller;

import Model.KhachHang;
import java.sql.*;

public class KhachHangDAO {

    public boolean insert(KhachHang k) {
        String sql = "INSERT INTO KhachHang (HoTen, email, password, DienThoai, Status) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, k.getHoTen());
            ps.setString(2, k.getEmail());
            ps.setString(3, k.getPassword());
            ps.setString(4, k.getDienThoai());
            ps.setString(5, k.getStatus());
            int affected = ps.executeUpdate();
            if (affected == 0) return false;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) k.setId(keys.getInt(1));
            }
            return true;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public KhachHang findByEmail(String email) {
        String sql = "SELECT id, HoTen, email, password, DienThoai, createdAt, Status FROM KhachHang WHERE email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    KhachHang k = new KhachHang();
                    k.setId(rs.getInt("id"));
                    k.setHoTen(rs.getString("HoTen"));
                    k.setEmail(rs.getString("email"));
                    k.setPassword(rs.getString("password"));
                    k.setDienThoai(rs.getString("DienThoai"));
                    Timestamp t = rs.getTimestamp("createdAt");
                    if (t != null) k.setCreatedAt(t.toLocalDateTime());
                    k.setStatus(rs.getString("Status"));
                    return k;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public KhachHang findById(int id) {
        String sql = "SELECT id, HoTen, email, password, DienThoai, createdAt, Status FROM KhachHang WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    KhachHang k = new KhachHang();
                    k.setId(rs.getInt("id"));
                    k.setHoTen(rs.getString("HoTen"));
                    k.setEmail(rs.getString("email"));
                    k.setPassword(rs.getString("password"));
                    k.setDienThoai(rs.getString("DienThoai"));
                    Timestamp t = rs.getTimestamp("createdAt");
                    if (t != null) k.setCreatedAt(t.toLocalDateTime());
                    k.setStatus(rs.getString("Status"));
                    return k;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean update(KhachHang k) {
        String sql = "UPDATE KhachHang SET HoTen=?, email=?, password=?, DienThoai=?, Status=? WHERE id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, k.getHoTen());
            ps.setString(2, k.getEmail());
            ps.setString(3, k.getPassword());
            ps.setString(4, k.getDienThoai());
            ps.setString(5, k.getStatus());
            ps.setInt(6, k.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM KhachHang WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }
}
