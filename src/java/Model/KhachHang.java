package Model;

public class KhachHang extends NguoiDung {
    private int diemTichLuy;

    public KhachHang() {
        super();
        this.role = "CUSTOMER";
    }

    public int getDiemTichLuy() {
        return diemTichLuy;
    }

    public void setDiemTichLuy(int diemTichLuy) {
        this.diemTichLuy = diemTichLuy;
    }
}
