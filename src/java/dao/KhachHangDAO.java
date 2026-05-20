package dao;

import model.KhachHang;
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
                ps1.setString(5, k.getMatKhau());
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
}
