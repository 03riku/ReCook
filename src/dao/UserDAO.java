package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.CookMenu;
import bean.GeneralUser;
import bean.User_Store;

public class UserDAO {

    // ■ データベース接続
    private Connection getConnection() throws Exception {
        Class.forName("org.h2.Driver");
        String url = "jdbc:h2:tcp://localhost/~/Re.Cook";
        String user = "sa";
        String password = "";
        return DriverManager.getConnection(url, user, password);
    }

    // ======================================================
    // ユーザー関連（ログイン・登録）
    // ======================================================

    // ■ 新規登録用
    public boolean registerUser(String email, String password, String name) throws Exception {
        String sql = "INSERT INTO GENERAL_USER (EMAIL, USER_PASSWORD, ACCOUNT_NAME) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, name);
            return ps.executeUpdate() > 0;
        }
    }

    // ■ ログイン用（★エラーが出ていたメソッド）
    public GeneralUser checkLogin(String email, String password) throws Exception {
        String sql = "SELECT * FROM GENERAL_USER WHERE EMAIL = ? AND USER_PASSWORD = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                GeneralUser user = new GeneralUser();
                user.setUserId(rs.getInt("USER_ID"));
                user.setEmail(rs.getString("EMAIL"));
                user.setUserPassword(rs.getString("USER_PASSWORD"));
                user.setAccountName(rs.getString("ACCOUNT_NAME"));
                return user;
            }
            return null;
        }
    }

    // ======================================================
    // 料理メニュー関連（検索・詳細取得・お気に入り）
    // ======================================================

    // ■ 料理検索（あいまい検索）
    public List<CookMenu> searchCookMenu(String keyword) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT * FROM COOK_MENU WHERE DISH_NAME LIKE ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                menu.setMenuItemId(rs.getInt("MENU_ITEM_ID"));
                menu.setDishName(rs.getString("DISH_NAME"));
                menu.setDescription(rs.getString("DESCRIPTION"));
                menu.setCookTime(rs.getInt("COOK_TIME"));
                menu.setFavoriteId(rs.getInt("FAVORITE_ID"));
                list.add(menu);
            }
        }
        return list;
    }

    // ■ 料理詳細取得
    public CookMenu getCookMenuById(int id) throws Exception {
        CookMenu menu = null;
        String sql = "SELECT * FROM COOK_MENU WHERE MENU_ITEM_ID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                menu = new CookMenu();
                menu.setMenuItemId(rs.getInt("MENU_ITEM_ID"));
                menu.setDishName(rs.getString("DISH_NAME"));
                menu.setDescription(rs.getString("DESCRIPTION"));
                menu.setCookTime(rs.getInt("COOK_TIME"));
                menu.setFavoriteId(rs.getInt("FAVORITE_ID"));
                menu.setCouponId(rs.getInt("COUPON_ID"));
                menu.setStoreId(rs.getInt("STORE_ID"));
            }
        }
        return menu;
    }

    // ■ お気に入り反転（1⇔2）
    public boolean toggleFavorite(int menuItemId) throws Exception {
        CookMenu current = getCookMenuById(menuItemId);
        if (current == null) return false;
        int nextId = (current.getFavoriteId() == 1) ? 2 : 1;
        String sql = "UPDATE COOK_MENU SET FAVORITE_ID = ? WHERE MENU_ITEM_ID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, nextId);
            ps.setInt(2, menuItemId);
            return ps.executeUpdate() > 0;
        }
    }

    // ■ お気に入り一覧（ID=2のみ）
    public List<CookMenu> getFavoriteMenus() throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT * FROM COOK_MENU WHERE FAVORITE_ID = 2";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                menu.setMenuItemId(rs.getInt("MENU_ITEM_ID"));
                menu.setDishName(rs.getString("DISH_NAME"));
                menu.setCookTime(rs.getInt("COOK_TIME"));
                menu.setFavoriteId(rs.getInt("FAVORITE_ID"));
                list.add(menu);
            }
        }
        return list;
    }

    // ======================================================
    // 店舗関連
    // ======================================================

    // ■ 全店舗取得
    public List<User_Store> getAllStores() throws Exception {
        List<User_Store> list = new ArrayList<>();
        String sql = "SELECT * FROM STORE";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User_Store store = new User_Store();
                store.setStoreId(rs.getInt("STORE_ID"));
                store.setStoreName(rs.getString("STORE_NAME"));
                list.add(store);
            }
        }
        return list;
    }

    // ■ 店舗IDで料理を絞り込む（前回の追加機能）
    public List<CookMenu> getMenusByStoreId(int storeId) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT * FROM COOK_MENU WHERE STORE_ID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                menu.setMenuItemId(rs.getInt("MENU_ITEM_ID"));
                menu.setDishName(rs.getString("DISH_NAME"));
                menu.setDescription(rs.getString("DESCRIPTION"));
                menu.setCookTime(rs.getInt("COOK_TIME"));
                menu.setFavoriteId(rs.getInt("FAVORITE_ID"));
                menu.setStoreId(rs.getInt("STORE_ID"));
                list.add(menu);
            }
        }
        return list;
    }
}