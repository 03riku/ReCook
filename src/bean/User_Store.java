package bean;

import java.io.Serializable;

public class User_Store implements Serializable {
    private int storeId;
    private String storeName;
    private String storeAddress; // ★追加：住所を保持する変数

    // --- ゲッターとセッター ---
    public int getStoreId() { return storeId; }
    public void setStoreId(int storeId) { this.storeId = storeId; }

    public String getStoreName() { return storeName; }
    public void setStoreName(String storeName) { this.storeName = storeName; }

    public String getStoreAddress() { return storeAddress; } // ★追加
    public void setStoreAddress(String storeAddress) { this.storeAddress = storeAddress; } // ★追加
}