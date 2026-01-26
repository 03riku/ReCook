package bean;

import java.io.Serializable;

public class User_Store implements Serializable {
    private long storeId; // ★ int から long に変更
    private String storeName;
    private String storeAddress;

    // ★ long 用のゲッターとセッター
    public long getStoreId() { return storeId; }
    public void setStoreId(long storeId) { this.storeId = storeId; }

    public String getStoreName() { return storeName; }
    public void setStoreName(String storeName) { this.storeName = storeName; }

    public String getStoreAddress() { return storeAddress; }
    public void setStoreAddress(String storeAddress) { this.storeAddress = storeAddress; }
}