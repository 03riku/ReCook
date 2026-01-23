package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Product;

/**
 * 商品（Product）テーブルへのアクセスを行うDAOクラス
 */
public class ProductDAO extends DAO {

    // ==========================================
    // 全商品取得メソッド
    // ==========================================
    /**
     * すべての商品を取得し、IDの降順（新しい順）で返します。
     * @return 商品リスト
     * @throws Exception
     */
    public List<Product> getAllProducts() throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT product_id, product_name, category FROM product ORDER BY product_id DESC";
        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setCategory(rs.getString("category"));
                list.add(p);
            }
        }
        return list;
    }

    // ==========================================
    // 検索メソッド
    // ==========================================
    /**
     * 商品名で部分一致検索を行います。
     * @param name 検索キーワード
     * @return 検索結果の商品リスト
     * @throws Exception
     */
    public List<Product> searchProducts(String name) throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT product_id, product_name, category FROM product WHERE product_name LIKE ? ORDER BY product_id DESC";
        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, "%" + name + "%");
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setCategory(rs.getString("category"));
                    list.add(p);
                }
            }
        }
        return list;
    }

    // ==========================================
    // 重複チェックメソッド
    // ==========================================
    /**
     * 商品名が既に存在するかチェックします。
     * 編集（更新）時は、自分自身のIDを除外してチェックします。
     * * @param name 商品名
     * @param excludeId 除外するID（新規登録時は0または-1、更新時はその商品のID）
     * @return 既に存在する場合は true
     * @throws Exception
     */
    public boolean isProductNameExists(String name, int excludeId) throws Exception {
        String sql = "SELECT COUNT(*) FROM product WHERE product_name = ? AND product_id != ?";
        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, name);
            st.setInt(2, excludeId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // ==========================================
    // 保存・更新メソッド (Upsert)
    // ==========================================
    /**
     * 商品を保存（新規追加）または更新します。
     * IDが存在する場合はUPDATE、存在しない場合はINSERTを実行します。
     * @param p 商品オブジェクト
     * @throws Exception
     */
    public void saveOrUpdate(Product p) throws Exception {
        try (Connection con = getConnection()) {
            boolean exists = false;

            // IDがセットされている場合、DBに存在するか確認
            if (p.getProductId() > 0) {
                String checkSql = "SELECT COUNT(*) FROM product WHERE product_id = ?";
                try (PreparedStatement pst = con.prepareStatement(checkSql)) {
                    pst.setInt(1, p.getProductId());
                    try (ResultSet rs = pst.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) exists = true;
                    }
                }
            }

            if (exists) {
                // 更新処理 (Update)
                String sql = "UPDATE product SET product_name = ?, category = ? WHERE product_id = ?";
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setString(1, p.getProductName());
                    pst.setString(2, p.getCategory());
                    pst.setInt(3, p.getProductId());
                    pst.executeUpdate();
                }
            } else {
                // 新規追加処理 (Insert)
                String sql = "INSERT INTO product (product_name, category) VALUES (?, ?)";
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setString(1, p.getProductName());
                    pst.setString(2, p.getCategory());
                    pst.executeUpdate();
                }
            }
        }
    }

    // ==========================================
    // 一括削除メソッド
    // ==========================================
    /**
     * 選択された複数のIDの商品を一括削除します。
     * @param ids 削除する商品IDの配列
     * @throws Exception
     */
    public void bulkDelete(String[] ids) throws Exception {
        if (ids == null || ids.length == 0) return;

        // SQLの IN 句を動的に生成: DELETE FROM product WHERE product_id IN (?,?,?)
        StringBuilder sql = new StringBuilder("DELETE FROM product WHERE product_id IN (");
        for (int i = 0; i < ids.length; i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(")");

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.length; i++) {
                st.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            st.executeUpdate();
        }
    }

    // ==========================================
    // カテゴリ一覧取得メソッド
    // ==========================================
    /**
     * DBに登録されているユニークな（重複しない）カテゴリ一覧を取得します。
     * 入力フォームのオートコンプリートやリスト選択に使用します。
     * @return カテゴリ名のリスト
     * @throws Exception
     */
    public List<String> getAllCategories() throws Exception {
        List<String> list = new ArrayList<>();
        // DISTINCTを使用して重複を排除し、空でないカテゴリのみ取得
        String sql = "SELECT DISTINCT category FROM product WHERE category IS NOT NULL AND category != '' ORDER BY category";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("category"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e; // Servlet側でエラーハンドリングするためにスロー
        }
        return list;
    }
    /**
     * 料理IDに紐づく必要な具材（商品マスタ）を取得する
     */
    public List<Product> getIngredientsWithPrice(int menuId, int storeId) throws Exception {
        List<Product> list = new ArrayList<>();
        // 料理に必要な具材(product)と、その店の価格(store_product)をJOINして取得
        String sql = "SELECT p.product_name, sp.price " +
                     "FROM product p " +
                     "JOIN product_cook_menu pcm ON p.product_id = pcm.product_id " +
                     "JOIN store_product sp ON p.product_id = sp.product_id " +
                     "WHERE pcm.menu_item_id = ? AND sp.store_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            ps.setInt(2, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductName(rs.getString("product_name"));
                    p.setPrice(rs.getInt("price")); // 店の価格をセット
                    list.add(p);
                }
            }
        }
        return list;
    }
}