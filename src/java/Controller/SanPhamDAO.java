package Controller;

import Model.SanPham;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SanPhamDAO {

    private List<String> loadImages(Connection conn, int maSanPham) {
        List<String> imgs = new ArrayList<>();
        String s = "SELECT url FROM AnhSanPham WHERE product_MaSanPham = ? ORDER BY sortOrder";
        try (PreparedStatement ps = conn.prepareStatement(s)) {
            ps.setInt(1, maSanPham);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) imgs.add(rs.getString("url"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return imgs;
    }

    private void insertImages(Connection conn, int maSanPham, List<String> images) throws SQLException {
        String s = "INSERT INTO AnhSanPham (product_MaSanPham, url, altText, sortOrder) VALUES (?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(s)) {
            int order = 0;
            for (String url : images) {
                ps.setInt(1, maSanPham);
                ps.setString(2, url);
                ps.setString(3, null);
                ps.setInt(4, order++);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private void deleteImages(Connection conn, int maSanPham) throws SQLException {
        String s = "DELETE FROM AnhSanPham WHERE product_MaSanPham = ?";
        try (PreparedStatement ps = conn.prepareStatement(s)) {
            ps.setInt(1, maSanPham);
            ps.executeUpdate();
        }
    }

    public List<SanPham> getAll() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT MaSanPham, TenSanPham, ThongTinSanPham, GiaTien, SoLuong FROM SanPham";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SanPham p = new SanPham();
                p.setMaSanPham(rs.getInt("MaSanPham"));
                p.setTenSanPham(rs.getString("TenSanPham"));
                p.setThongTinSanPham(rs.getString("ThongTinSanPham"));
                p.setGiaTien(rs.getDouble("GiaTien"));
                p.setSoLuong(rs.getInt("SoLuong"));
                // load images for this product
                p.setImages(loadImages(conn, p.getMaSanPham()));
                list.add(p);
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public SanPham getById(int id) {
        String sql = "SELECT MaSanPham, TenSanPham, ThongTinSanPham, GiaTien, SoLuong FROM SanPham WHERE MaSanPham = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SanPham p = new SanPham();
                    p.setMaSanPham(rs.getInt("MaSanPham"));
                    p.setTenSanPham(rs.getString("TenSanPham"));
                    p.setThongTinSanPham(rs.getString("ThongTinSanPham"));
                    p.setGiaTien(rs.getDouble("GiaTien"));
                    p.setSoLuong(rs.getInt("SoLuong"));
                    p.setImages(loadImages(conn, p.getMaSanPham()));
                    return p;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean insert(SanPham p) {
        String sql = "INSERT INTO SanPham (TenSanPham, ThongTinSanPham, GiaTien, SoLuong) VALUES (?,?,?,?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getTenSanPham());
            ps.setString(2, p.getThongTinSanPham());
            ps.setDouble(3, p.getGiaTien());
            ps.setInt(4, p.getSoLuong());
            int affected = ps.executeUpdate();
            if (affected == 0) return false;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) p.setMaSanPham(keys.getInt(1));
            }
            // insert images if any
            if (p.getImages() != null && !p.getImages().isEmpty()) {
                insertImages(conn, p.getMaSanPham(), p.getImages());
            }
            return true;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean update(SanPham p) {
        String sql = "UPDATE SanPham SET TenSanPham=?, ThongTinSanPham=?, GiaTien=?, SoLuong=?, updatedAt=NOW() WHERE MaSanPham=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getTenSanPham());
            ps.setString(2, p.getThongTinSanPham());
            ps.setDouble(3, p.getGiaTien());
            ps.setInt(4, p.getSoLuong());
            ps.setInt(5, p.getMaSanPham());
            int updated = ps.executeUpdate();
            if (updated > 0) {
                // refresh images: delete old and insert new
                deleteImages(conn, p.getMaSanPham());
                if (p.getImages() != null && !p.getImages().isEmpty()) {
                    insertImages(conn, p.getMaSanPham(), p.getImages());
                }
                return true;
            }
            return false;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM SanPham WHERE MaSanPham = ?";
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
