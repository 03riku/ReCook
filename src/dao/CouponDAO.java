package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class CouponDAO extends DAO {

    /**
     * クーポンの新規登録
     * ★修正点: storeId を long (BIGINT対応) に変更しました
     */
    public int insert(int rate, long storeId, int menuItemId, String startTime, String endTime) throws Exception {
        int generatedId = 0;
        String sql = "INSERT INTO coupon (discount_rate, store_id, menu_item_id, start_time, end_time) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, rate);
            ps.setLong(2, storeId); // ★ setInt → setLong に変更
            ps.setInt(3, menuItemId);
            ps.setString(4, startTime);
            ps.setString(5, endTime);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
        }
        return generatedId;
    }
}