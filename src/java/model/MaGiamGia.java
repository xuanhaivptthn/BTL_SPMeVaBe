package model;

import java.time.LocalDateTime;

public class MaGiamGia {
    private int id;
    private String ma;
    private String moTa;
    private String loaiGiamGia; // 'PERCENT' hoặc 'AMOUNT'
    private double giaTriGiam;
    private double giaTriDonHangToiThieu;
    private double giamToiDa;
    private LocalDateTime ngayHetHan;
    private String trangThai;
    private boolean isDeleted;

    public MaGiamGia() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMa() {
        return ma;
    }

    public void setMa(String ma) {
        this.ma = ma;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public String getLoaiGiamGia() {
        return loaiGiamGia;
    }

    public void setLoaiGiamGia(String loaiGiamGia) {
        this.loaiGiamGia = loaiGiamGia;
    }

    public double getGiaTriGiam() {
        return giaTriGiam;
    }

    public void setGiaTriGiam(double giaTriGiam) {
        this.giaTriGiam = giaTriGiam;
    }

    public double getGiaTriDonHangToiThieu() {
        return giaTriDonHangToiThieu;
    }

    public void setGiaTriDonHangToiThieu(double giaTriDonHangToiThieu) {
        this.giaTriDonHangToiThieu = giaTriDonHangToiThieu;
    }

    public double getGiamToiDa() {
        return giamToiDa;
    }

    public void setGiamToiDa(double giamToiDa) {
        this.giamToiDa = giamToiDa;
    }

    public LocalDateTime getNgayHetHan() {
        return ngayHetHan;
    }

    public void setNgayHetHan(LocalDateTime ngayHetHan) {
        this.ngayHetHan = ngayHetHan;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }
}
