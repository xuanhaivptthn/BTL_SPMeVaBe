package Model;

public class CartItem {
    private SanPham product;
    private int quantity;

    public CartItem(SanPham product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    public SanPham getProduct() {
        return product;
    }

    public void setProduct(SanPham product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
