package bean;

import java.io.Serializable;

public class FavoriteMenu implements Serializable {

	// フィールド
	private int favoriteId;
	// Foreign Keys
	private Integer menuItemId; // FK: cook_menu
	private Integer userId;     // FK: general_user

	// ■ デフォルトコンストラクタ
	public FavoriteMenu() {
	}

	// ■ ゲッターとセッター

	// favoriteId
	public int getFavoriteId() {
		return favoriteId;
	}
	public void setFavoriteId(int favoriteId) {
		this.favoriteId = favoriteId;
	}

	// menuItemId
	public Integer getMenuItemId() {
		return menuItemId;
	}
	public void setMenuItemId(Integer menuItemId) {
		this.menuItemId = menuItemId;
	}

	// userId
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
}