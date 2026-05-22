package dao;

import model.ChiTietDonHang;
import model.DonHang;
import model.SanPham;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonHangDAO {

    public boolean insert(DonHang dh, List<ChiTietDonHang> chiTietList) {
        String sqlDonHang = "INSERT INTO DonHang (khachHangId, tongTien, trangThai, tenNguoiNhan, sdtNhanHang, diaChiGiaoHang, ghiChu, maGiamGia, soTienGiam, phuongThucThanhToan) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
                psDH.setString(8, dh.getMaGiamGia());
                psDH.setDouble(9, dh.getSoTienGiam());
                psDH.setString(10, dh.getPhuongThucThanhToan());
                psDH.executeUpdate();
                
                try (ResultSet keys = psDH.getGeneratedKeys()) {
                    if (keys.next()) {
                        donHangId = keys.getInt(1);
                        dh.setId(donHangId);
                    }
                }
            }
            
            if (donHangId > 0 && chiTietList != null && !chiTietList.isEmpty()) {
                // First, verify and decrement stock for each product
                String sqlUpdateStock = "UPDATE SanPham SET SoLuong = SoLuong - ? WHERE MaSanPham = ? AND SoLuong >= ?";
                try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateStock)) {
                    for (ChiTietDonHang ct : chiTietList) {
                        psUpdate.setInt(1, ct.getSoLuong());
                        psUpdate.setInt(2, ct.getSanPhamId());
                        psUpdate.setInt(3, ct.getSoLuong());
                        int affectedStock = psUpdate.executeUpdate();
                        if (affectedStock == 0) {
                            // Not enough stock for this product
                            conn.rollback();
                            return false;
                        }
                    }
                }

                // Then insert order items
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

    public String getSQL_SELECT() {
        return "SELECT id, khachHangId, ngayDat, tongTien, trangThai, tenNguoiNhan, sdtNhanHang, diaChiGiaoHang, ghiChu, khachHangDaCapNhat, maGiamGia, soTienGiam, phuongThucThanhToan FROM DonHang";
    }

    private DonHang mapRow(ResultSet rs) throws SQLException {
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
        dh.setKhachHangDaCapNhat(rs.getBoolean("khachHangDaCapNhat"));
        dh.setMaGiamGia(rs.getString("maGiamGia"));
        dh.setSoTienGiam(rs.getDouble("soTienGiam"));
        dh.setPhuongThucThanhToan(rs.getString("phuongThucThanhToan"));
        return dh;
    }

    public DonHang getById(int id) {
        String sql = getSQL_SELECT() + " WHERE id = ? AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public List<ChiTietDonHang> getChiTietWithTenSP(int donHangId) {
        List<ChiTietDonHang> list = new ArrayList<>();
        String sql = "SELECT ct.id, ct.donHangId, ct.sanPhamId, ct.soLuong, ct.donGia, sp.TenSanPham "
                   + "FROM ChiTietDonHang ct "
                   + "JOIN SanPham sp ON ct.sanPhamId = sp.MaSanPham "
                   + "WHERE ct.donHangId = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, donHangId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChiTietDonHang ct = new ChiTietDonHang();
                    ct.setId(rs.getInt("id"));
                    ct.setDonHangId(rs.getInt("donHangId"));
                    ct.setSanPhamId(rs.getInt("sanPhamId"));
                    ct.setSoLuong(rs.getInt("soLuong"));
                    ct.setDonGia(rs.getDouble("donGia"));
                    ct.setTenSanPham(rs.getString("TenSanPham"));
                    list.add(ct);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public boolean updateContactInfo(int donHangId, String tenNguoiNhan, String sdtNhanHang, String diaChiGiaoHang) {
        String sql = "UPDATE DonHang SET tenNguoiNhan = ?, sdtNhanHang = ?, diaChiGiaoHang = ?, khachHangDaCapNhat = 1 WHERE id = ? AND trangThai IN ('PENDING','PROCESSING') AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tenNguoiNhan);
            ps.setString(2, sdtNhanHang);
            ps.setString(3, diaChiGiaoHang);
            ps.setInt(4, donHangId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean cancelOrder(int donHangId) {
        String sql = "UPDATE DonHang SET trangThai = 'CANCELLED' WHERE id = ? AND trangThai IN ('PENDING','PROCESSING') AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, donHangId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public List<DonHang> getAll() {
        List<DonHang> list = new ArrayList<>();
        String sql = getSQL_SELECT() + " WHERE is_deleted = 0 ORDER BY ngayDat DESC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }
    
    public List<DonHang> getFilteredOrders(String khachHangId, String donHangId) {
        return getFilteredOrders(khachHangId, donHangId, null);
    }
    
    public List<DonHang> getFilteredOrders(String khachHangId, String donHangId, String status) {
        List<DonHang> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(getSQL_SELECT() + " WHERE is_deleted = 0");
        List<Object> params = new ArrayList<>();
        
        if (khachHangId != null && !khachHangId.trim().isEmpty()) {
            sql.append(" AND khachHangId = ?");
            try {
                params.add(Integer.parseInt(khachHangId.trim()));
            } catch (Exception e) {
                params.add(-1);
            }
        }
        
        if (donHangId != null && !donHangId.trim().isEmpty()) {
            sql.append(" AND id = ?");
            try {
                params.add(Integer.parseInt(donHangId.trim()));
            } catch (Exception e) {
                params.add(-1);
            }
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND trangThai = ?");
            params.add(status.trim());
        }
        
        sql.append(" ORDER BY ngayDat DESC");
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
             
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
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
        String sql = getSQL_SELECT() + " WHERE khachHangId = ? AND is_deleted = 0 ORDER BY ngayDat DESC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, khachHangId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public int getNextOrderId() {
        String sql = "SELECT COALESCE(MAX(id), 0) + 1 AS next_id FROM DonHang";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("next_id");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 1;
    }

    public boolean deleteDraftOrder(int donHangId) {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);
            
            // Lấy danh sách chi tiết đơn hàng để hoàn lại kho
            List<ChiTietDonHang> list = getChiTietWithTenSP(donHangId);
            String sqlRestoreStock = "UPDATE SanPham SET SoLuong = SoLuong + ? WHERE MaSanPham = ?";
            try (PreparedStatement psRestore = conn.prepareStatement(sqlRestoreStock)) {
                for (ChiTietDonHang ct : list) {
                    psRestore.setInt(1, ct.getSoLuong());
                    psRestore.setInt(2, ct.getSanPhamId());
                    psRestore.executeUpdate();
                }
            }
            
            // Xóa chi tiết đơn hàng
            String sqlDeleteDetails = "DELETE FROM ChiTietDonHang WHERE donHangId = ?";
            try (PreparedStatement psDelDetails = conn.prepareStatement(sqlDeleteDetails)) {
                psDelDetails.setInt(1, donHangId);
                psDelDetails.executeUpdate();
            }
            
            // Xóa đơn hàng
            String sqlDeleteOrder = "DELETE FROM DonHang WHERE id = ? AND trangThai = 'UNPAID'";
            try (PreparedStatement psDelOrder = conn.prepareStatement(sqlDeleteOrder)) {
                psDelOrder.setInt(1, donHangId);
                int affected = psDelOrder.executeUpdate();
                if (affected == 0) {
                    // Trạng thái không phải UNPAID hoặc không tìm thấy, không xóa để tránh mất mát đơn hàng thật
                    conn.rollback();
                    return false;
                }
            }
            
            conn.commit();
            return true;
        } catch (SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException e) { e.printStackTrace(); }
            }
            ex.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public boolean updateDraftOrder(int id, double tongTien, String maGiamGia, double soTienGiam,
                                    String tenNguoiNhan, String sdtNhanHang, String diaChiGiaoHang,
                                    String ghiChu, String phuongThucThanhToan) {
        String sql = "UPDATE DonHang SET tongTien = ?, maGiamGia = ?, soTienGiam = ?, tenNguoiNhan = ?, sdtNhanHang = ?, diaChiGiaoHang = ?, ghiChu = ?, phuongThucThanhToan = ? WHERE id = ? AND trangThai = 'UNPAID'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, tongTien);
            ps.setString(2, maGiamGia);
            ps.setDouble(3, soTienGiam);
            ps.setString(4, tenNguoiNhan);
            ps.setString(5, sdtNhanHang);
            ps.setString(6, diaChiGiaoHang);
            ps.setString(7, ghiChu);
            ps.setString(8, phuongThucThanhToan);
            ps.setInt(9, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean finalizeDraftOrder(DonHang dh) {
        String sql = "UPDATE DonHang SET tenNguoiNhan = ?, sdtNhanHang = ?, diaChiGiaoHang = ?, ghiChu = ?, phuongThucThanhToan = ?, tongTien = ?, maGiamGia = ?, soTienGiam = ?, trangThai = 'PENDING' WHERE id = ? AND trangThai = 'UNPAID'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dh.getTenNguoiNhan());
            ps.setString(2, dh.getSdtNhanHang());
            ps.setString(3, dh.getDiaChiGiaoHang());
            ps.setString(4, dh.getGhiChu());
            ps.setString(5, dh.getPhuongThucThanhToan());
            ps.setDouble(6, dh.getTongTien());
            ps.setString(7, dh.getMaGiamGia());
            ps.setDouble(8, dh.getSoTienGiam());
            ps.setInt(9, dh.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }
}
