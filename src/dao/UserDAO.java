package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.CookMenu;
import bean.GeneralUser;

public class UserDAO {

    // ■ データベース接続メソッド
    private Connection getConnection() throws Exception {
        // H2データベースのドライバクラスをロード
        Class.forName("org.h2.Driver");

        // 接続情報
        String url = "jdbc:h2:tcp://localhost/~/Re.Cook";
        String user = "sa";     // ユーザー名
        String password = "";   // パスワード

        // 接続を確立して返す
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

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    // ■ ログイン用
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

    // ■ 料理検索メソッド
    public List<CookMenu> searchCookMenu(String keyword) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        // DISH_NAME カラムに対して、あいまい検索を行う
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

    // ■ 料理詳細取得メソッド
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
                menu.setCouponId(rs.getInt("COUPON_ID"));
                menu.setFavoriteId(rs.getInt("FAVORITE_ID"));
                menu.setStoreId(rs.getInt("STORE_ID"));
            }
        }
        return menu;
    }

    // ■ お気に入りの状態を切り替えるメソッド (1:未登録 ⇔ 2:登録済)
    public boolean toggleFavorite(int menuItemId) throws Exception {
        // 現在の状態を取得
        CookMenu currentMenu = getCookMenuById(menuItemId);
        if (currentMenu == null) return false;

        // 現在が1なら2へ、2なら1へ切り替える
        int newFavoriteId = (currentMenu.getFavoriteId() == 1) ? 2 : 1;

        String sql = "UPDATE COOK_MENU SET FAVORITE_ID = ? WHERE MENU_ITEM_ID = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, newFavoriteId);
            ps.setInt(2, menuItemId);

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    // ■ お気に入り一覧取得メソッド (FAVORITE_ID = 2 のものだけ取得)
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
                menu.setDescription(rs.getString("DESCRIPTION"));
                menu.setCookTime(rs.getInt("COOK_TIME"));
                menu.setFavoriteId(rs.getInt("FAVORITE_ID"));
                list.add(menu);
            }
        }
        return list;
    }
}