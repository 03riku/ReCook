package bean;

import java.io.Serializable;

public class User_Store implements Serializable {
    private int storeId;
    private String storeName;

    // --- ゲッターとセッター ---
    public int getStoreId() { return storeId; }
    public void setStoreId(int storeId) { this.storeId = storeId; }

    public String getStoreName() { return storeName; }
    public void setStoreName(String storeName) { this.storeName = storeName; }
}