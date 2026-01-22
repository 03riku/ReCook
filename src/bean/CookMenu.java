package bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class CookMenu implements Serializable {
    private int menuItemId;
    private String dishName;
    private String description;
    private int cookTime;
    private int genreId;

    // --- 表示用の追加属性 ---
    private String genreName;
    private String image;           // データベースの image 列の値
    private int favoriteId;         // 1:未登録, 2:登録済み

    // ★ List<String> から List<Product> に変更しました
    private List<Product> productList = new ArrayList<>();

    public CookMenu() {}

    // --- ゲッターとセッター ---
    public int getMenuItemId() { return menuItemId; }
    public void setMenuItemId(int menuItemId) { this.menuItemId = menuItemId; }

    public String getDishName() { return dishName; }
    public void setDishName(String dishName) { this.dishName = dishName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCookTime() { return cookTime; }
    public void setCookTime(int cookTime) { this.cookTime = cookTime; }

    public int getGenreId() { return genreId; }
    public void setGenreId(int genreId) { this.genreId = genreId; }

    public String getGenreName() { return genreName; }
    public void setGenreName(String genreName) { this.genreName = genreName; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public int getFavoriteId() { return favoriteId; }
    public void setFavoriteId(int favoriteId) { this.favoriteId = favoriteId; }

    // ★ ゲッターの戻り値を List<Product> に変更
    public List<Product> getProductList() {
        return productList;
    }

    // ★ セッターの引数を List<Product> に変更
    public void setProductList(List<Product> productList) {
        this.productList = productList;
    }
}