package bean;

public class StoreProduct {
    private int storeProductId;
    private String productName;
    private String category;
    private int price;
    private int productId; // ★追加：これがないとJSPでエラーになります

    public int getStoreProductId() {
        return storeProductId;
    }
    public void setStoreProductId(int storeProductId) {
        this.storeProductId = storeProductId;
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
    public int getPrice() {
        return price;
    }
    public void setPrice(int price) {
        this.price = price;
    }

    // ★追加：GetterとSetter
    public int getProductId() {
        return productId;
    }
    public void setProductId(int productId) {
        this.productId = productId;
    }
}