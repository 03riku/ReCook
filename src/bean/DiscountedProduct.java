package bean;
import java.io.Serializable;

public class DiscountedProduct implements Serializable {
    private int discountedProductId;
    private int discountRate;
    private int productId;
    private long storeId;
    // 表示用プロパティ
    private String productName;
    private String category;
    private int originalPrice;

    // Getters and Setters
    public int getDiscountedProductId() { return discountedProductId; }
    public void setDiscountedProductId(int discountedProductId) { this.discountedProductId = discountedProductId; }
    public int getDiscountRate() { return discountRate; }
    public void setDiscountRate(int discountRate) { this.discountRate = discountRate; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public long getStoreId() { return storeId; }
    public void setStoreId(long storeId) { this.storeId = storeId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public int getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(int originalPrice) { this.originalPrice = originalPrice; }
}