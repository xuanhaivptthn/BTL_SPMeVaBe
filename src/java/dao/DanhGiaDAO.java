package dao;

import model.DanhGia;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DanhGiaDAO {

    public List<DanhGia> getReviewsByProductId(int productId, Integer ratingFilter) {
        List<DanhGia> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM DanhGia WHERE sanPhamId = ?");
        if (ratingFilter != null && ratingFilter > 0) {
            sql.append(" AND diemDanhGia = ?");
        }
        sql.append(" ORDER BY createdAt DESC");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, productId);
            if (ratingFilter != null && ratingFilter > 0) {
                ps.setInt(2, ratingFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DanhGia dg = new DanhGia();
                    dg.setId(rs.getInt("id"));
                    dg.setSanPhamId(rs.getInt("sanPhamId"));
                    int khId = rs.getInt("khachHangId");
                    if (!rs.wasNull()) {
                        dg.setKhachHangId(khId);
                    }
                    dg.setHoTen(rs.getString("hoTen"));
                    dg.setDiemDanhGia(rs.getInt("diemDanhGia"));
                    dg.setBinhLuan(rs.getString("binhLuan"));
                    dg.setAnhDanhGia(rs.getString("anhDanhGia"));
                    dg.setAnDanh(rs.getBoolean("anDanh"));
                    dg.setCreatedAt(rs.getTimestamp("createdAt"));
                    list.add(dg);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public boolean addReview(DanhGia dg) {
        String sql = "INSERT INTO DanhGia (sanPhamId, khachHangId, hoTen, diemDanhGia, binhLuan, anhDanhGia, anDanh) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dg.getSanPhamId());
            if (dg.getKhachHangId() != null) {
                ps.setInt(2, dg.getKhachHangId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, dg.getHoTen());
            ps.setInt(4, dg.getDiemDanhGia());
            ps.setString(5, dg.getBinhLuan());
            ps.setString(6, dg.getAnhDanhGia());
            ps.setBoolean(7, dg.isAnDanh());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public int[] getReviewStats(int productId) {
        // Returns an array: [total_reviews, count_5, count_4, count_3, count_2, count_1]
        int[] stats = new int[6];
        String sql = "SELECT diemDanhGia, COUNT(*) as count FROM DanhGia WHERE sanPhamId = ? GROUP BY diemDanhGia";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int rating = rs.getInt("diemDanhGia");
                    int count = rs.getInt("count");
                    if (rating >= 1 && rating <= 5) {
                        stats[6 - rating] = count; // 5 -> index 1, 4 -> index 2...
                        stats[0] += count; // total
                    }
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return stats;
    }
}
