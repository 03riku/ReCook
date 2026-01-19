package bean;

import java.io.Serializable;

/**
 * Bean đại diện cho bảng 'product' (Master Data)
 * Cột: product_id, product_name, category
 */
public class Product implements Serializable {
    private static final long serialVersionUID = 1L;

    private int productId;
    private String productName;
    private String category;

    // Default Constructor
    public Product() {
    }

    // Constructor đầy đủ (Sửa lỗi: コンストラクター Product(int, String, String) は未定義です)
    public Product(int productId, String productName, String category) {
        this.productId = productId;
        this.productName = productName;
        this.category = category;
    }

    // Getters and Setters
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}