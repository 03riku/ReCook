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
    private String image;
    private int favoriteId;
    private String startTime;
    private String endTime;

    // ★追加：店舗メニューでの販売価格
    private int salePrice;

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

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public int getSalePrice() { return salePrice; }
    public void setSalePrice(int salePrice) { this.salePrice = salePrice; }

    public List<Product> getProductList() { return productList; }
    public void setProductList(List<Product> productList) { this.productList = productList; }
}