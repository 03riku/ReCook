package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.CookMenu;
import bean.GeneralUser;
import bean.Product;
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
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { return rs.getInt(1) > 0; }
        }
        return false;
    }

    public GeneralUser checkLogin(String email, String password) throws Exception {
        String sql = "SELECT * FROM GENERAL_USER WHERE EMAIL = ? AND USER_PASSWORD = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
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

    // --- 料理メニュー ---
    public CookMenu getCookMenuById(int menuItemId, int userId) throws Exception {
        String sql = "SELECT c.*, g.GENRE_NAME FROM COOK_MENU c LEFT JOIN GENRE g ON c.GENRE_ID = g.GENRE_ID WHERE c.MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                menu.setGenreName(rs.getString("GENRE_NAME"));
                String checkSql = "SELECT * FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
                try (PreparedStatement psFav = con.prepareStatement(checkSql)) {
                    psFav.setInt(1, userId); psFav.setInt(2, menuItemId);
                    ResultSet rsFav = psFav.executeQuery();
                    menu.setFavoriteId(rsFav.next() ? 2 : 1);
                }
                return menu;
            }
        }
        return null;
    }

    public List<Product> getIngredientsByMenuId(int menuItemId) throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM PRODUCT p JOIN PRODUCT_COOK_MENU pcm ON p.PRODUCT_ID = pcm.PRODUCT_ID WHERE pcm.MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product(rs.getInt("PRODUCT_ID"), rs.getString("PRODUCT_NAME"), rs.getString("CATEGORY"));
                list.add(p);
            }
        }
        return list;
    }

    public List<CookMenu> searchCookMenu(String keyword) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT DISTINCT c.* FROM COOK_MENU c LEFT JOIN PRODUCT_COOK_MENU pcm ON c.MENU_ITEM_ID = pcm.MENU_ITEM_ID LEFT JOIN PRODUCT p ON pcm.PRODUCT_ID = p.PRODUCT_ID WHERE c.DISH_NAME LIKE ? OR p.PRODUCT_NAME LIKE ?";
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
            // 画像でエラーが出ていた箇所の修正：ResultSet rs = ps.executeQuery()
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CookMenu menu = new CookMenu();
                    fillCookMenu(menu, rs);
                    list.add(menu);
                }
            }
        }
        return list;
    }

    // ★ 修正箇所: 予定されているクーポン料理も表示し、時間を取得する
    public List<CookMenu> getMenusByStoreId(long storeId) throws Exception {
        List<CookMenu> list = new ArrayList<>();

        // SQL修正:
        // 1. START_TIME, END_TIME を両方取得
        // 2. 開始時間の制限をなくし、未来のものも取得。ただし終了したものは除外(END_TIME >= NOW)。
        String sql = "SELECT DISTINCT c.*, cp.START_TIME, cp.END_TIME FROM COOK_MENU c " +
                     "JOIN COUPON cp ON c.MENU_ITEM_ID = cp.MENU_ITEM_ID " +
                     "WHERE cp.STORE_ID = ? " +
                     "AND cp.END_TIME >= CURRENT_TIMESTAMP " +
                     "ORDER BY cp.START_TIME ASC";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CookMenu menu = new CookMenu();
                    fillCookMenu(menu, rs);

                    // 開始時間と終了時間をBeanにセット (比較用に yyyy-MM-dd HH:mm 形式)
                    String rawStart = rs.getString("START_TIME");
                    String rawEnd = rs.getString("END_TIME");

                    if (rawStart != null) menu.setStartTime(rawStart.substring(0, 16));
                    if (rawEnd != null) menu.setEndTime(rawEnd.substring(0, 16));

                    list.add(menu);
                }
            }
        }
        return list;
    }

    // --- お気に入り管理 ---
    public void toggleFavorite(int userId, int menuItemId) throws Exception {
        String checkSql = "SELECT * FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(checkSql)) {
            ps.setInt(1, userId); ps.setInt(2, menuItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String delSql = "DELETE FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
                try (PreparedStatement psDel = con.prepareStatement(delSql)) {
                    psDel.setInt(1, userId); psDel.setInt(2, menuItemId);
                    psDel.executeUpdate();
                }
            } else {
                String insSql = "INSERT INTO FAVORITE_MENU (USER_ID, MENU_ITEM_ID) VALUES (?, ?)";
                try (PreparedStatement psIns = con.prepareStatement(insSql)) {
                    psIns.setInt(1, userId); psIns.setInt(2, menuItemId);
                    psIns.executeUpdate();
                }
            }
        }
    }

    public List<CookMenu> getFavoriteMenus(int userId) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT c.* FROM COOK_MENU c JOIN FAVORITE_MENU f ON c.MENU_ITEM_ID = f.MENU_ITEM_ID WHERE f.USER_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                menu.setFavoriteId(2);
                list.add(menu);
            }
        }
        return list;
    }

    // --- 店舗管理 ---
    public User_Store getStoreById(long id) throws Exception {
        String sql = "SELECT * FROM STORE WHERE STORE_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User_Store s = new User_Store();
                s.setStoreId(rs.getLong("STORE_ID"));
                s.setStoreName(rs.getString("STORE_NAME"));
                s.setStoreAddress(rs.getString("STORE_ADDRESS"));
                return s;
            }
        }
        return null;
    }

    public List<User_Store> getStoresByMenuItemId(int menuItemId) throws Exception {
        List<User_Store> list = new ArrayList<>();
        String sql = "SELECT s.* FROM STORE s JOIN STORE_MENU sm ON s.STORE_ID = sm.STORE_ID WHERE sm.MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User_Store s = new User_Store();
                s.setStoreId(rs.getLong("STORE_ID"));
                s.setStoreName(rs.getString("STORE_NAME"));
                s.setStoreAddress(rs.getString("STORE_ADDRESS"));
                list.add(s);
            }
        }
        return list;
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
                s.setStoreId(rs.getLong("STORE_ID"));
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
        menu.setImage(rs.getString("IMAGE"));
    }
}