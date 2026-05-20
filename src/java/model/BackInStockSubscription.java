package model;

import java.time.LocalDateTime;

public class BackInStockSubscription {
    private int id;
    private int productId;
    private String email;
    private LocalDateTime createdAt;

    public BackInStockSubscription() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
