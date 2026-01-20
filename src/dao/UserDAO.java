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
                user.setAccountName(rs.getString("ACCOUNT_NAME"));
                return user;
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
    // ★エラー解決の鍵：このメソッドが MenuDetailServlet から呼ばれます
    public CookMenu getCookMenuById(int id) throws Exception {
        String sql = "SELECT * FROM COOK_MENU WHERE MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                return menu;
            }
        }
        return null;
    }

    public List<CookMenu> searchCookMenu(String keyword) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT DISTINCT c.* FROM COOK_MENU c " +
                     "LEFT JOIN STORE_PRODUCT sp ON c.MENU_ITEM_ID = sp.MENU_ITEM_ID " +
                     "WHERE c.DISH_NAME LIKE ? OR sp.PRODUCT_NAME LIKE ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String wild = "%" + (keyword != null ? keyword : "") + "%";
            ps.setString(1, wild); ps.setString(2, wild);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                list.add(menu);
            }
        }
        return list;
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
        String sql = "SELECT c.* FROM COOK_MENU c JOIN STORE_MENU sm ON c.MENU_ITEM_ID = sm.MENU_ITEM_ID WHERE sm.STORE_ID = ?";
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

    // --- 店舗関連 ---
    public User_Store getStoreById(int id) throws Exception {
        String sql = "SELECT * FROM STORE WHERE STORE_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User_Store s = new User_Store();
                s.setStoreId(rs.getInt("STORE_ID"));
                s.setStoreName(rs.getString("STORE_NAME"));
                s.setStoreAddress(rs.getString("STORE_ADDRESS"));
                return s;
            }
        }
        return null;
    }

    public List<String> getPrefectures() throws Exception {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT SUBSTRING(STORE_ADDRESS, 1, 3) AS PREF FROM STORE";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(rs.getString("PREF")); }
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
            if (keyword != null && !keyword.isEmpty()) {
                String w = "%" + keyword + "%";
                ps.setString(i++, w); ps.setString(i++, w);
            }
            if (pref != null && !pref.isEmpty()) ps.setString(i++, pref + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User_Store s = new User_Store();
                s.setStoreId(rs.getInt("STORE_ID"));
                s.setStoreName(rs.getString("STORE_NAME"));
                s.setStoreAddress(rs.getString("STORE_ADDRESS"));
                list.add(s);
            }
        }
        return list;
    }

    private void fillCookMenu(CookMenu menu, ResultSet rs) throws Exception {
        menu.setMenuItemId(rs.getInt("MENU_ITEM_ID"));
        menu.setDishName(rs.getString("DISH_NAME"));
        menu.setDescription(rs.getString("DESCRIPTION"));
        menu.setCookTime(rs.getInt("COOK_TIME"));
        menu.setGenreId(rs.getInt("GENRE_ID"));
    }
}