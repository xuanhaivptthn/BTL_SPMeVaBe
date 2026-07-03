package dao;

import model.SanPham;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SanPhamDAO {

    /** Maps the current ResultSet row to a SanPham object. */
    private SanPham mapRow(ResultSet rs) throws SQLException {
        SanPham p = new SanPham();
        p.setId(rs.getInt("id"));
        p.setTenSanPham(rs.getString("tenSanPham"));
        p.setThongTinSanPham(rs.getString("thongTinSanPham"));
        p.setHinhAnh(rs.getString("hinhAnh"));
        p.setThanhPhan(rs.getString("thanhPhan"));
        p.setXuatXu(rs.getString("xuatXu"));
        p.setKhoiLuong(rs.getString("khoiLuong"));
        p.setGiaTien(rs.getDouble("giaTien"));
        p.setSoLuong(rs.getInt("soLuong"));
        p.setDanhMucId(rs.getInt("danhMucId"));
        return p;
    }

    private static final String SQL_SELECT =
        "SELECT id, tenSanPham, thongTinSanPham, hinhAnh, thanhPhan, xuatXu, khoiLuong, giaTien, soLuong, danhMucId FROM SanPham";

    public List<SanPham> getAll() {
        List<SanPham> list = new ArrayList<>();
        String sql = SQL_SELECT + " WHERE is_deleted = 0";
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

    public SanPham getById(int id) {
        String sql = SQL_SELECT + " WHERE id = ? AND is_deleted = 0";
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

    public boolean insert(SanPham p) {
        String sql = "INSERT INTO SanPham (tenSanPham, thongTinSanPham, hinhAnh, thanhPhan, xuatXu, khoiLuong, giaTien, soLuong, danhMucId) VALUES (?,?,?,?,?,?,?,?,?)";
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
                if (keys.next()) p.setId(keys.getInt(1));
            }
            return true;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean update(SanPham p) {
        String sql = "UPDATE SanPham SET tenSanPham=?, thongTinSanPham=?, hinhAnh=?, thanhPhan=?, xuatXu=?, khoiLuong=?, giaTien=?, soLuong=?, danhMucId=?, updatedAt=NOW() WHERE id=?";
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
            ps.setInt(10, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "UPDATE SanPham SET is_deleted = 1 WHERE id = ?";
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
        StringBuilder sql = new StringBuilder(SQL_SELECT + " WHERE is_deleted = 0");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (tenSanPham LIKE ? OR thongTinSanPham LIKE ?)");
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
                sql.append("LOWER(tenSanPham) LIKE ?");
                if (i < brands.length - 1) sql.append(" OR ");
                params.add("%" + brands[i].toLowerCase() + "%");
            }
            sql.append(")");
        }

        if ("price_asc".equals(sort)) {
            sql.append(" ORDER BY giaTien ASC");
        } else {
            sql.append(" ORDER BY giaTien DESC");
        }

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

    public List<SanPham> getSuggestedProducts(int danhMucId, int currentProductId, int limit) {
        List<SanPham> list = new ArrayList<>();
        String sql = SQL_SELECT + " WHERE danhMucId = ? AND id != ? AND is_deleted = 0 LIMIT ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, danhMucId);
            ps.setInt(2, currentProductId);
            ps.setInt(3, limit);
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

    public List<SanPham> getNewProducts(int limit) {
        List<SanPham> list = new ArrayList<>();
        String sql = SQL_SELECT + " WHERE is_deleted = 0 ORDER BY id DESC LIMIT ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
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

    public List<SanPham> getFeaturedProducts(int limit) {
        List<SanPham> list = new ArrayList<>();
        String sql =
            "SELECT p.id, p.tenSanPham, p.thongTinSanPham, p.hinhAnh, p.thanhPhan, p.xuatXu, p.khoiLuong, p.giaTien, p.soLuong, p.danhMucId, " +
            "COALESCE(AVG(d.diemDanhGia), 0) AS avgRating " +
            "FROM SanPham p " +
            "LEFT JOIN DanhGia d ON p.id = d.sanPhamId " +
            "WHERE p.is_deleted = 0 " +
            "GROUP BY p.id, p.tenSanPham, p.thongTinSanPham, p.hinhAnh, p.thanhPhan, p.xuatXu, p.khoiLuong, p.giaTien, p.soLuong, p.danhMucId " +
            "ORDER BY avgRating DESC, p.id DESC LIMIT ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
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
}
