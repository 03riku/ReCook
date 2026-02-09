package bean;

import java.io.Serializable;

/**
 * ユーザーが「どの料理をお気に入りしたか」を管理するためのクラス（JavaBean）
 */
public class FavoriteMenu implements Serializable {

	// --- データを保存する変数（フィールド） ---

	// お気に入り自体の管理ID（主キー）
	private int favoriteId;

	// 料理のID（どの料理か：cook_menuテーブルと繋がっています）
	private Integer menuItemId;

	// ユーザーのID（誰がお気に入りしたか：general_userテーブルと繋がっています）
	private Integer userId;

	// --- 準備（コンストラクタ） ---

	// クラスを使うための初期化処理（中身は空っぽでOK）
	public FavoriteMenu() {
	}

	// --- データの出し入れ（ゲッターとセッター） ---

	// favoriteId（管理番号）を取得する
	public int getFavoriteId() {
		return favoriteId;
	}
	// favoriteId（管理番号）を設定する
	public void setFavoriteId(int favoriteId) {
		this.favoriteId = favoriteId;
	}

	// menuItemId（料理の番号）を取得する
	public Integer getMenuItemId() {
		return menuItemId;
	}
	// menuItemId（料理の番号）を設定する
	public void setMenuItemId(Integer menuItemId) {
		this.menuItemId = menuItemId;
	}

	// userId（ユーザーの番号）を取得する
	public Integer getUserId() {
		return userId;
	}
	// userId（ユーザーの番号）を設定する
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
}