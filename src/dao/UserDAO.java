package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import bean.CookMenu;
import bean.GeneralUser;
import bean.Product;
import bean.StoreProduct;
import bean.User_Store;

public class UserDAO {

    private Connection getConnection() throws Exception {
        Class.forName("org.h2.Driver");
        String url = "jdbc:h2:tcp://localhost/~/Re.Cook";
        String user = "sa";
        String password = "";
        return DriverManager.getConnection(url, user, password);
    }

    // --- ユーザー管理 ---
    public boolean isEmailExists(String email) throws Exception {
        String sql = "SELECT COUNT(*) FROM GENERAL_USER WHERE EMAIL = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1) > 0; }
        }
        return false;
    }

    public GeneralUser checkLogin(String email, String password) throws Exception {
        String sql = "SELECT * FROM GENERAL_USER WHERE EMAIL = ? AND USER_PASSWORD = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email); ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    GeneralUser user = new GeneralUser();
                    user.setUserId(rs.getInt("USER_ID"));
                    user.setEmail(rs.getString("EMAIL"));
                    user.setAccountName(rs.getString("ACCOUNT_NAME"));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean registerUser(String email, String password, String name) throws Exception {
        String sql = "INSERT INTO GENERAL_USER (EMAIL, USER_PASSWORD, ACCOUNT_NAME) VALUES (?, ?, ?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email); ps.setString(2, password); ps.setString(3, name);
            return ps.executeUpdate() > 0;
        }
    }

    // --- 料理メニュー関連 ---
    public CookMenu getCookMenuById(int menuItemId, int userId) throws Exception {
        String sql = "SELECT c.*, g.GENRE_NAME FROM COOK_MENU c LEFT JOIN GENRE g ON c.GENRE_ID = g.GENRE_ID WHERE c.MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CookMenu menu = new CookMenu();
                    fillCookMenu(menu, rs);
                    menu.setGenreName(rs.getString("GENRE_NAME"));
                    String checkSql = "SELECT * FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
                    try (PreparedStatement psFav = con.prepareStatement(checkSql)) {
                        psFav.setInt(1, userId); psFav.setInt(2, menuItemId);
                        try (ResultSet rsFav = psFav.executeQuery()) { menu.setFavoriteId(rsFav.next() ? 2 : 1); }
                    }
                    return menu;
                }
            }
        }
        return null;
    }

    public List<CookMenu> searchCookMenu(String keyword) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT DISTINCT c.*, cp.START_TIME, cp.END_TIME FROM COOK_MENU c " +
                     "LEFT JOIN PRODUCT_COOK_MENU pcm ON c.MENU_ITEM_ID = pcm.MENU_ITEM_ID " +
                     "LEFT JOIN PRODUCT p ON pcm.PRODUCT_ID = p.PRODUCT_ID " +
                     "LEFT JOIN COUPON cp ON c.MENU_ITEM_ID = cp.MENU_ITEM_ID AND cp.END_TIME >= CURRENT_TIMESTAMP " +
                     "WHERE c.DISH_NAME LIKE ? OR p.PRODUCT_NAME LIKE ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String wild = "%" + (keyword != null ? keyword : "") + "%";
            ps.setString(1, wild); ps.setString(2, wild);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CookMenu menu = new CookMenu();
                    fillCookMenu(menu, rs);
                    setTimeInfo(menu, rs);
                    list.add(menu);
                }
            }
        }
        return list;
    }

    public List<CookMenu> getMenusByGenreId(int genreId) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT DISTINCT c.*, cp.START_TIME, cp.END_TIME FROM COOK_MENU c " +
                     "LEFT JOIN COUPON cp ON c.MENU_ITEM_ID = cp.MENU_ITEM_ID AND cp.END_TIME >= CURRENT_TIMESTAMP " +
                     "WHERE c.GENRE_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, genreId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CookMenu menu = new CookMenu();
                    fillCookMenu(menu, rs);
                    setTimeInfo(menu, rs);
                    list.add(menu);
                }
            }
        }
        return list;
    }

    // ★修正：STORE_MENUテーブルを結合して販売価格(PRICE)を取得
    public List<CookMenu> getMenusByStoreId(long storeId) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT DISTINCT c.*, cp.START_TIME, cp.END_TIME, sm.PRICE FROM COOK_MENU c " +
                     "JOIN COUPON cp ON c.MENU_ITEM_ID = cp.MENU_ITEM_ID " +
                     "JOIN STORE_MENU sm ON c.MENU_ITEM_ID = sm.MENU_ITEM_ID AND sm.STORE_ID = cp.STORE_ID " +
                     "WHERE cp.STORE_ID = ? AND cp.END_TIME >= CURRENT_TIMESTAMP " +
                     "ORDER BY cp.START_TIME ASC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CookMenu menu = new CookMenu();
                    fillCookMenu(menu, rs);
                    setTimeInfo(menu, rs);
                    menu.setSalePrice(rs.getInt("PRICE")); // 価格をセット
                    list.add(menu);
                }
            }
        }
        return list;
    }

    public List<String> getPrefectures() throws Exception {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT SUBSTRING(STORE_ADDRESS, 1, 3) AS PREF FROM STORE";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(rs.getString("PREF")); }
        }
        return list;
    }

    public List<User_Store> searchStores(String keyword, String pref) throws Exception {
        List<User_Store> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM STORE WHERE 1=1 ");
        if (keyword != null && !keyword.isEmpty()) sql.append("AND (STORE_NAME LIKE ? OR STORE_ADDRESS LIKE ?) ");
        if (pref != null && !pref.isEmpty()) sql.append("AND STORE_ADDRESS LIKE ? ");
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int i = 1;
            if (keyword != null && !keyword.isEmpty()) { String w = "%" + keyword + "%"; ps.setString(i++, w); ps.setString(i++, w); }
            if (pref != null && !pref.isEmpty()) ps.setString(i++, pref + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User_Store s = new User_Store();
                    s.setStoreId(rs.getLong("STORE_ID"));
                    s.setStoreName(rs.getString("STORE_NAME"));
                    s.setStoreAddress(rs.getString("STORE_ADDRESS"));
                    list.add(s);
                }
            }
        }
        return list;
    }

    public User_Store getStoreById(long id) throws Exception {
        String sql = "SELECT * FROM STORE WHERE STORE_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User_Store s = new User_Store();
                    s.setStoreId(rs.getLong("STORE_ID"));
                    s.setStoreName(rs.getString("STORE_NAME"));
                    s.setStoreAddress(rs.getString("STORE_ADDRESS"));
                    return s;
                }
            }
        }
        return null;
    }

    public void toggleFavorite(int userId, int menuItemId) throws Exception {
        String checkSql = "SELECT * FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
        try (Connection con = getConnection()) {
            boolean exists = false;
            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setInt(1, userId); ps.setInt(2, menuItemId);
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) exists = true; }
            }
            if (exists) {
                String delSql = "DELETE FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
                try (PreparedStatement psDel = con.prepareStatement(delSql)) { psDel.setInt(1, userId); psDel.setInt(2, menuItemId); psDel.executeUpdate(); }
            } else {
                String insSql = "INSERT INTO FAVORITE_MENU (USER_ID, MENU_ITEM_ID) VALUES (?, ?)";
                try (PreparedStatement psIns = con.prepareStatement(insSql)) { psIns.setInt(1, userId); psIns.setInt(2, menuItemId); psIns.executeUpdate(); }
            }
        }
    }

    // ★修正：rs.executeQuery() -> ps.executeQuery()
    public List<CookMenu> getFavoriteMenus(int userId) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT c.* FROM COOK_MENU c JOIN FAVORITE_MENU f ON c.MENU_ITEM_ID = f.MENU_ITEM_ID WHERE f.USER_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CookMenu menu = new CookMenu();
                    fillCookMenu(menu, rs);
                    menu.setFavoriteId(2);
                    list.add(menu);
                }
            }
        }
        return list;
    }

    public List<User_Store> getStoresByMenuItemId(int menuItemId) throws Exception {
        List<User_Store> list = new ArrayList<>();
        String sql = "SELECT s.* FROM STORE s JOIN STORE_MENU sm ON s.STORE_ID = sm.STORE_ID WHERE sm.MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User_Store s = new User_Store();
                    s.setStoreId(rs.getLong("STORE_ID"));
                    s.setStoreName(rs.getString("STORE_NAME"));
                    s.setStoreAddress(rs.getString("STORE_ADDRESS"));
                    list.add(s);
                }
            }
        }
        return list;
    }

    public List<Product> getIngredientsByMenuId(int menuItemId) throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM PRODUCT p JOIN PRODUCT_COOK_MENU pcm ON p.PRODUCT_ID = pcm.PRODUCT_ID WHERE pcm.MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(rs.getInt("PRODUCT_ID"), rs.getString("PRODUCT_NAME"), rs.getString("CATEGORY"));
                    list.add(p);
                }
            }
        }
        return list;
    }

    public List<StoreProduct> getIngredientsWithPrices(int menuItemId, long storeId) throws Exception {
        List<StoreProduct> list = new ArrayList<>();
        String sql = "SELECT sp.* FROM PRODUCT_COOK_MENU pcm " +
                     "JOIN STORE_PRODUCT sp ON pcm.PRODUCT_ID = sp.PRODUCT_ID " +
                     "WHERE pcm.MENU_ITEM_ID = ? AND sp.STORE_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            ps.setLong(2, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StoreProduct sp = new StoreProduct();
                    sp.setStoreProductId(rs.getInt("STORE_PRODUCT_ID"));
                    sp.setProductName(rs.getString("PRODUCT_NAME"));
                    sp.setCategory(rs.getString("CATEGORY"));
                    sp.setPrice(rs.getInt("PRICE"));
                    sp.setProductId(rs.getInt("PRODUCT_ID"));
                    list.add(sp);
                }
            }
        }
        return list;
    }

    // ★店舗での販売価格と割引率を取得（Map形式で返す）
    public Map<String, Integer> getStorePricing(int menuItemId, long storeId) throws Exception {
        String sql = "SELECT sm.PRICE, c.DISCOUNT_RATE FROM STORE_MENU sm " +
                     "LEFT JOIN COUPON c ON sm.COUPON_ID = c.COUPON_ID " +
                     "WHERE sm.MENU_ITEM_ID = ? AND sm.STORE_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            ps.setLong(2, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Integer> map = new HashMap<>();
                    map.put("price", rs.getInt("PRICE"));
                    map.put("rate", rs.getInt("DISCOUNT_RATE"));
                    return map;
                }
            }
        }
        return null;
    }

    private void fillCookMenu(CookMenu menu, ResultSet rs) throws Exception {
        menu.setMenuItemId(rs.getInt("MENU_ITEM_ID"));
        menu.setDishName(rs.getString("DISH_NAME"));
        menu.setDescription(rs.getString("DESCRIPTION"));
        menu.setCookTime(rs.getInt("COOK_TIME"));
        menu.setGenreId(rs.getInt("GENRE_ID"));
        menu.setImage(rs.getString("IMAGE"));
    }

    private void setTimeInfo(CookMenu menu, ResultSet rs) throws Exception {
        String rawStart = rs.getString("START_TIME");
        String rawEnd = rs.getString("END_TIME");
        if (rawStart != null) menu.setStartTime(rawStart.substring(0, 16));
        if (rawEnd != null) menu.setEndTime(rawEnd.substring(0, 16));
    }
 // UserDAOクラス内に追加してください

    // ============================================================
    //  【追加】クーポン価格の取得
    //   詳細画面で表示するため、指定した店舗・メニューの価格を取得する
    // ============================================================
    public Integer getCouponPrice(long storeId, int menuItemId) throws Exception {
        // 現在有効なクーポンの価格を取得
        String sql = "SELECT PRICE FROM COUPON WHERE STORE_ID = ? AND MENU_ITEM_ID = ? AND END_TIME >= CURRENT_TIMESTAMP";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, storeId);
            ps.setInt(2, menuItemId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // priceカラムの値を返す
                    return rs.getInt("PRICE");
                }
            }
        }
        return null; // クーポンがない、または期限切れの場合
    }
    public Integer getMenuPrice(long storeId, int menuItemId) throws Exception {
        String sql = "SELECT price FROM store_menu WHERE store_id = ? AND menu_item_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, storeId);
            ps.setInt(2, menuItemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("price");
                }
            }
        }
        return null;
    }
}
