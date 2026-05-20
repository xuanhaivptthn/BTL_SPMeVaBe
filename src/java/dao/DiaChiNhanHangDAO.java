package dao;

import model.DiaChiNhanHang;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiaChiNhanHangDAO {
    
    public List<DiaChiNhanHang> getByKhachHangId(int khachHangId) {
        List<DiaChiNhanHang> list = new ArrayList<>();
        String sql = "SELECT id, khachHangId, tenNguoiNhan, soDienThoai, diaChi, is_default, createdAt FROM DiaChiNhanHang WHERE khachHangId = ? ORDER BY is_default DESC, createdAt DESC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, khachHangId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DiaChiNhanHang dc = new DiaChiNhanHang();
                    dc.setId(rs.getInt("id"));
                    dc.setKhachHangId(rs.getInt("khachHangId"));
                    dc.setTenNguoiNhan(rs.getString("tenNguoiNhan"));
                    dc.setSoDienThoai(rs.getString("soDienThoai"));
                    dc.setDiaChi(rs.getString("diaChi"));
                    dc.setDefault(rs.getBoolean("is_default"));
                    dc.setCreatedAt(rs.getTimestamp("createdAt"));
                    list.add(dc);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }
    
    public DiaChiNhanHang getDefaultOrLatest(int khachHangId) {
        List<DiaChiNhanHang> list = getByKhachHangId(khachHangId);
        if (list != null && !list.isEmpty()) {
            return list.get(0);
        }
        return null;
    }

    public boolean insert(DiaChiNhanHang dc) {
        String sql = "INSERT INTO DiaChiNhanHang (khachHangId, tenNguoiNhan, soDienThoai, diaChi, is_default) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            if (dc.isDefault()) {
                clearDefault(conn, dc.getKhachHangId());
            }

            ps.setInt(1, dc.getKhachHangId());
            ps.setString(2, dc.getTenNguoiNhan());
            ps.setString(3, dc.getSoDienThoai());
            ps.setString(4, dc.getDiaChi());
            ps.setBoolean(5, dc.isDefault());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }
    
    private void clearDefault(Connection conn, int khachHangId) throws SQLException {
        String sql = "UPDATE DiaChiNhanHang SET is_default = 0 WHERE khachHangId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, khachHangId);
            ps.executeUpdate();
        }
    }
}
