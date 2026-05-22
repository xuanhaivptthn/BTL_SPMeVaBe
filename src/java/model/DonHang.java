package model;

import java.time.LocalDateTime;

public class DonHang {
    private int id;
    private int khachHangId;
    private LocalDateTime ngayDat;
    private double tongTien;
    private String trangThai;
    private String tenNguoiNhan;
    private String sdtNhanHang;
    private String diaChiGiaoHang;
    private String ghiChu;
    private boolean khachHangDaCapNhat;
    private String maGiamGia;
    private double soTienGiam;
    private String phuongThucThanhToan;

    public DonHang() {
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

    public LocalDateTime getNgayDat() {
        return ngayDat;
    }

    public void setNgayDat(LocalDateTime ngayDat) {
        this.ngayDat = ngayDat;
    }

    public String getNgayDatFormatted() {
        if (ngayDat == null) return "";
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
        return ngayDat.format(formatter);
    }

    public double getTongTien() {
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getTenNguoiNhan() {
        return tenNguoiNhan;
    }

    public void setTenNguoiNhan(String tenNguoiNhan) {
        this.tenNguoiNhan = tenNguoiNhan;
    }

    public String getSdtNhanHang() {
        return sdtNhanHang;
    }

    public void setSdtNhanHang(String sdtNhanHang) {
        this.sdtNhanHang = sdtNhanHang;
    }

    public String getDiaChiGiaoHang() {
        return diaChiGiaoHang;
    }

    public void setDiaChiGiaoHang(String diaChiGiaoHang) {
        this.diaChiGiaoHang = diaChiGiaoHang;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public boolean isKhachHangDaCapNhat() {
        return khachHangDaCapNhat;
    }

    public void setKhachHangDaCapNhat(boolean khachHangDaCapNhat) {
        this.khachHangDaCapNhat = khachHangDaCapNhat;
    }

    public String getMaGiamGia() {
        return maGiamGia;
    }

    public void setMaGiamGia(String maGiamGia) {
        this.maGiamGia = maGiamGia;
    }

    public double getSoTienGiam() {
        return soTienGiam;
    }

    public void setSoTienGiam(double soTienGiam) {
        this.soTienGiam = soTienGiam;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }

    public void setPhuongThucThanhToan(String phuongThucThanhToan) {
        this.phuongThucThanhToan = phuongThucThanhToan;
    }
}
