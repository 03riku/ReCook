package bean;

import java.io.Serializable;

public class Store implements Serializable {
	private long storeId; // Kiểu long cho 10 chữ số
	private String storeName;
	private String storePassword;
	private String storeAddress;

	public Store() {
	}

	public Store(long storeId, String storeName, String storePassword, String storeAddress) {
		this.storeId = storeId;
		this.storeName = storeName;
		this.storePassword = storePassword;
		this.storeAddress = storeAddress;
	}

	public long getStoreId() {
		return storeId;
	}

	public void setStoreId(long storeId) {
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