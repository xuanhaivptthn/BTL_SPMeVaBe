package Model;

public class NhanVien extends NguoiDung {
    private String maNhanVien;
    private String chucVu;

    public NhanVien() {
        super();
        this.role = "ADMIN";
    }

    public String getMaNhanVien() {
        return maNhanVien;
    }

    public void setMaNhanVien(String maNhanVien) {
        this.maNhanVien = maNhanVien;
    }

    public String getChucVu() {
        return chucVu;
    }

    public void setChucVu(String chucVu) {
        this.chucVu = chucVu;
    }
}
