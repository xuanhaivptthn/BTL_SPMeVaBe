package Controller;

import Model.NguoiDung;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class NguoiDungDAO {

    public NguoiDung checkLogin(String tenDangNhap, String matKhau) {
        String sql = "SELECT id, hoTen, email, dienThoai, tenDangNhap, role, status FROM NguoiDung WHERE tenDangNhap = ? AND matKhau = ?";
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
}
