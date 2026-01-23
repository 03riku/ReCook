package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StoreMenuDAO extends DAO {

    public void registerStoreMenu(long storeId, int menuItemId, int couponId, int discountRate) throws Exception {

        try (Connection conn = getConnection()) {

            // --------------------------------------------------------
            // 1. その店舗での「具材合計金額（定価）」を計算する
            // --------------------------------------------------------
            int basePrice = 0;
            String sqlCalcPrice =
                "SELECT SUM(sp.price) as total_price " +
                "FROM product_cook_menu pcm " +
                "JOIN store_product sp ON pcm.product_id = sp.product_id " +
                "WHERE pcm.menu_item_id = ? AND sp.store_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(sqlCalcPrice)) {
                ps.setInt(1, menuItemId);
                ps.setLong(2, storeId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    basePrice = rs.getInt("total_price");
                }
            }

            // 割引計算
            int finalPrice = (int) (basePrice * (1.0 - (discountRate / 100.0)));


            // --------------------------------------------------------
            // 2. 既に登録済みかチェックする (ここを変更！)
            // --------------------------------------------------------
            boolean isExists = false;
            String sqlCheck = "SELECT store_menu_id FROM store_menu WHERE store_id = ? AND menu_item_id = ?";

            try (PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
                psCheck.setLong(1, storeId);
                psCheck.setInt(2, menuItemId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        isExists = true; // データが存在する
                    }
                }
            }

            // --------------------------------------------------------
            // 3. 存在すれば UPDATE、なければ INSERT
            // --------------------------------------------------------
            if (isExists) {
                // 更新処理
                String sqlUpdate = "UPDATE store_menu SET price = ?, coupon_id = ? WHERE store_id = ? AND menu_item_id = ?";
                try (PreparedStatement psUpd = conn.prepareStatement(sqlUpdate)) {
                    psUpd.setInt(1, finalPrice);
                    psUpd.setInt(2, couponId);
                    psUpd.setLong(3, storeId);
                    psUpd.setInt(4, menuItemId);
                    psUpd.executeUpdate();
                }
            } else {
                // 新規登録処理
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
}