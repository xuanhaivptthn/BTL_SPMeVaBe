package model;

import java.sql.Timestamp;

public class DiaChiNhanHang {
    private int id;
    private int khachHangId;
    private String tenNguoiNhan;
    private String soDienThoai;
    private String diaChi;
    private boolean isDefault;
    private Timestamp createdAt;

    public DiaChiNhanHang() {
    }

    public DiaChiNhanHang(int id, int khachHangId, String tenNguoiNhan, String soDienThoai, String diaChi, boolean isDefault, Timestamp createdAt) {
        this.id = id;
        this.khachHangId = khachHangId;
        this.tenNguoiNhan = tenNguoiNhan;
        this.soDienThoai = soDienThoai;
        this.diaChi = diaChi;
        this.isDefault = isDefault;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getKhachHangId() {
        return khachHangId;
    }

    public void setKhachHangId(int khachHangId) {
        this.khachHangId = khachHangId;
    }

    public String getTenNguoiNhan() {
        return tenNguoiNhan;
    }

    public void setTenNguoiNhan(String tenNguoiNhan) {
        this.tenNguoiNhan = tenNguoiNhan;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
