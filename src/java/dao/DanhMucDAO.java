package dao;

import model.DanhMuc;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DanhMucDAO {

    public List<DanhMuc> getAll() {
        List<DanhMuc> list = new ArrayList<>();
        String sql = "SELECT id, tenDanhMuc, moTa FROM DanhMuc";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DanhMuc c = new DanhMuc();
                c.setId(rs.getInt("id"));
                c.setTenDanhMuc(rs.getString("tenDanhMuc"));
                c.setMoTa(rs.getString("moTa"));
                list.add(c);
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public DanhMuc getById(int id) {
        String sql = "SELECT id, tenDanhMuc, moTa FROM DanhMuc WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DanhMuc c = new DanhMuc();
                    c.setId(rs.getInt("id"));
                    c.setTenDanhMuc(rs.getString("tenDanhMuc"));
                    c.setMoTa(rs.getString("moTa"));
                    return c;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }
}
