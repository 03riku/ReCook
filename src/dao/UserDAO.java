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

/**
 * 【一般ユーザー用データ操作クラス】
 * ログイン、料理の検索、お気に入り登録、店舗情報の表示など、
 * 一般ユーザーがアプリで行う主要な操作をデータベースと連携させます。
 */
public class UserDAO {

    /**
     * データベースへ接続するためのメソッド
     */
    private Connection getConnection() throws Exception {
        Class.forName("org.h2.Driver");
        // Re.Cookという名前のデータベースファイルに接続します
        String url = "jdbc:h2:tcp://localhost/~/Re.Cook";
        String user = "sa";
        String password = "";
        return DriverManager.getConnection(url, user, password);
    }

    // --- 1. ユーザー管理（ログイン・新規登録） ---

    /**
     * ログインチェック：メールとパスワードが一致するユーザーを返します
     */
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
                return user; // 一致する人がいればその情報を返す
            }
        }
        return null; // いなければnullを返す
    }

    /**
     * 新規ユーザー登録：入力された情報をデータベースに保存します
     */
    public boolean registerUser(String email, String password, String name) throws Exception {
        String sql = "INSERT INTO GENERAL_USER (EMAIL, USER_PASSWORD, ACCOUNT_NAME) VALUES (?, ?, ?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, name);
            return ps.executeUpdate() > 0; // 登録できたらtrueを返す
        }
    }

    // --- 2. 料理メニュー（詳細・検索・材料） ---

    /**
     * 料理の詳細を取得：ついでにそのユーザーがお気に入り登録しているかも判別します
     */
    public CookMenu getCookMenuById(int menuItemId, int userId) throws Exception {
        // ジャンル名も一緒に取ってくるSQL
        String sql = "SELECT c.*, g.GENRE_NAME FROM COOK_MENU c " +
                     "LEFT JOIN GENRE g ON c.GENRE_ID = g.GENRE_ID " +
                     "WHERE c.MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs); // 基本情報をセット
                menu.setGenreName(rs.getString("GENRE_NAME"));

                // お気に入り済みかどうかの確認（1:未登録, 2:登録済み）
                String checkSql = "SELECT * FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
                try (PreparedStatement psFav = con.prepareStatement(checkSql)) {
                    psFav.setInt(1, userId);
                    psFav.setInt(2, menuItemId);
                    ResultSet rsFav = psFav.executeQuery();
                    menu.setFavoriteId(rsFav.next() ? 2 : 1);
                }
                return menu;
            }
        }
        return null;
    }

    /**
     * 料理に必要な材料リストを取得します
     */
    public List<Product> getIngredientsByMenuId(int menuItemId) throws Exception {
        List<Product> list = new ArrayList<>();
        // 料理と商品を紐づける中間テーブル(pcm)を結合して名前を取ります
        String sql = "SELECT p.* FROM PRODUCT p " +
                     "JOIN PRODUCT_COOK_MENU pcm ON p.PRODUCT_ID = pcm.PRODUCT_ID " +
                     "WHERE pcm.MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                    rs.getInt("PRODUCT_ID"),
                    rs.getString("PRODUCT_NAME"),
                    rs.getString("CATEGORY")
                );
                list.add(p);
            }
        }
        return list;
    }

    /**
     * 料理検索：料理名、または使われている材料名で検索します（部分一致）
     */
    public List<CookMenu> searchCookMenu(String keyword) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        // DISTINCTを使って同じ料理が重複して出ないようにしています
        String sql = "SELECT DISTINCT c.* FROM COOK_MENU c " +
                     "LEFT JOIN PRODUCT_COOK_MENU pcm ON c.MENU_ITEM_ID = pcm.MENU_ITEM_ID " +
                     "LEFT JOIN PRODUCT p ON pcm.PRODUCT_ID = p.PRODUCT_ID " +
                     "WHERE c.DISH_NAME LIKE ? OR p.PRODUCT_NAME LIKE ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String wild = "%" + (keyword != null ? keyword : "") + "%";
            ps.setString(1, wild); // 料理名で検索
            ps.setString(2, wild); // 材料名で検索
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                list.add(menu);
            }
        }
        return list;
    }

    /**
     * ジャンル（和食など）を指定して料理リストを取得します
     */
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

    /**
     * 特定のスーパー(storeId)が取り扱っている料理メニュー一覧を取得します
     */
    public List<CookMenu> getMenusByStoreId(int storeId) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        // 店舗限定メニューなど、店舗と料理を結びつけるテーブルを使用
        String sql = "SELECT c.* FROM COOK_MENU c " +
                     "JOIN STORE_MENU sm ON c.MENU_ITEM_ID = sm.MENU_ITEM_ID " +
                     "WHERE sm.STORE_ID = ?";
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

    // --- 3. お気に入り管理 ---

    /**
     * お気に入りの切り替え（登録があれば消す、なければ登録する）
     */
    public void toggleFavorite(int userId, int menuItemId) throws Exception {
        String checkSql = "SELECT * FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(checkSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, menuItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // すでに登録されていれば削除（お気に入り解除）
                String delSql = "DELETE FROM FAVORITE_MENU WHERE USER_ID = ? AND MENU_ITEM_ID = ?";
                try (PreparedStatement psDel = con.prepareStatement(delSql)) {
                    psDel.setInt(1, userId);
                    psDel.setInt(2, menuItemId);
                    psDel.executeUpdate();
                }
            } else {
                // 未登録なら挿入（お気に入り登録）
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
     * ユーザーが登録したお気に入り料理リストを取得します
     */
    public List<CookMenu> getFavoriteMenus(int userId) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT c.* FROM COOK_MENU c JOIN FAVORITE_MENU f ON c.MENU_ITEM_ID = f.MENU_ITEM_ID WHERE f.USER_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                fillCookMenu(menu, rs);
                menu.setFavoriteId(2); // お気に入り画面なので全部「登録済み」
                list.add(menu);
            }
        }
        return list;
    }

    // --- 4. 店舗管理 ---

    /**
     * 店舗IDからその店舗の基本情報を取得します
     */
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

    /**
     * 「このクーポンが使えるお店を探す」機能：特定の料理を扱っている全店舗を返します
     */
    public List<User_Store> getStoresByMenuItemId(int menuItemId) throws Exception {
        List<User_Store> list = new ArrayList<>();
        String sql = "SELECT s.* FROM STORE s JOIN STORE_MENU sm ON s.STORE_ID = sm.STORE_ID WHERE sm.MENU_ITEM_ID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
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

    /**
     * 都道府県のリスト（住所の頭3文字）を取得します（検索フィルタ用）
     */
    public List<String> getPrefectures() throws Exception {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT SUBSTRING(STORE_ADDRESS, 1, 3) AS PREF FROM STORE";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(rs.getString("PREF")); }
        }
        return list;
    }

    /**
     * 店舗検索：店名または住所で絞り込みます
     */
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

    // --- 共通ヘルパーメソッド ---

    /**
     * DBから取得した1行のデータをCookMenuオブジェクトに詰め込むための共通処理
     */
    private void fillCookMenu(CookMenu menu, ResultSet rs) throws Exception {
        menu.setMenuItemId(rs.getInt("MENU_ITEM_ID"));
        menu.setDishName(rs.getString("DISH_NAME"));
        menu.setDescription(rs.getString("DESCRIPTION"));
        menu.setCookTime(rs.getInt("COOK_TIME"));
        menu.setGenreId(rs.getInt("GENRE_ID"));
        // データベースに登録されている画像ファイル名（omuraisu.pngなど）を取得
        menu.setImage(rs.getString("IMAGE"));
    }
}