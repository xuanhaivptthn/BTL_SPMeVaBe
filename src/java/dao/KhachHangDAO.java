package dao;

import model.KhachHang;
import utils.PasswordUtil;
import java.sql.*;

public class KhachHangDAO {

    public boolean insert(KhachHang k) {
        String sqlNguoiDung = "INSERT INTO NguoiDung (hoTen, email, dienThoai, tenDangNhap, matKhau, role, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlKhachHang = "INSERT INTO KhachHang (id, diemTichLuy) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            int generatedId = 0;
            try (PreparedStatement ps1 = conn.prepareStatement(sqlNguoiDung, Statement.RETURN_GENERATED_KEYS)) {
                ps1.setString(1, k.getHoTen());
                ps1.setString(2, k.getEmail());
                ps1.setString(3, k.getDienThoai());
                ps1.setString(4, k.getTenDangNhap());
                ps1.setString(5, PasswordUtil.hash(k.getMatKhau()));
                ps1.setString(6, "CUSTOMER");
                ps1.setString(7, "ACTIVE");
                ps1.executeUpdate();

                try (ResultSet keys = ps1.getGeneratedKeys()) {
                    if (keys.next()) {
                        generatedId = keys.getInt(1);
                        k.setId(generatedId);
                    }
                }
            }

            if (generatedId > 0) {
                try (PreparedStatement ps2 = conn.prepareStatement(sqlKhachHang)) {
                    ps2.setInt(1, generatedId);
                    ps2.setInt(2, k.getDiemTichLuy());
                    ps2.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException ex) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            ex.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public int getDiemTichLuy(int khachHangId) {
        String sql = "SELECT diemTichLuy FROM KhachHang WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, khachHangId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("diemTichLuy");
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public boolean addDiemTichLuy(int khachHangId, int diem) {
        String sql = "UPDATE KhachHang SET diemTichLuy = diemTichLuy + ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, diem);
            ps.setInt(2, khachHangId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean recalculateAllPoints() {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);
            
            // Set all points to 0
            String sqlReset = "UPDATE KhachHang SET diemTichLuy = 0";
            try (PreparedStatement ps = conn.prepareStatement(sqlReset)) {
                ps.executeUpdate();
            }
            
            // Calculate and update based on completed orders
            String sqlUpdate = "UPDATE KhachHang k " +
                               "JOIN (SELECT khachHangId, SUM(tongTien) as total FROM DonHang WHERE trangThai = 'DELIVERED' AND is_deleted = 0 GROUP BY khachHangId) d " +
                               "ON k.id = d.khachHangId " +
                               "SET k.diemTichLuy = FLOOR(d.total / 1000)";
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.executeUpdate();
            }
            
            conn.commit();
            return true;
        } catch (SQLException ex) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            ex.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
