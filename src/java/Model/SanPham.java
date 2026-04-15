/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author gmtfarcb
 */
public class SanPham {

    private int MaSanPham;
    private String TenSanPham;
    private String ThongTinSanPham;
    private double GiaTien;
    private int SoLuong;
    private List<String> images = new ArrayList<>();

    public SanPham() {
    }

    public int getMaSanPham() {
        return MaSanPham;
    }

    public void setMaSanPham(int MaSanPham) {
        this.MaSanPham = MaSanPham;
    }

    public String getTenSanPham() {
        return TenSanPham;
    }

    public void setTenSanPham(String TenSanPham) {
        this.TenSanPham = TenSanPham;
    }

    public String getThongTinSanPham() {
        return ThongTinSanPham;
    }

    public void setThongTinSanPham(String ThongTinSanPham) {
        this.ThongTinSanPham = ThongTinSanPham;
    }

    public double getGiaTien() {
        return GiaTien;
    }

    public void setGiaTien(double GiaTien) {
        this.GiaTien = GiaTien;
    }

    public int getSoLuong() {
        return SoLuong;
    }

    public void setSoLuong(int SoLuong) {
        this.SoLuong = SoLuong;
    }

    public List getImages() {
        return images;
    }

    public void setImages(List images) {
        this.images = images;
    }

    public void addImage(String url) {
        this.images.add(url);
    }

    public void removeImage(String url) {
        this.images.remove(url);
    }

    @Override
    public String toString() {
        return "SanPham{" + "id=" + MaSanPham + ", name='" + TenSanPham + '\'' + ", price=" + GiaTien + '}';
    }

}
