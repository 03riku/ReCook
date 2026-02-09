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
 * 【管理者用データアクセスオブジェクト (DAO)】
 * 管理者ログイン、商品管理、店舗管理、レシピ管理など、
 * システム全体のデータベース操作を集約したクラスです。
 */
public class AdminDAO extends DAO {

    // ==========================================
    // セクション 1: 管理者ログイン
    // ==========================================

    /**
     * 管理者IDとパスワードでログイン認証を行います。
     * @param adminId 管理者ID
     * @param adminPass パスワード
     * @return 認証成功ならAdminオブジェクト、失敗ならnull
     */
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
    // セクション 2: 商品管理（材料マスタ）
    // ==========================================

    /**
     * 登録されている全商品の一覧を取得します。
     */
    public List<Product> getAllProducts() throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT product_id, product_name, category FROM product ORDER BY product_id DESC";
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(new Product(rs.getInt("product_id"), rs.getString("product_name"), rs.getString("category")));
        }
        return list;
    }

    /**
     * 商品名で部分一致検索を行います。
     */
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

    /**
     * 商品名の重複チェックを行います。
     * 更新時は、自分自身のIDを除外してチェックします。
     */
    public boolean isProductNameExists(String name, int excludeId) throws Exception {
        String sql = "SELECT COUNT(*) FROM product WHERE product_name = ? AND product_id != ?";
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, name);
            st.setInt(2, excludeId);
            try (ResultSet rs = st.executeQuery()) { if (rs.next()) return rs.getInt(1) > 0; }
        }
        return false;
    }

    /**
     * 商品の「新規登録」または「更新」をIDの有無で自動判別して実行します。
     */
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
                // 更新処理
                try (PreparedStatement pst = con.prepareStatement("UPDATE product SET product_name = ?, category = ? WHERE product_id = ?")) {
                    pst.setString(1, p.getProductName()); pst.setString(2, p.getCategory()); pst.setInt(3, p.getProductId()); pst.executeUpdate();
                }
            } else {
                // 新規登録処理
                try (PreparedStatement pst = con.prepareStatement("INSERT INTO product (product_name, category) VALUES (?, ?)")) {
                    pst.setString(1, p.getProductName()); pst.setString(2, p.getCategory()); pst.executeUpdate();
                }
            }
        }
    }

    /**
     * 複数の商品を一括削除します。
     * 外部キー制約エラーを防ぐため、子テーブル(product_cook_menu)から順に削除します。
     */
    public void bulkDelete(String[] ids) throws Exception {
        if (ids == null || ids.length == 0) return;
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false); // トランザクション開始
            StringBuilder idStr = new StringBuilder();
            for (int i = 0; i < ids.length; i++) idStr.append(i == 0 ? "?" : ",?");
            String params = "(" + idStr.toString() + ")";

            // 1. レシピとの関連付け (product_cook_menu) を削除
            String sqlChild = "DELETE FROM product_cook_menu WHERE product_id IN " + params;
            try (PreparedStatement st = con.prepareStatement(sqlChild)) {
                for (int i = 0; i < ids.length; i++) st.setInt(i + 1, Integer.parseInt(ids[i]));
                st.executeUpdate();
            }

            // 2. 商品マスタ (product) から削除
            String sqlParent = "DELETE FROM product WHERE product_id IN " + params;
            try (PreparedStatement st = con.prepareStatement(sqlParent)) {
                for (int i = 0; i < ids.length; i++) st.setInt(i + 1, Integer.parseInt(ids[i]));
                st.executeUpdate();
            }
            con.commit(); // コミット
        } catch (Exception e) {
            if (con != null) con.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            if (con != null) { con.setAutoCommit(true); con.close(); }
        }
    }

    /**
     * 重複なしで全カテゴリー名を取得します。
     */
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

    /**
     * 全店舗の一覧を取得します。
     */
    public List<Store> selectAll() throws Exception {
        List<Store> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("SELECT * FROM store ORDER BY store_id ASC"); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(new Store(rs.getLong("store_id"), rs.getString("store_name"), rs.getString("store_password"), rs.getString("store_address")));
        }
        return list;
    }

    /**
     * 店舗名で部分一致検索を行います。
     */
    public List<Store> searchStores(String keyword) throws Exception {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT * FROM store WHERE store_name LIKE ? ORDER BY store_id ASC";
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, "%" + keyword + "%");
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(new Store(rs.getLong("store_id"), rs.getString("store_name"), rs.getString("store_password"), rs.getString("store_address")));
            }
        }
        return list;
    }

    /**
     * 店舗IDで店舗情報を検索します。
     */
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

    /**
     * 店舗IDが既に使用されているかチェックします。
     */
    public boolean isIdExists(long id) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("SELECT COUNT(*) FROM store WHERE store_id = ?")) {
            st.setLong(1, id);
            try (ResultSet rs = st.executeQuery()) { return rs.next() && rs.getInt(1) > 0; }
        }
    }

    /**
     * 新規店舗を登録します。
     */
    public int insert(Store s) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("INSERT INTO store VALUES (?, ?, ?, ?)")) {
            st.setLong(1, s.getStoreId()); st.setString(2, s.getStoreName()); st.setString(3, s.getStorePassword()); st.setString(4, s.getStoreAddress());
            return st.executeUpdate();
        }
    }

    /**
     * 店舗情報を更新します（店舗IDの変更にも対応）。
     */
    public int update(Store s, long oldId) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("UPDATE store SET store_id=?, store_name=?, store_password=?, store_address=? WHERE store_id=?")) {
            st.setLong(1, s.getStoreId()); st.setString(2, s.getStoreName()); st.setString(3, s.getStorePassword()); st.setString(4, s.getStoreAddress()); st.setLong(5, oldId);
            return st.executeUpdate();
        }
    }

    /**
     * 店舗を削除します。
     * 外部キー制約 (FK) を回避するため、関連する子テーブルのデータをすべて削除してから
     * 親テーブル(store)を削除するトランザクション処理を行います。
     */
    public void delete(long id) throws Exception {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false); // トランザクション開始

            // 1. 店舗の商品リスト (store_product) を削除
            try (PreparedStatement st = con.prepareStatement("DELETE FROM store_product WHERE store_id=?")) {
                st.setLong(1, id); st.executeUpdate();
            }

            // 2. 店舗のメニュー設定 (store_menu) を削除
            try (PreparedStatement st = con.prepareStatement("DELETE FROM store_menu WHERE store_id=?")) {
                st.setLong(1, id); st.executeUpdate();
            }

            // 3. 発行したクーポン (coupon) を削除
            try (PreparedStatement st = con.prepareStatement("DELETE FROM coupon WHERE store_id=?")) {
                st.setLong(1, id); st.executeUpdate();
            }

            // 4. 値引き商品設定 (discounted_product) を削除
            try (PreparedStatement st = con.prepareStatement("DELETE FROM discounted_product WHERE store_id=?")) {
                st.setLong(1, id); st.executeUpdate();
            }

            // 5. 最後に店舗本体 (store) を削除
            try (PreparedStatement st = con.prepareStatement("DELETE FROM store WHERE store_id=?")) {
                st.setLong(1, id);
                int count = st.executeUpdate();
                if (count == 0) throw new Exception("削除対象の店舗が見つかりませんでした。");
            }

            con.commit(); // コミット (確定)

        } catch (Exception e) {
            if (con != null) con.rollback(); // 失敗したら元に戻す
            e.printStackTrace();
            throw e;
        } finally {
            if (con != null) { con.setAutoCommit(true); con.close(); }
        }
    }

    // ==========================================
    // セクション 4: レシピ（料理メニュー）管理
    // ==========================================

    /**
     * レシピ用ジャンル一覧を取得します。
     */
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

    /**
     * 全レシピの詳細情報を取得します（検索機能付き）。
     * ジャンル名や画像情報、使用食材リストも結合して取得します。
     */
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
                    try { m.setImage(rs.getString("image")); } catch (Exception e) { m.setImage(""); }
                    m.setProductList(getProductsByMenuId(con, m.getMenuItemId()));
                    list.add(m);
                }
            }
        }
        return list;
    }

    /**
     * 指定したレシピIDで使用されている材料リストを取得します（内部利用用）。
     */
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
     * レシピの保存・更新処理をトランザクション内で行います。
     * レシピ本体、ジャンルIDの取得、使用する材料との紐付けを一括処理します。
     */
    public void saveRecipeTransaction(CookMenu menu, String genreName, List<String> productNames) throws Exception {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false); // トランザクション開始

            // 1. ジャンル名からジャンルIDを取得（なければ0）
            int genreId = 0;
            try (PreparedStatement st = con.prepareStatement("SELECT genre_id FROM genre WHERE genre_name = ?")) {
                st.setString(1, genreName);
                try (ResultSet rs = st.executeQuery()) { if (rs.next()) genreId = rs.getInt("genre_id"); }
            }
            if (genreId != 0) menu.setGenreId(genreId);

            int menuId = menu.getMenuItemId();
            if (menuId > 0) {
                // 更新処理
                String sql;
                boolean updateImage = (menu.getImage() != null && !menu.getImage().isEmpty());
                if (updateImage) {
                    sql = "UPDATE cook_menu SET dish_name=?, cook_time=?, description=?, genre_id=?, image=? WHERE menu_item_id=?";
                } else {
                    sql = "UPDATE cook_menu SET dish_name=?, cook_time=?, description=?, genre_id=? WHERE menu_item_id=?";
                }
                try (PreparedStatement st = con.prepareStatement(sql)) {
                    st.setString(1, menu.getDishName()); st.setInt(2, menu.getCookTime()); st.setString(3, menu.getDescription()); st.setInt(4, menu.getGenreId());
                    if (updateImage) { st.setString(5, menu.getImage()); st.setInt(6, menuId); } else { st.setInt(5, menuId); }
                    st.executeUpdate();
                }
            } else {
                // 新規登録処理
                String sql = "INSERT INTO cook_menu (dish_name, cook_time, description, genre_id, image) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement st = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    st.setString(1, menu.getDishName()); st.setInt(2, menu.getCookTime()); st.setString(3, menu.getDescription()); st.setInt(4, menu.getGenreId()); st.setString(5, menu.getImage());
                    st.executeUpdate();
                    try (ResultSet rs = st.getGeneratedKeys()) { if (rs.next()) menuId = rs.getInt(1); }
                }
            }

            // 2. 材料との紐付け（一度削除してから再登録）
            if (menu.getMenuItemId() > 0) {
                try (PreparedStatement st = con.prepareStatement("DELETE FROM product_cook_menu WHERE menu_item_id = ?")) {
                    st.setInt(1, menuId); st.executeUpdate();
                }
            }
            if (productNames != null && !productNames.isEmpty()) {
                String findSql = "SELECT product_id FROM product WHERE product_name = ?";
                String insertRel = "INSERT INTO product_cook_menu (menu_item_id, product_id) VALUES (?, ?)";
                try (PreparedStatement fSt = con.prepareStatement(findSql); PreparedStatement iSt = con.prepareStatement(insertRel)) {
                    for (String pName : productNames) {
                        if (pName == null || pName.trim().isEmpty()) continue;
                        fSt.setString(1, pName.trim());
                        int prodId = -1;
                        try (ResultSet rs = fSt.executeQuery()) { if (rs.next()) prodId = rs.getInt("product_id"); }
                        if (prodId != -1) { iSt.setInt(1, menuId); iSt.setInt(2, prodId); iSt.executeUpdate(); }
                    }
                }
            }
            con.commit(); // コミット
        } catch (Exception e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (con != null) { con.setAutoCommit(true); con.close(); }
        }
    }

    /**
     * レシピを一括削除します。
     * 関連するお気に入り、店舗メニュー、クーポンなどの紐付けも安全に処理します。
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

            // 1. 関連テーブルからの削除
            String[] tables = {"product_cook_menu", "store_menu", "favorite_menu"};
            for(String tb : tables) {
                try(PreparedStatement st = con.prepareStatement("DELETE FROM " + tb + " WHERE menu_item_id IN " + params)) {
                    for(int i=0; i<ids.length; i++) st.setInt(i+1, Integer.parseInt(ids[i]));
                    st.executeUpdate();
                }
            }
            // 2. クーポンとの紐付けを解除 (NULL更新)
            try(PreparedStatement st = con.prepareStatement("UPDATE coupon SET menu_item_id = NULL WHERE menu_item_id IN " + params)) {
                 for(int i=0; i<ids.length; i++) st.setInt(i+1, Integer.parseInt(ids[i]));
                 st.executeUpdate();
            }
            // 3. レシピ本体の削除
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