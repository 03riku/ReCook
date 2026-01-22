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

public class AdminDAO extends DAO {

    // ==========================================
    // パート1: 管理者ログイン (ADMIN LOGIN)
    // ==========================================
    public Admin findAdmin(int adminId, String adminPass) {
        Admin admin = null;
        // IDとパスワードが一致する管理者を検索
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
    // パート2: 商品管理 (PRODUCT MANAGEMENT)
    // ==========================================

    // 全商品を取得
    public List<Product> getAllProducts() throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT product_id, product_name, category FROM product ORDER BY product_id DESC";
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(new Product(rs.getInt("product_id"), rs.getString("product_name"), rs.getString("category")));
        }
        return list;
    }

    // 商品名での検索（部分一致）
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

    // 商品名の重複チェック（編集時は自分自身を除外）
    public boolean isProductNameExists(String name, int excludeId) throws Exception {
        String sql = "SELECT COUNT(*) FROM product WHERE product_name = ? AND product_id != ?";
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, name);
            st.setInt(2, excludeId);
            try (ResultSet rs = st.executeQuery()) { if (rs.next()) return rs.getInt(1) > 0; }
        }
        return false;
    }

    // 商品の追加または更新
    public void saveOrUpdate(Product p) throws Exception {
        try (Connection con = getConnection()) {
            boolean exists = false;
            // IDが存在するかチェック
            if (p.getProductId() > 0) {
                try (PreparedStatement pst = con.prepareStatement("SELECT COUNT(*) FROM product WHERE product_id = ?")) {
                    pst.setInt(1, p.getProductId());
                    try (ResultSet rs = pst.executeQuery()) { if (rs.next() && rs.getInt(1) > 0) exists = true; }
                }
            }

            if (exists) {
                // 更新処理 (Update)
                try (PreparedStatement pst = con.prepareStatement("UPDATE product SET product_name = ?, category = ? WHERE product_id = ?")) {
                    pst.setString(1, p.getProductName()); pst.setString(2, p.getCategory()); pst.setInt(3, p.getProductId()); pst.executeUpdate();
                }
            } else {
                // 新規追加処理 (Insert)
                try (PreparedStatement pst = con.prepareStatement("INSERT INTO product (product_name, category) VALUES (?, ?)")) {
                    pst.setString(1, p.getProductName()); pst.setString(2, p.getCategory()); pst.executeUpdate();
                }
            }
        }
    }

    // 商品の一括削除
    public void bulkDelete(String[] ids) throws Exception {
        if (ids == null || ids.length == 0) return;
        StringBuilder sql = new StringBuilder("DELETE FROM product WHERE product_id IN (");
        for (int i = 0; i < ids.length; i++) sql.append(i == 0 ? "?" : ",?");
        sql.append(")");
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.length; i++) st.setInt(i + 1, Integer.parseInt(ids[i]));
            st.executeUpdate();
        }
    }

    // カテゴリ一覧の取得（ドロップダウン用）
    public List<String> getAllCategories() throws Exception {
        List<String> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("SELECT DISTINCT category FROM product WHERE category IS NOT NULL AND category != '' ORDER BY category"); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(rs.getString("category"));
        }
        return list;
    }

    // ==========================================
    // パート3: 店舗管理 (STORE MANAGEMENT)
    // ==========================================

    // 全店舗取得
    public List<Store> selectAll() throws Exception {
        List<Store> list = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("SELECT * FROM store ORDER BY store_id ASC"); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(new Store(rs.getLong("store_id"), rs.getString("store_name"), rs.getString("store_password"), rs.getString("store_address")));
        }
        return list;
    }

    // IDで店舗を取得
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

    // 店舗IDの重複チェック
    public boolean isIdExists(long id) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("SELECT COUNT(*) FROM store WHERE store_id = ?")) {
            st.setLong(1, id);
            try (ResultSet rs = st.executeQuery()) { return rs.next() && rs.getInt(1) > 0; }
        }
    }

    // 店舗追加
    public int insert(Store s) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("INSERT INTO store VALUES (?, ?, ?, ?)")) {
            st.setLong(1, s.getStoreId()); st.setString(2, s.getStoreName()); st.setString(3, s.getStorePassword()); st.setString(4, s.getStoreAddress());
            return st.executeUpdate();
        }
    }

    // 店舗更新
    public int update(Store s, long oldId) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("UPDATE store SET store_id=?, store_name=?, store_password=?, store_address=? WHERE store_id=?")) {
            st.setLong(1, s.getStoreId()); st.setString(2, s.getStoreName()); st.setString(3, s.getStorePassword()); st.setString(4, s.getStoreAddress()); st.setLong(5, oldId);
            return st.executeUpdate();
        }
    }

    // 店舗削除
    public int delete(long id) throws Exception {
        try (Connection con = getConnection(); PreparedStatement st = con.prepareStatement("DELETE FROM store WHERE store_id=?")) {
            st.setLong(1, id);
            return st.executeUpdate();
        }
    }

    // ==========================================
    // パート4: 料理管理 (RECIPE MANAGEMENT)
    // ==========================================

    // 料理ジャンル一覧を取得
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

    // 料理の全データを取得 (画像、ジャンル、使用食材を含む)
    public List<CookMenu> getAllRecipesFull(String searchKeyword) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        // cook_menuテーブルとgenreテーブルを結合
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

                    // --- DBから画像ファイル名を取得 ---
                    try {
                        m.setImage(rs.getString("image"));
                    } catch (java.sql.SQLException e) {
                        // カラムが存在しない場合のエラーハンドリング
                        m.setImage("");
                    }

                    // 使用食材リストを取得してセット
                    m.setProductList(getProductsByMenuId(con, m.getMenuItemId()));
                    list.add(m);
                }
            }
        }
        return list;
    }

    // 特定の料理IDに関連する食材(Product)リストを取得
    private List<Product> getProductsByMenuId(Connection con, int menuId) throws Exception {
        List<Product> products = new ArrayList<>();
        // 中間テーブル product_cook_menu を使用して結合
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

    // 料理の保存・更新（トランザクション処理）
    // Genre検索、料理情報の保存、画像更新、使用食材の紐付けを一括で行う
    public void saveRecipeTransaction(CookMenu menu, String genreName, List<String> productNames) throws Exception {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false); // トランザクション開始

            // A. ジャンル名からIDを取得
            int genreId = 0;
            try (PreparedStatement st = con.prepareStatement("SELECT genre_id FROM genre WHERE genre_name = ?")) {
                st.setString(1, genreName);
                try (ResultSet rs = st.executeQuery()) {
                    if (rs.next()) genreId = rs.getInt("genre_id");
                }
            }
            if (genreId != 0) menu.setGenreId(genreId);

            // B. CookMenuの Insert または Update
            int menuId = menu.getMenuItemId();
            if (menuId > 0) {
                // === 更新 (UPDATE) ===
                // 画像ファイルが選択されている場合のみ画像カラムを更新する
                // 選択されていない場合は、元の画像を維持する
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
                        st.setString(5, menu.getImage());
                        st.setInt(6, menuId);
                    } else {
                        st.setInt(5, menuId);
                    }
                    st.executeUpdate();
                }
            } else {
                // === 新規追加 (INSERT) ===
                // 常に画像カラムを含める（未選択ならnull可）
                String sql = "INSERT INTO cook_menu (dish_name, cook_time, description, genre_id, image) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement st = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    st.setString(1, menu.getDishName());
                    st.setInt(2, menu.getCookTime());
                    st.setString(3, menu.getDescription());
                    st.setInt(4, menu.getGenreId());
                    st.setString(5, menu.getImage());
                    st.executeUpdate();
                    // 自動生成されたIDを取得
                    try (ResultSet rs = st.getGeneratedKeys()) {
                        if (rs.next()) menuId = rs.getInt(1);
                    }
                }
            }

            // C. 使用食材（タグ）の保存処理
            // まず既存の関連付けを削除
            if (menu.getMenuItemId() > 0) {
                try (PreparedStatement st = con.prepareStatement("DELETE FROM product_cook_menu WHERE menu_item_id = ?")) {
                    st.setInt(1, menuId);
                    st.executeUpdate();
                }
            }
            // 新しい食材リストを登録
            if (productNames != null && !productNames.isEmpty()) {
                String findSql = "SELECT product_id FROM product WHERE product_name = ?";
                String insertRel = "INSERT INTO product_cook_menu (menu_item_id, product_id) VALUES (?, ?)";
                try (PreparedStatement fSt = con.prepareStatement(findSql);
                     PreparedStatement iSt = con.prepareStatement(insertRel)) {

                    for (String pName : productNames) {
                        if (pName == null || pName.trim().isEmpty()) continue;
                        fSt.setString(1, pName.trim());
                        int prodId = -1;
                        try (ResultSet rs = fSt.executeQuery()) {
                            if (rs.next()) prodId = rs.getInt("product_id");
                        }
                        if (prodId != -1) {
                            iSt.setInt(1, menuId);
                            iSt.setInt(2, prodId);
                            iSt.executeUpdate();
                        }
                    }
                }
            }
            con.commit(); // コミット
        } catch (Exception e) {
            if (con != null) con.rollback(); // エラー時はロールバック
            throw e;
        } finally {
            if (con != null) { con.setAutoCommit(true); con.close(); }
        }
    }

    // 料理の一括削除（関連テーブル含む）
    public void deleteRecipes(String[] ids) throws Exception {
        if (ids == null || ids.length == 0) return;
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false); // トランザクション開始

            StringBuilder idStr = new StringBuilder();
            for(int i=0; i<ids.length; i++) idStr.append(i==0 ? "?" : ",?");
            String params = "(" + idStr.toString() + ")";

            // 1. 外部キー制約のある関連テーブルから先に削除
            String[] tables = {"product_cook_menu", "store_menu", "favorite_menu"};
            for(String tb : tables) {
                try(PreparedStatement st = con.prepareStatement("DELETE FROM " + tb + " WHERE menu_item_id IN " + params)) {
                    for(int i=0; i<ids.length; i++) st.setInt(i+1, Integer.parseInt(ids[i]));
                    st.executeUpdate();
                }
            }
            // 2. クーポンテーブルの参照をNULLに更新
            try(PreparedStatement st = con.prepareStatement("UPDATE coupon SET menu_item_id = NULL WHERE menu_item_id IN " + params)) {
                 for(int i=0; i<ids.length; i++) st.setInt(i+1, Integer.parseInt(ids[i]));
                 st.executeUpdate();
            }
            // 3. メインの料理テーブルから削除
            try(PreparedStatement st = con.prepareStatement("DELETE FROM cook_menu WHERE menu_item_id IN " + params)) {
                 for(int i=0; i<ids.length; i++) st.setInt(i+1, Integer.parseInt(ids[i]));
                 st.executeUpdate();
            }
            con.commit(); // コミット
        } catch (Exception e) {
            if(con != null) con.rollback(); // ロールバック
            throw e;
        } finally {
            if(con != null) { con.setAutoCommit(true); con.close(); }
        }
    }
}