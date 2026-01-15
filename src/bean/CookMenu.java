package bean;

import java.io.Serializable;

public class CookMenu implements Serializable {
    private int menuItemId;
    private String dishName;
    private String description;
    private int cookTime;
    private int genreId; // ★追加
    private int couponId;
    private int favoriteId;
    private int storeId;

    // --- ゲッターとセッター ---
    public int getMenuItemId() { return menuItemId; }
    public void setMenuItemId(int menuItemId) { this.menuItemId = menuItemId; }

    public String getDishName() { return dishName; }
    public void setDishName(String dishName) { this.dishName = dishName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCookTime() { return cookTime; }
    public void setCookTime(int cookTime) { this.cookTime = cookTime; }

    public int getGenreId() { return genreId; } // ★追加
    public void setGenreId(int genreId) { this.genreId = genreId; } // ★追加

    public int getCouponId() { return couponId; }
    public void setCouponId(int couponId) { this.couponId = couponId; }

    public int getFavoriteId() { return favoriteId; }
    public void setFavoriteId(int favoriteId) { this.favoriteId = favoriteId; }

    public int getStoreId() { return storeId; }
    public void setStoreId(int storeId) { this.storeId = storeId; }
}