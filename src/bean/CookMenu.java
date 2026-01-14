package bean;

import java.io.Serializable;

public class CookMenu implements Serializable {

	// フィールド（DAOで取得しているカラムに対応）
	private int menuItemId;   // MENU_ITEM_ID
	private String menuName;  // MENU_NAME
	private int cookTime;     // COOK_TIME
	// 必要であれば画像パスなどのフィールドも追加してください
	// private String image;

	// コンストラクタ
	public CookMenu() {}

	// ■■■ ゲッターとセッター ■■■

	// menuItemId
	public int getMenuItemId() {
		return menuItemId;
	}
	public void setMenuItemId(int menuItemId) {
		this.menuItemId = menuItemId;
	}

	// menuName
	public String getMenuName() {
		return menuName;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	// cookTime
	public int getCookTime() {
		return cookTime;
	}
	public void setCookTime(int cookTime) {
		this.cookTime = cookTime;
	}
}