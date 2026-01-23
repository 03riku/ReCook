package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import bean.Admin;
import bean.CookMenu;
import bean.Genre;
import bean.Product;
import bean.Store;

/**
 * 【管理者用データ操作クラス】
 * 管理者のログイン、商品の管理、店舗の管理、レシピの管理など、
 * システム全体のデータを管理・操作するためのメソッドがまとめられています。
 */
public class AdminDAO extends DAO {

    // ==========================================
    // セクション 1: 管理者ログイン
    // ==========================================

    /** 管理者IDとパスワードでログインチェックを行う */
    public Admin findAdmin(int adminId, String adminPass) {
        Admin admin = null;
        String sql = "SELECT * FROM admin WHERE admin_id = ? AND admin_pass = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setString(2, adminPass.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setAdminPass(rs.getString("admin_pass"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return admin;
    }

    // ==========================================
    // セクション 2: 商品管理（材料マスタなど）
    // ==========================================

    /** 登録されている全商品をリストで取得する */
    public List<Product> getAllProducts() throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT product_id, product_name, category FROM product ORDER BY product_id DESC";
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(new Product(rs.getInt("product_id"), rs.getString("product_name"), rs.getString("category")));
        }
        return list;
    }

    /** 名前の一部から商品を検索する */
    public List<Product> searchProducts(String name) throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT product_id, product_name, category FROM product WHERE product_name LIKE ? ORDER BY product_id DESC";
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, "%" + name + "%");
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(new Product(rs.getInt("product_id"), rs.getString("product_name"), rs.getString("category")));
            }
        }
        return list;
    }

    /** 商品名の重複チェック（自分以外のIDで同じ名前があるか） */
    public boolean isProductNameExists(String name, int excludeId) throws Exception {
        String sql = "SELECT COUNT(*) FROM product WHERE product_name = ? AND product_id != ?";
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, name);
            st.setInt(2, excludeId);
            try (ResultSet rs = st.executeQuery()) { if (rs.next()) return rs.getInt(1) > 0; }
        }
        return false;
    }

    /** 商品の「新規保存」または「更新」を自動で判別して実行する */
    public void saveOrUpdate(Product p) throws Exception {
        try (Connection con = getConnection()) {
            boolean exists = false;
            if (p.getProductId() > 0) {
                try (PreparedStatement pst = con.prepareStatement("SELECT COUNT(*) FROM product WHERE product_id = ?")) {
                    pst.setInt(1, p.getProductId());
                    try (ResultSet rs = pst.executeQuery()) { if (rs.next() && rs.getInt(1) > 0) exists = true; }
                }
            }
            if (exists) {
                // すでにあれば情報を新しく書き換える
                try (PreparedStatement pst = con.prepareStatement("UPDATE product SET product_name = ?, category = ? WHERE product_id = ?")) {
                    pst.setString(1, p.getProductName()); pst.setString(2, p.getCategory()); pst.setInt(3, p.getProductId()); pst.executeUpdate();
                }
            } else {
                // なければ新しく登録する
                try (PreparedStatement pst = con.prepareStatement("INSERT INTO product (product_name, category) VALUES (?, ?)")) {
                    pst.setString(1, p.getProductName()); pst.setString(2, p.getCategory()); pst.executeUpdate();
                }
            }
        }
    }

    /** * 複数の商品をまとめて一括削除する
     * (修正済み: 外部キー制約エラーを防ぐため、子テーブルから先に削除します)
     */
    public void bulkDelete(String[] ids) throws Exception {
        if (ids == null || ids.length == 0) return;

        Connection con = null;
        try {
            con = getConnection();
            // トランザクション開始
            con.setAutoCommit(false);

            // IDリストのプレースホルダを作成 (?,?,?)
            StringBuilder idStr = new StringBuilder();
            for (int i = 0; i < ids.length; i++) {
                idStr.append(i == 0 ? "?" : ",?");
            }
            String params = "(" + idStr.toString() + ")";

            // 1. 先に関連する子テーブル (product_cook_menu) から削除する
            String sqlChild = "DELETE FROM product_cook_menu WHERE product_id IN " + params;
            try (PreparedStatement st = con.prepareStatement(sqlChild)) {
                for (int i = 0; i < ids.length; i++) {
                    st.setInt(i + 1, Integer.parseInt(ids[i]));
                }
                st.executeUpdate();
            }

            //

            // 2. その後、親テーブル (product) を削除する
            String sqlParent = "DELETE FROM product WHERE product_id IN " + params;
            try (PreparedStatement st = con.prepareStatement(sqlParent)) {
                for (int i = 0; i < ids.length; i++) {
                    st.setInt(i + 1, Integer.parseInt(ids[i]));
                }
                st.executeUpdate();
            }

            // コミット (確定)
            con.commit();

        } catch (Exception e) {
            // エラーが発生したらロールバック
            if (con != null) con.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    /** 登録されている全カテゴリー名を重複なしで取得する */
    public List<String> getAllCategories() throws Exception {
        List<String> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("SELECT DISTINCT category FROM product WHERE category IS NOT NULL AND category != '' ORDER BY category"); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(rs.getString("category"));
        }
        return list;
    }

    // ==========================================
    // セクション 3: 店舗管理
    // ==========================================

    /** 全店舗のリストを取得する */
    public List<Store> selectAll() throws Exception {
        List<Store> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("SELECT * FROM store ORDER BY store_id ASC"); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(new Store(rs.getLong("store_id"), rs.getString("store_name"), rs.getString("store_password"), rs.getString("store_address")));
        }
        return list;
    }

    /** 指定したIDの店舗情報を1件取得する */
    public Store selectById(long id) throws Exception {
        Store store = null;
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("SELECT * FROM store WHERE store_id = ?")) {
            st.setLong(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) store = new Store(rs.getLong("store_id"), rs.getString("store_name"), rs.getString("store_password"), rs.getString("store_address"));
            }
        }
        return store;
    }

    /** 店舗IDがすでに使われているかチェックする */
    public boolean isIdExists(long id) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("SELECT COUNT(*) FROM store WHERE store_id = ?")) {
            st.setLong(1, id);
            try (ResultSet rs = st.executeQuery()) { return rs.next() && rs.getInt(1) > 0; }
        }
    }

    /** 新しい店舗を登録する */
    public int insert(Store s) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("INSERT INTO store VALUES (?, ?, ?, ?)")) {
            st.setLong(1, s.getStoreId()); st.setString(2, s.getStoreName()); st.setString(3, s.getStorePassword()); st.setString(4, s.getStoreAddress());
            return st.executeUpdate();
        }
    }

    /** 店舗情報を更新する（IDが変更された場合にも対応） */
    public int update(Store s, long oldId) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("UPDATE store SET store_id=?, store_name=?, store_password=?, store_address=? WHERE store_id=?")) {
            st.setLong(1, s.getStoreId()); st.setString(2, s.getStoreName()); st.setString(3, s.getStorePassword()); st.setString(4, s.getStoreAddress()); st.setLong(5, oldId);
            return st.executeUpdate();
        }
    }

    /** 店舗を削除する */
    public int delete(long id) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("DELETE FROM store WHERE store_id=?")) {
            st.setLong(1, id);
            return st.executeUpdate();
        }
    }

    // ==========================================
    // セクション 4: レシピ（料理メニュー）管理
    // ==========================================

    /** レシピに設定できる全ジャンルのリストを取得する */
    public List<Genre> getAllGenresForRecipe() throws Exception {
        List<Genre> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("SELECT * FROM genre ORDER BY genre_id"); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Genre g = new Genre();
                g.setGenreId(rs.getInt("genre_id"));
                g.setGenreName(rs.getString("genre_name"));
                list.add(g);
            }
        }
        return list;
    }

    /** 画像やジャンル名も含めた全レシピの情報を取得する（検索機能付き） */
    public List<CookMenu> getAllRecipesFull(String searchKeyword) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT c.*, g.genre_name FROM cook_menu c ");
        sql.append("LEFT JOIN genre g ON c.genre_id = g.genre_id ");
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            sql.append("WHERE c.dish_name LIKE ? ");
        }
        sql.append("ORDER BY c.menu_item_id DESC");

        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql.toString())) {
            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                st.setString(1, "%" + searchKeyword + "%");
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    CookMenu m = new CookMenu();
                    m.setMenuItemId(rs.getInt("menu_item_id"));
                    m.setDishName(rs.getString("dish_name"));
                    m.setCookTime(rs.getInt("cook_time"));
                    m.setDescription(rs.getString("description"));
                    m.setGenreId(rs.getInt("genre_id"));
                    m.setGenreName(rs.getString("genre_name"));
                    // 画像ファイル名を取得
                    try { m.setImage(rs.getString("image")); } catch (Exception e) { m.setImage(""); }

                    // このレシピに紐づく材料（Product）も取得してセット
                    m.setProductList(getProductsByMenuId(con, m.getMenuItemId()));
                    list.add(m);
                }
            }
        }
        return list;
    }

    /** 特定のレシピで使われている材料のリストを取得する（内部用） */
    private List<Product> getProductsByMenuId(Connection con, int menuId) throws Exception {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name FROM product p " +
                     "JOIN product_cook_menu pcm ON p.product_id = pcm.product_id " +
                     "WHERE pcm.menu_item_id = ?";
        try (PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, menuId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));
                    products.add(p);
                }
            }
        }
        return products;
    }

    /**
     * レシピの保存・更新処理（トランザクション）
     * レシピ本体、ジャンル、使用する材料との紐付けを「まとめて」保存します。
     */
    public void saveRecipeTransaction(CookMenu menu, String genreName, List<String> productNames) throws Exception {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false); // まとめて更新するため、自動確定をOFFにする

            // 1. ジャンル名からジャンルIDを探す
            int genreId = 0;
            try (PreparedStatement st = con.prepareStatement("SELECT genre_id FROM genre WHERE genre_name = ?")) {
                st.setString(1, genreName);
                try (ResultSet rs = st.executeQuery()) { if (rs.next()) genreId = rs.getInt("genre_id"); }
            }
            if (genreId != 0) menu.setGenreId(genreId);

            // 2. レシピ情報の追加または更新
            int menuId = menu.getMenuItemId();
            if (menuId > 0) {
                // 更新（画像が選ばれていれば画像も更新）
                String sql;
                boolean updateImage = (menu.getImage() != null && !menu.getImage().isEmpty());
                if (updateImage) {
                    sql = "UPDATE cook_menu SET dish_name=?, cook_time=?, description=?, genre_id=?, image=? WHERE menu_item_id=?";
                } else {
                    sql = "UPDATE cook_menu SET dish_name=?, cook_time=?, description=?, genre_id=? WHERE menu_item_id=?";
                }
                try (PreparedStatement st = con.prepareStatement(sql)) {
                    st.setString(1, menu.getDishName());
                    st.setInt(2, menu.getCookTime());
                    st.setString(3, menu.getDescription());
                    st.setInt(4, menu.getGenreId());
                    if (updateImage) {
                        st.setString(5, menu.getImage()); st.setInt(6, menuId);
                    } else {
                        st.setInt(5, menuId);
                    }
                    st.executeUpdate();
                }
            } else {
                // 新規登録
                String sql = "INSERT INTO cook_menu (dish_name, cook_time, description, genre_id, image) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement st = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    st.setString(1, menu.getDishName());
                    st.setInt(2, menu.getCookTime());
                    st.setString(3, menu.getDescription());
                    st.setInt(4, menu.getGenreId());
                    st.setString(5, menu.getImage());
                    st.executeUpdate();
                    try (ResultSet rs = st.getGeneratedKeys()) { if (rs.next()) menuId = rs.getInt(1); }
                }
            }

            // 3. レシピと材料の紐付け（一度消してから作り直す）
            if (menu.getMenuItemId() > 0) {
                try (PreparedStatement st = con.prepareStatement("DELETE FROM product_cook_menu WHERE menu_item_id = ?")) {
                    st.setInt(1, menuId); st.executeUpdate();
                }
            }
            if (productNames != null && !productNames.isEmpty()) {
                String findSql = "SELECT product_id FROM product WHERE product_name = ?";
                String insertRel = "INSERT INTO product_cook_menu (menu_item_id, product_id) VALUES (?, ?)";
                try (PreparedStatement fSt = con.prepareStatement(findSql);
                     PreparedStatement iSt = con.prepareStatement(insertRel)) {
                    for (String pName : productNames) {
                        if (pName == null || pName.trim().isEmpty()) continue;
                        fSt.setString(1, pName.trim());
                        int prodId = -1;
                        try (ResultSet rs = fSt.executeQuery()) { if (rs.next()) prodId = rs.getInt("product_id"); }
                        if (prodId != -1) {
                            iSt.setInt(1, menuId); iSt.setInt(2, prodId); iSt.executeUpdate();
                        }
                    }
                }
            }
            con.commit(); // すべて成功したら確定
        } catch (Exception e) {
            if (con != null) con.rollback(); // 一つでも失敗したら元に戻す
            throw e;
        } finally {
            if (con != null) { con.setAutoCommit(true); con.close(); }
        }
    }

    /**
     * レシピを削除する
     * 関連するお気に入り設定や店舗メニュー設定なども安全に消去します。
     */
    public void deleteRecipes(String[] ids) throws Exception {
        if (ids == null || ids.length == 0) return;
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);
            StringBuilder idStr = new StringBuilder();
            for(int i=0; i<ids.length; i++) idStr.append(i==0 ? "?" : ",?");
            String params = "(" + idStr.toString() + ")";

            // 子テーブル（関連データ）から先に消す
            String[] tables = {"product_cook_menu", "store_menu", "favorite_menu"};
            for(String tb : tables) {
                try(PreparedStatement st = con.prepareStatement("DELETE FROM " + tb + " WHERE menu_item_id IN " + params)) {
                    for(int i=0; i<ids.length; i++) st.setInt(i+1, Integer.parseInt(ids[i]));
                    st.executeUpdate();
                }
            }
            // クーポンとの紐付けを解除
            try(PreparedStatement st = con.prepareStatement("UPDATE coupon SET menu_item_id = NULL WHERE menu_item_id IN " + params)) {
                 for(int i=0; i<ids.length; i++) st.setInt(i+1, Integer.parseInt(ids[i]));
                 st.executeUpdate();
            }
            // 親テーブル（レシピ本体）を最後に消す
            try(PreparedStatement st = con.prepareStatement("DELETE FROM cook_menu WHERE menu_item_id IN " + params)) {
                 for(int i=0; i<ids.length; i++) st.setInt(i+1, Integer.parseInt(ids[i]));
                 st.executeUpdate();
            }
            con.commit();
        } catch (Exception e) {
            if(con != null) con.rollback();
            throw e;
        } finally {
            if(con != null) { con.setAutoCommit(true); con.close(); }
        }
    }
}