package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class CouponDAO extends DAO {
    // クーポンの新規登録
    public void insert(int rate, int storeId, int menuItemId) throws Exception {
        String sql = "INSERT INTO coupon (discount_rate, store_id, menu_item_id) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, rate);
            ps.setInt(2, storeId);
            ps.setInt(3, menuItemId);
            ps.executeUpdate();
        }
    }
}