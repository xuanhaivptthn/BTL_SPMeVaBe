package Controller;

import Model.SanPham;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SanPhamDAO {

    public List<SanPham> getAll() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT MaSanPham, TenSanPham, ThongTinSanPham, hinhAnh, thanhPhan, xuatXu, khoiLuong, GiaTien, SoLuong, danhMucId FROM SanPham WHERE is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SanPham p = new SanPham();
                p.setMaSanPham(rs.getInt("MaSanPham"));
                p.setTenSanPham(rs.getString("TenSanPham"));
                p.setThongTinSanPham(rs.getString("ThongTinSanPham"));
                p.setHinhAnh(rs.getString("hinhAnh"));
                p.setThanhPhan(rs.getString("thanhPhan"));
                p.setXuatXu(rs.getString("xuatXu"));
                p.setKhoiLuong(rs.getString("khoiLuong"));
                p.setGiaTien(rs.getDouble("GiaTien"));
                p.setSoLuong(rs.getInt("SoLuong"));
                p.setDanhMucId(rs.getInt("danhMucId"));
                list.add(p);
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public SanPham getById(int id) {
        String sql = "SELECT MaSanPham, TenSanPham, ThongTinSanPham, hinhAnh, thanhPhan, xuatXu, khoiLuong, GiaTien, SoLuong, danhMucId FROM SanPham WHERE MaSanPham = ? AND is_deleted = 0";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SanPham p = new SanPham();
                    p.setMaSanPham(rs.getInt("MaSanPham"));
                    p.setTenSanPham(rs.getString("TenSanPham"));
                    p.setThongTinSanPham(rs.getString("ThongTinSanPham"));
                    p.setHinhAnh(rs.getString("hinhAnh"));
                    p.setThanhPhan(rs.getString("thanhPhan"));
                    p.setXuatXu(rs.getString("xuatXu"));
                    p.setKhoiLuong(rs.getString("khoiLuong"));
                    p.setGiaTien(rs.getDouble("GiaTien"));
                    p.setSoLuong(rs.getInt("SoLuong"));
                    p.setDanhMucId(rs.getInt("danhMucId"));
                    return p;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean insert(SanPham p) {
        String sql = "INSERT INTO SanPham (TenSanPham, ThongTinSanPham, hinhAnh, thanhPhan, xuatXu, khoiLuong, GiaTien, SoLuong, danhMucId) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getTenSanPham());
            ps.setString(2, p.getThongTinSanPham());
            ps.setString(3, p.getHinhAnh());
            ps.setString(4, p.getThanhPhan());
            ps.setString(5, p.getXuatXu());
            ps.setString(6, p.getKhoiLuong());
            ps.setDouble(7, p.getGiaTien());
            ps.setInt(8, p.getSoLuong());
            ps.setInt(9, p.getDanhMucId());
            int affected = ps.executeUpdate();
            if (affected == 0) return false;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) p.setMaSanPham(keys.getInt(1));
            }
            return true;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean update(SanPham p) {
        String sql = "UPDATE SanPham SET TenSanPham=?, ThongTinSanPham=?, hinhAnh=?, thanhPhan=?, xuatXu=?, khoiLuong=?, GiaTien=?, SoLuong=?, danhMucId=?, updatedAt=NOW() WHERE MaSanPham=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getTenSanPham());
            ps.setString(2, p.getThongTinSanPham());
            ps.setString(3, p.getHinhAnh());
            ps.setString(4, p.getThanhPhan());
            ps.setString(5, p.getXuatXu());
            ps.setString(6, p.getKhoiLuong());
            ps.setDouble(7, p.getGiaTien());
            ps.setInt(8, p.getSoLuong());
            ps.setInt(9, p.getDanhMucId());
            ps.setInt(10, p.getMaSanPham());
            int updated = ps.executeUpdate();
            if (updated > 0) {
                return true;
            }
            return false;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "UPDATE SanPham SET is_deleted = 1 WHERE MaSanPham = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public List<SanPham> getFilteredProducts(String search, String[] categories, String[] brands, String sort) {
        List<SanPham> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT MaSanPham, TenSanPham, ThongTinSanPham, hinhAnh, thanhPhan, xuatXu, khoiLuong, GiaTien, SoLuong, danhMucId FROM SanPham WHERE is_deleted = 0");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (TenSanPham LIKE ? OR ThongTinSanPham LIKE ?)");
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }

        if (categories != null && categories.length > 0) {
            sql.append(" AND danhMucId IN (");
            for (int i = 0; i < categories.length; i++) {
                sql.append("?");
                if (i < categories.length - 1) sql.append(",");
                try {
                    params.add(Integer.parseInt(categories[i]));
                } catch (NumberFormatException e) {
                    params.add(-1); // invalid category
                }
            }
            sql.append(")");
        }

        if (brands != null && brands.length > 0) {
            sql.append(" AND (");
            for (int i = 0; i < brands.length; i++) {
                sql.append("LOWER(TenSanPham) LIKE ?");
                if (i < brands.length - 1) sql.append(" OR ");
                params.add("%" + brands[i].toLowerCase() + "%");
            }
            sql.append(")");
        }

        if ("price_asc".equals(sort)) {
            sql.append(" ORDER BY GiaTien ASC");
        } else if ("price_desc".equals(sort)) {
            sql.append(" ORDER BY GiaTien DESC");
        } else {
            sql.append(" ORDER BY MaSanPham DESC");
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham p = new SanPham();
                    p.setMaSanPham(rs.getInt("MaSanPham"));
                    p.setTenSanPham(rs.getString("TenSanPham"));
                    p.setThongTinSanPham(rs.getString("ThongTinSanPham"));
                    p.setHinhAnh(rs.getString("hinhAnh"));
                    p.setThanhPhan(rs.getString("thanhPhan"));
                    p.setXuatXu(rs.getString("xuatXu"));
                    p.setKhoiLuong(rs.getString("khoiLuong"));
                    p.setGiaTien(rs.getDouble("GiaTien"));
                    p.setSoLuong(rs.getInt("SoLuong"));
                    p.setDanhMucId(rs.getInt("danhMucId"));
                    list.add(p);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public List<SanPham> getSuggestedProducts(int danhMucId, int currentProductId, int limit) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT MaSanPham, TenSanPham, ThongTinSanPham, hinhAnh, thanhPhan, xuatXu, khoiLuong, GiaTien, SoLuong, danhMucId FROM SanPham WHERE danhMucId = ? AND MaSanPham != ? AND is_deleted = 0 LIMIT ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, danhMucId);
            ps.setInt(2, currentProductId);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SanPham p = new SanPham();
                    p.setMaSanPham(rs.getInt("MaSanPham"));
                    p.setTenSanPham(rs.getString("TenSanPham"));
                    p.setThongTinSanPham(rs.getString("ThongTinSanPham"));
                    p.setHinhAnh(rs.getString("hinhAnh"));
                    p.setThanhPhan(rs.getString("thanhPhan"));
                    p.setXuatXu(rs.getString("xuatXu"));
                    p.setKhoiLuong(rs.getString("khoiLuong"));
                    p.setGiaTien(rs.getDouble("GiaTien"));
                    p.setSoLuong(rs.getInt("SoLuong"));
                    p.setDanhMucId(rs.getInt("danhMucId"));
                    list.add(p);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }
}
