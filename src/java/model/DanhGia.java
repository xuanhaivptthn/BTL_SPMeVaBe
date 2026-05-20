package model;

import java.sql.Timestamp;

public class DanhGia {
    private int id;
    private int sanPhamId;
    private Integer khachHangId;
    private String hoTen;
    private int diemDanhGia;
    private String binhLuan;
    private String anhDanhGia;
    private boolean anDanh;
    private Timestamp createdAt;

    public DanhGia() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSanPhamId() {
        return sanPhamId;
    }

    public void setSanPhamId(int sanPhamId) {
        this.sanPhamId = sanPhamId;
    }

    public Integer getKhachHangId() {
        return khachHangId;
    }

    public void setKhachHangId(Integer khachHangId) {
        this.khachHangId = khachHangId;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public int getDiemDanhGia() {
        return diemDanhGia;
    }

    public void setDiemDanhGia(int diemDanhGia) {
        this.diemDanhGia = diemDanhGia;
    }

    public String getBinhLuan() {
        return binhLuan;
    }

    public void setBinhLuan(String binhLuan) {
        this.binhLuan = binhLuan;
    }

    public String getAnhDanhGia() {
        return anhDanhGia;
    }

    public void setAnhDanhGia(String anhDanhGia) {
        this.anhDanhGia = anhDanhGia;
    }

    public boolean isAnDanh() {
        return anDanh;
    }

    public void setAnDanh(boolean anDanh) {
        this.anDanh = anDanh;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
