package dao;

import model.MaGiamGia;
import java.sql.*;
import java.time.LocalDateTime;

public class MaGiamGiaDAO {
    public MaGiamGia getByCode(String code) {
        String sql = "SELECT id, ma, moTa, loaiGiamGia, giaTriGiam, giaTriDonHangToiThieu, giamToiDa, ngayHetHan, trangThai, is_deleted FROM MaGiamGia WHERE ma = ? AND is_deleted = 0 AND trangThai = 'ACTIVE'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MaGiamGia mgg = new MaGiamGia();
                    mgg.setId(rs.getInt("id"));
                    mgg.setMa(rs.getString("ma"));
                    mgg.setMoTa(rs.getString("moTa"));
                    mgg.setLoaiGiamGia(rs.getString("loaiGiamGia"));
                    mgg.setGiaTriGiam(rs.getDouble("giaTriGiam"));
                    mgg.setGiaTriDonHangToiThieu(rs.getDouble("giaTriDonHangToiThieu"));
                    mgg.setGiamToiDa(rs.getDouble("giamToiDa"));
                    Timestamp t = rs.getTimestamp("ngayHetHan");
                    if (t != null) {
                        mgg.setNgayHetHan(t.toLocalDateTime());
                    }
                    mgg.setTrangThai(rs.getString("trangThai"));
                    mgg.setDeleted(rs.getBoolean("is_deleted") || rs.getInt("is_deleted") == 1);
                    return mgg;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }
}
