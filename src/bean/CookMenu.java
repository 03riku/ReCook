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

    // --- Các thuộc tính bổ sung cho hiển thị ---
    private String genreName;       // Tên thể loại (Join từ bảng Genre)
    private String image;           // Tên file ảnh (Lưu trong cột image hoặc tương tự)
    private List<Product> productList = new ArrayList<>(); // Danh sách nguyên liệu

    public CookMenu() {}

    // --- GETTERS & SETTERS ---

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

    // --- QUAN TRỌNG: Thêm Getter/Setter cho Image để sửa lỗi ---
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    // -----------------------------------------------------------

    public List<Product> getProductList() { return productList; }
    public void setProductList(List<Product> productList) { this.productList = productList; }
}