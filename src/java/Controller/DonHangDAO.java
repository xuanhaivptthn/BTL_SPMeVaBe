package Controller;

import Model.ChiTietDonHang;
import Model.DonHang;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonHangDAO {

    public boolean insert(DonHang dh, List<ChiTietDonHang> chiTietList) {
        String sqlDonHang = "INSERT INTO DonHang (khachHangId, tongTien, trangThai, tenNguoiNhan, sdtNhanHang, diaChiGiaoHang, ghiChu) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlChiTiet = "INSERT INTO ChiTietDonHang (donHangId, sanPhamId, soLuong, donGia) VALUES (?, ?, ?, ?)";
        
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            int donHangId = 0;
            try (PreparedStatement psDH = conn.prepareStatement(sqlDonHang, Statement.RETURN_GENERATED_KEYS)) {
                psDH.setInt(1, dh.getKhachHangId());
                psDH.setDouble(2, dh.getTongTien());
                psDH.setString(3, dh.getTrangThai());
                psDH.setString(4, dh.getTenNguoiNhan());
                psDH.setString(5, dh.getSdtNhanHang());
                psDH.setString(6, dh.getDiaChiGiaoHang());
                psDH.setString(7, dh.getGhiChu());
                psDH.executeUpdate();
                
                try (ResultSet keys = psDH.getGeneratedKeys()) {
                    if (keys.next()) {
                        donHangId = keys.getInt(1);
                        dh.setId(donHangId);
                    }
                }
            }
            
            if (donHangId > 0 && chiTietList != null && !chiTietList.isEmpty()) {
                try (PreparedStatement psCT = conn.prepareStatement(sqlChiTiet)) {
                    for (ChiTietDonHang ct : chiTietList) {
                        psCT.setInt(1, donHangId);
                        psCT.setInt(2, ct.getSanPhamId());
                        psCT.setInt(3, ct.getSoLuong());
                        psCT.setDouble(4, ct.getDonGia());
                        psCT.addBatch();
                    }
                    psCT.executeBatch();
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

    public boolean delete(int id) {
        String sql = "UPDATE DonHang SET is_deleted = 1 WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public List<DonHang> getAll() {
        List<DonHang> list = new ArrayList<>();
        String sql = "SELECT id, khachHangId, ngayDat, tongTien, trangThai, tenNguoiNhan, sdtNhanHang, diaChiGiaoHang, ghiChu FROM DonHang WHERE is_deleted = 0 ORDER BY ngayDat DESC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                DonHang dh = new DonHang();
                dh.setId(rs.getInt("id"));
                dh.setKhachHangId(rs.getInt("khachHangId"));
                Timestamp t = rs.getTimestamp("ngayDat");
                if (t != null) dh.setNgayDat(t.toLocalDateTime());
                dh.setTongTien(rs.getDouble("tongTien"));
                dh.setTrangThai(rs.getString("trangThai"));
                dh.setTenNguoiNhan(rs.getString("tenNguoiNhan"));
                dh.setSdtNhanHang(rs.getString("sdtNhanHang"));
                dh.setDiaChiGiaoHang(rs.getString("diaChiGiaoHang"));
                dh.setGhiChu(rs.getString("ghiChu"));
                list.add(dh);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }
    
    public boolean updateStatus(int donHangId, String status) {
        String sql = "UPDATE DonHang SET trangThai = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, donHangId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public List<DonHang> getByKhachHangId(int khachHangId) {
        List<DonHang> list = new ArrayList<>();
        String sql = "SELECT id, khachHangId, ngayDat, tongTien, trangThai, tenNguoiNhan, sdtNhanHang, diaChiGiaoHang, ghiChu FROM DonHang WHERE khachHangId = ? AND is_deleted = 0 ORDER BY ngayDat DESC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, khachHangId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonHang dh = new DonHang();
                    dh.setId(rs.getInt("id"));
                    dh.setKhachHangId(rs.getInt("khachHangId"));
                    Timestamp t = rs.getTimestamp("ngayDat");
                    if (t != null) dh.setNgayDat(t.toLocalDateTime());
                    dh.setTongTien(rs.getDouble("tongTien"));
                    dh.setTrangThai(rs.getString("trangThai"));
                    dh.setTenNguoiNhan(rs.getString("tenNguoiNhan"));
                    dh.setSdtNhanHang(rs.getString("sdtNhanHang"));
                    dh.setDiaChiGiaoHang(rs.getString("diaChiGiaoHang"));
                    dh.setGhiChu(rs.getString("ghiChu"));
                    list.add(dh);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }
}
