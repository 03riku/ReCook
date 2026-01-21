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

    /**
     * 指定したIDの料理を取得。さらに「そのユーザーがお気に入り登録しているか」を判定してfavoriteIdにセットする
     */
    public CookMenu getCookMenuById(int menuItemId, int userId) throws Exception {
        String sql = "SELECT * FROM COOK_MENU WHERE MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);

                // --- お気に入り判定の追加 ---
                String checkSql = "SELECT * FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
                try (PreparedStatement psFav = con.prepareStatement(checkSql)) {
                    psFav.setInt(1, userId);
                    psFav.setInt(2, menuItemId);
                    ResultSet rsFav = psFav.executeQuery();
                    // 存在すれば 2 (登録済)、なければ 1 (未登録)
                    menu.setFavoriteId(rsFav.next() ? 2 : 1);
                }
                return menu;
            }
        }
        return null;
    }

    // 他の検索メソッド等は既存のままでOK（必要に応じて同様にuserIdを渡す作りに拡張可能）
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

    // --- お気に入り関連 (重要：中間テーブル操作) ---

    /**
     * お気に入りの登録/解除を切り替える
     */
    public void toggleFavorite(int userId, int menuItemId) throws Exception {
        // 現在の登録状況を確認
        String checkSql = "SELECT * FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(checkSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, menuItemId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // すでに登録されているので削除（解除）
                String delSql = "DELETE FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
                try (PreparedStatement psDel = con.prepareStatement(delSql)) {
                    psDel.setInt(1, userId);
                    psDel.setInt(2, menuItemId);
                    psDel.executeUpdate();
                }
            } else {
                // 登録されていないので挿入（登録）
                String insSql = "INSERT INTO FAVORITE_MENU (USER_ID, MENU_ITEM_ID) VALUES (?, ?)";
                try (PreparedStatement psIns = con.prepareStatement(insSql)) {
                    psIns.setInt(1, userId);
                    psIns.setInt(2, menuItemId);
                    psIns.executeUpdate();
                }
            }
        }
    }

    /**
     * そのユーザーのお気に入り一覧を取得
     */
    public List<CookMenu> getFavoriteMenus(int userId) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT c.* FROM COOK_MENU c " +
                     "JOIN FAVORITE_MENU f ON c.MENU_ITEM_ID = f.MENU_ITEM_ID " +
                     "WHERE f.USER_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                menu.setFavoriteId(2); // 表示上「登録済」の状態にする
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