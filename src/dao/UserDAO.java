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

    private Connection getConnection() throws Exception {
        Class.forName("org.h2.Driver");
        String url = "jdbc:h2:tcp://localhost/~/Re.Cook";
        String user = "sa";
        String password = "";
        return DriverManager.getConnection(url, user, password);
    }

    // --- ユーザー関連 ---
    public GeneralUser checkLogin(String email, String password) throws Exception {
        String sql = "SELECT * FROM GENERAL_USER WHERE EMAIL = ? AND USER_PASSWORD = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email); ps.setString(2, password);
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

    public boolean registerUser(String email, String password, String name) throws Exception {
        String sql = "INSERT INTO GENERAL_USER (EMAIL, USER_PASSWORD, ACCOUNT_NAME) VALUES (?, ?, ?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email); ps.setString(2, password); ps.setString(3, name);
            return ps.executeUpdate() > 0;
        }
    }

    // --- 料理メニュー関連 ---
    public List<CookMenu> searchCookMenu(String keyword) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT * FROM COOK_MENU WHERE DISH_NAME LIKE ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                list.add(menu);
            }
        }
        return list;
    }

    public CookMenu getCookMenuById(int id) throws Exception {
        CookMenu menu = null;
        String sql = "SELECT * FROM COOK_MENU WHERE MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                menu = new CookMenu();
                fillCookMenu(menu, rs);
                menu.setCouponId(rs.getInt("COUPON_ID"));
            }
        }
        return menu;
    }

    public List<CookMenu> getMenusByGenreId(int genreId) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT * FROM COOK_MENU WHERE GENRE_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, genreId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                list.add(menu);
            }
        }
        return list;
    }

    public List<CookMenu> getMenusByStoreId(int storeId) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT * FROM COOK_MENU WHERE STORE_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                list.add(menu);
            }
        }
        return list;
    }

    // --- お気に入り関連 ---
    public boolean toggleFavorite(int id) throws Exception {
        CookMenu current = getCookMenuById(id);
        if (current == null) return false;
        int nextId = (current.getFavoriteId() == 1) ? 2 : 1;
        String sql = "UPDATE COOK_MENU SET FAVORITE_ID = ? WHERE MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, nextId); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    public List<CookMenu> getFavoriteMenus() throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT * FROM COOK_MENU WHERE FAVORITE_ID = 2";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                list.add(menu);
            }
        }
        return list;
    }

    // --- 店舗関連（★ここを修正） ---
    public List<User_Store> getAllStores() throws Exception {
        List<User_Store> list = new ArrayList<>();
        String sql = "SELECT * FROM STORE";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
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

    // ★店舗検索メソッドを追加
    public List<User_Store> searchStores(String keyword) throws Exception {
        List<User_Store> list = new ArrayList<>();
        String sql = "SELECT * FROM STORE WHERE STORE_NAME LIKE ? OR STORE_ADDRESS LIKE ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
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

    private void fillCookMenu(CookMenu menu, ResultSet rs) throws Exception {
        menu.setMenuItemId(rs.getInt("MENU_ITEM_ID"));
        menu.setDishName(rs.getString("DISH_NAME"));
        menu.setDescription(rs.getString("DESCRIPTION"));
        menu.setCookTime(rs.getInt("COOK_TIME"));
        menu.setFavoriteId(rs.getInt("FAVORITE_ID"));
        menu.setStoreId(rs.getInt("STORE_ID"));
        menu.setGenreId(rs.getInt("GENRE_ID"));
    }
}