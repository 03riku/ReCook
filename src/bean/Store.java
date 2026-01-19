package bean;

import java.io.Serializable;

public class Store implements Serializable {
    private int storeId;
    private String storeName;
    private String storePassword;
    private String storeAddress;

    // Constructor mặc định
    public Store() {
    }

    // Constructor đầy đủ
    public Store(int storeId, String storeName, String storePassword, String storeAddress) {
        this.storeId = storeId;
        this.storeName = storeName;
        this.storePassword = storePassword;
        this.storeAddress = storeAddress;
    }

    // Getters và Setters
    public int getStoreId() {
        return storeId;
    }

    public void setStoreId(int storeId) {
        this.storeId = storeId;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public String getStorePassword() {
        return storePassword;
    }

    public void setStorePassword(String storePassword) {
        this.storePassword = storePassword;
    }

    public String getStoreAddress() {
        return storeAddress;
    }

    public void setStoreAddress(String storeAddress) {
        this.storeAddress = storeAddress;
    }
}