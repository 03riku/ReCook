package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import bean.CookMenu;
import bean.DiscountedProduct;
import bean.Product;
import bean.StoreProduct;

public class StoreDao extends DAO {

    // ============================================================
    //  Login Method
    // ============================================================
    public String loginStore(long storeId, String password) throws Exception {
        String storeName = null;
        String sql = "SELECT STORE_NAME FROM STORE WHERE STORE_ID = ? AND STORE_PASSWORD = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, storeId);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    storeName = rs.getString("STORE_NAME");
                }
            }
        }
        return storeName;
    }

    // ============================================================
    //  CookMenu Related Methods
    // ============================================================

    public List<CookMenu> selectAllCookMenus() throws Exception {
        List<CookMenu> list = new ArrayList<>();
        String sql = "SELECT * FROM cook_menu ORDER BY menu_item_id ASC";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                CookMenu cm = new CookMenu();
                cm.setMenuItemId(rs.getInt("menu_item_id"));
                cm.setDishName(rs.getString("dish_name"));
                cm.setCookTime(rs.getInt("cook_time"));
                cm.setDescription(rs.getString("description"));
                cm.setGenreId(rs.getInt("genre_id"));
                list.add(cm);
            }
        }
        return list;
    }

    public CookMenu selectCookMenuById(int menuItemId) throws Exception {
        CookMenu cm = null;
        String sql = "SELECT * FROM cook_menu WHERE menu_item_id = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, menuItemId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    cm = new CookMenu();
                    cm.setMenuItemId(rs.getInt("menu_item_id"));
                    cm.setDishName(rs.getString("dish_name"));
                }
            }
        }
        return cm;
    }

    // ============================================================
    //  Coupon Related Methods (Insert)
    // ============================================================

    public int insertCoupon(int rate, long storeId, int menuItemId, String startTime, String endTime) throws Exception {
        int generatedId = 0;

        // 1. まず価格を計算する
        int basePrice = calculateMenuBasePrice(storeId, menuItemId);
        int finalPrice = (int) (basePrice * (1.0 - (rate / 100.0)));

        // 2. couponテーブルに INSERT (priceを含める)
        String sql = "INSERT INTO coupon (discount_rate, store_id, menu_item_id, start_time, end_time, price) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, rate);
            ps.setLong(2, storeId);
            ps.setInt(3, menuItemId);
            ps.setString(4, startTime);
            ps.setString(5, endTime);
            ps.setInt(6, finalPrice); // ★追加: 計算済み価格を保存

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
        }

        // 3. store_menu テーブルも合わせて更新・登録する (価格同期のため)
        //    (Servlet側で registerStoreMenu を呼んでいる場合は二度手間になりますが、
        //     整合性担保のためここで更新メソッドを呼んでも問題ありません)
        registerStoreMenu(storeId, menuItemId, generatedId, finalPrice); // ※下で定義する修正版を使用

        return generatedId;
    }

    // ============================================================
    //  DiscountedProduct Related Methods
    // ============================================================

    public List<DiscountedProduct> findDiscountedProductsByStoreId(long storeId) throws Exception {
        List<DiscountedProduct> list = new ArrayList<>();
        String sql = "SELECT dp.discounted_product_id, dp.discount_rate, dp.product_id, " +
                     "p.product_name, p.category, sp.price AS original_price " +
                     "FROM discounted_product dp " +
                     "JOIN product p ON dp.product_id = p.product_id " +
                     "JOIN store_product sp ON dp.product_id = sp.product_id AND sp.store_id = dp.store_id " +
                     "WHERE dp.store_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DiscountedProduct dp = new DiscountedProduct();
                    dp.setDiscountedProductId(rs.getInt("discounted_product_id"));
                    dp.setDiscountRate(rs.getInt("discount_rate"));
                    dp.setProductId(rs.getInt("product_id"));
                    dp.setProductName(rs.getString("product_name"));
                    dp.setCategory(rs.getString("category"));
                    dp.setOriginalPrice(rs.getInt("original_price"));
                    list.add(dp);
                }
            }
        }
        return list;
    }

    public boolean isDiscountedProductExists(int productId, long storeId) throws Exception {
        String sql = "SELECT COUNT(*) FROM discounted_product WHERE product_id = ? AND store_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setLong(2, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public void insertDiscountedProduct(int productId, long storeId, int rate) throws Exception {
        String sql = "INSERT INTO discounted_product (product_id, store_id, discount_rate) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setLong(2, storeId);
            ps.setInt(3, rate);
            ps.executeUpdate();
        }
    }

    public void updateDiscountRate(int id, int rate) throws Exception {
        String sql = "UPDATE discounted_product SET discount_rate = ? WHERE discounted_product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, rate);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public void deleteDiscountedProduct(int id) throws Exception {
        String sql = "DELETE FROM discounted_product WHERE discounted_product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // ============================================================
    //  Product Related Methods
    // ============================================================

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

    public void saveOrUpdateProduct(Product p) throws Exception {
        try (Connection con = getConnection()) {
            boolean exists = false;

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
                String sql = "UPDATE product SET product_name = ?, category = ? WHERE product_id = ?";
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setString(1, p.getProductName());
                    pst.setString(2, p.getCategory());
                    pst.setInt(3, p.getProductId());
                    pst.executeUpdate();
                }
            } else {
                String sql = "INSERT INTO product (product_name, category) VALUES (?, ?)";
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setString(1, p.getProductName());
                    pst.setString(2, p.getCategory());
                    pst.executeUpdate();
                }
            }
        }
    }

    public void bulkDeleteProducts(String[] ids) throws Exception {
        if (ids == null || ids.length == 0) return;

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

    public List<String> getAllCategories() throws Exception {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM product WHERE category IS NOT NULL AND category != '' ORDER BY category";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("category"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        return list;
    }

 // ============================================================
    //  ★【修正】料理に含まれる具材とその価格を取得
    //  値引き商品があれば、計算後の価格を返すように修正
    // ============================================================
    public List<Product> getIngredientsWithPrice(int menuId, long storeId) throws Exception {
        List<Product> list = new ArrayList<>();

        // CASE文を使って、割引がある場合は割引後の価格を 'price' として取得
        String sql =
            "SELECT p.product_name, " +
            "  CASE " +
            "    WHEN dp.discount_rate IS NOT NULL THEN " +
            "      TRUNCATE(sp.price * (1.0 - dp.discount_rate / 100.0), 0) " +
            "    ELSE " +
            "      sp.price " +
            "  END AS final_price " +
            "FROM product p " +
            "JOIN product_cook_menu pcm ON p.product_id = pcm.product_id " +
            "JOIN store_product sp ON p.product_id = sp.product_id " +
            "LEFT JOIN discounted_product dp ON sp.product_id = dp.product_id AND sp.store_id = dp.store_id " +
            "WHERE pcm.menu_item_id = ? AND sp.store_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            ps.setLong(2, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductName(rs.getString("product_name"));
                    // SQLでエイリアスを final_price にしましたが、
                    // Productビーンへのセットロジックを変えなくて済むよう、ここで取得してセット
                    p.setPrice(rs.getInt("final_price"));
                    list.add(p);
                }
            }
        }
        return list;
    }

    // ============================================================
    //  StoreMenu Related Methods
    // ============================================================

    public void registerStoreMenu(long storeId, int menuItemId, int couponId, int finalPrice) throws Exception {
        try (Connection conn = getConnection()) {
            // 既に登録済みかチェック
            boolean isExists = false;
            String sqlCheck = "SELECT store_menu_id FROM store_menu WHERE store_id = ? AND menu_item_id = ?";
            try (PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
                psCheck.setLong(1, storeId);
                psCheck.setInt(2, menuItemId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) isExists = true;
                }
            }

            if (isExists) {
                String sqlUpdate = "UPDATE store_menu SET price = ?, coupon_id = ? WHERE store_id = ? AND menu_item_id = ?";
                try (PreparedStatement psUpd = conn.prepareStatement(sqlUpdate)) {
                    psUpd.setInt(1, finalPrice);
                    psUpd.setInt(2, couponId);
                    psUpd.setLong(3, storeId);
                    psUpd.setInt(4, menuItemId);
                    psUpd.executeUpdate();
                }
            } else {
                String sqlInsert = "INSERT INTO store_menu (price, store_id, menu_item_id, coupon_id) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psIns = conn.prepareStatement(sqlInsert)) {
                    psIns.setInt(1, finalPrice);
                    psIns.setLong(2, storeId);
                    psIns.setInt(3, menuItemId);
                    psIns.setInt(4, couponId);
                    psIns.executeUpdate();
                }
            }
        }
    }

    // ============================================================
    //  StoreProduct Related Methods
    // ============================================================

    public List<StoreProduct> findStoreProductsByStoreId(long storeId) throws Exception {
        List<StoreProduct> list = new ArrayList<>();
        String sql = "SELECT store_product_id, product_name, category, price, product_id FROM store_product WHERE store_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StoreProduct sp = new StoreProduct();
                    sp.setStoreProductId(rs.getInt("store_product_id"));
                    sp.setProductName(rs.getString("product_name"));
                    sp.setCategory(rs.getString("category"));
                    sp.setPrice(rs.getInt("price"));
                    sp.setProductId(rs.getInt("product_id"));
                    list.add(sp);
                }
            }
        }
        return list;
    }

    public void insertStoreProductFromProduct(int productId, long storeId) throws Exception {
        String sql = "INSERT INTO store_product (product_name, category, price, store_id, product_id) " +
                     "SELECT product_name, category, 0, ?, product_id FROM product WHERE product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, storeId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }

    public void updateStoreProductPrice(int storeProductId, int price) throws Exception {
        String sql = "UPDATE store_product SET price = ? WHERE store_product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, price);
            ps.setInt(2, storeProductId);
            ps.executeUpdate();
        }
    }

    public void deleteStoreProduct(int storeProductId) throws Exception {
        String sql = "DELETE FROM store_product WHERE store_product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, storeProductId);
            ps.executeUpdate();
        }
    }

    public boolean isStoreProductExists(int productId, long storeId) throws Exception {
        String sql = "SELECT COUNT(*) FROM store_product WHERE product_id = ? AND store_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setLong(2, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // ============================================================
    //  List, Update, Delete Methods
    // ============================================================

 // ============================================================
    //  【修正】登録済みクーポン一覧取得
    //   c.price (couponテーブルの価格) を取得して表示する
    // ============================================================
    public List<Map<String, Object>> getRegisteredCoupons(long storeId) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();

        // SQL修正: c.price を取得
        String sql = "SELECT c.coupon_id, c.menu_item_id, cm.dish_name, c.discount_rate, c.start_time, c.end_time, c.price " +
                     "FROM coupon c " +
                     "JOIN cook_menu cm ON c.menu_item_id = cm.menu_item_id " +
                     "WHERE c.store_id = ? " +
                     "ORDER BY c.start_time DESC";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, storeId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("couponId", rs.getInt("coupon_id"));
                    map.put("menuItemId", rs.getInt("menu_item_id"));
                    map.put("dishName", rs.getString("dish_name"));
                    map.put("discountRate", rs.getInt("discount_rate"));

                    String start = rs.getString("start_time");
                    String end = rs.getString("end_time");
                    map.put("startTime", start != null ? start.replace(" ", "T").substring(0, 16) : "");
                    map.put("endTime", end != null ? end.replace(" ", "T").substring(0, 16) : "");

                    // ここで coupon テーブルの price をセット
                    map.put("price", rs.getInt("price"));
                    list.add(map);
                }
            }
        }
        return list;
    }

	public void updateCouponAndMenu(int couponId, int rate, long storeId, int menuItemId, String startTime, String endTime) throws Exception {

	        // 1. 価格を再計算
	        int basePrice = calculateMenuBasePrice(storeId, menuItemId);
	        int finalPrice = (int) (basePrice * (1.0 - (rate / 100.0)));

	        try (Connection con = getConnection()) {
	            // 2. Couponテーブル更新 (priceカラム追加)
	            String sqlCoupon = "UPDATE coupon SET discount_rate=?, start_time=?, end_time=?, price=? WHERE coupon_id=? AND store_id=?";
	            try (PreparedStatement ps = con.prepareStatement(sqlCoupon)) {
	                ps.setInt(1, rate);
	                ps.setString(2, startTime);
	                ps.setString(3, endTime);
	                ps.setInt(4, finalPrice); // ★追加
	                ps.setInt(5, couponId);
	                ps.setLong(6, storeId);
	                ps.executeUpdate();
	            }

	            // 3. StoreMenuテーブル更新 (同期)
	            String sqlMenu = "UPDATE store_menu SET price=? WHERE coupon_id=?";
	            try (PreparedStatement ps = con.prepareStatement(sqlMenu)) {
	                ps.setInt(1, finalPrice);
	                ps.setInt(2, couponId);
	                ps.executeUpdate();
	            }
	        }
	    }

    public void deleteCouponAndResetMenu(int couponId, long storeId, int menuItemId) throws Exception {
        try (Connection con = getConnection()) {

            // ★修正: 共通メソッドを使用 (クーポン割引がなくなるだけで、具材割引は維持されるべき)
            int basePrice = calculateMenuBasePrice(storeId, menuItemId);

            // store_menuのリセット (price には basePrice をセット)
            String sqlReset = "UPDATE store_menu SET price=?, coupon_id=NULL WHERE coupon_id=?";
            try (PreparedStatement ps = con.prepareStatement(sqlReset)) {
                ps.setInt(1, basePrice);
                ps.setInt(2, couponId);
                ps.executeUpdate();
            }

            // クーポン削除
            String sqlDel = "DELETE FROM coupon WHERE coupon_id=? AND store_id=?";
            try (PreparedStatement ps = con.prepareStatement(sqlDel)) {
                ps.setInt(1, couponId);
                ps.setLong(2, storeId);
                ps.executeUpdate();
            }
        }
    }

    /**
     * 時間重複チェック
     */
    public boolean isCouponTimeOverlapping(long storeId, int menuItemId, String startTime, String endTime, int currentCouponId) throws Exception {
        String sql = "SELECT COUNT(*) FROM coupon " +
                     "WHERE store_id = ? AND menu_item_id = ? AND coupon_id != ? " +
                     "AND start_time < ? AND end_time > ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, storeId);
            ps.setInt(2, menuItemId);
            ps.setInt(3, currentCouponId);
            ps.setString(4, endTime);
            ps.setString(5, startTime);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }


    // ============================================================
    //  期限切れクーポンの自動削除
    // ============================================================
    public void deleteExpiredCoupons() throws Exception {
        // 現在時刻を過ぎているクーポンを検索
        String findSql = "SELECT coupon_id, store_id, menu_item_id FROM coupon WHERE end_time < CURRENT_TIMESTAMP";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(findSql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int couponId = rs.getInt("coupon_id");
                long storeId = rs.getLong("store_id");
                int menuItemId = rs.getInt("menu_item_id");

                // 既存の deleteCouponAndResetMenu を呼び出すことで
                // クーポン削除と同時に販売価格を定価へ戻す
                deleteCouponAndResetMenu(couponId, storeId, menuItemId);
            }
        }
    }

 // ============================================================
    //  【追加】共通メソッド：メニューの具材合計金額（原価）を計算する
    //   ※値引き商品(discounted_product)がある場合はそちらを優先
    // ============================================================
 // ============================================================
    //  【共通】メニューの原価計算 (値引き商品があればそれを優先)
    // ============================================================
    private int calculateMenuBasePrice(long storeId, int menuItemId) throws Exception {
        int totalBasePrice = 0;
        String sql =
            "SELECT SUM( " +
            "  CASE " +
            "    WHEN dp.discount_rate IS NOT NULL THEN " +
            "      TRUNCATE(sp.price * (1.0 - dp.discount_rate / 100.0), 0) " +
            "    ELSE " +
            "      sp.price " +
            "  END " +
            ") AS total_price " +
            "FROM product_cook_menu pcm " +
            "JOIN store_product sp ON pcm.product_id = sp.product_id " +
            "LEFT JOIN discounted_product dp ON sp.product_id = dp.product_id AND sp.store_id = dp.store_id " +
            "WHERE pcm.menu_item_id = ? AND sp.store_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, menuItemId);
            ps.setLong(2, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalBasePrice = rs.getInt("total_price");
                }
            }
        }
        return totalBasePrice;
    }
}