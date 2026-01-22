package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.DiscountedProduct;

public class DiscountedProductDAO extends DAO {

    // 右側：値引き商品一覧（商品名と定価をJOINで取得）
    public List<DiscountedProduct> findByStoreId(int storeId) throws Exception {
        List<DiscountedProduct> list = new ArrayList<>();
        String sql = "SELECT dp.discounted_product_id, dp.discount_rate, dp.product_id, " +
                     "p.product_name, p.category, sp.price AS original_price " +
                     "FROM discounted_product dp " +
                     "JOIN product p ON dp.product_id = p.product_id " +
                     "JOIN store_product sp ON dp.product_id = sp.product_id AND sp.store_id = dp.store_id " +
                     "WHERE dp.store_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, storeId);
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

    public boolean isExists(int productId, int storeId) throws Exception {
        String sql = "SELECT COUNT(*) FROM discounted_product WHERE product_id = ? AND store_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public void insert(int productId, int storeId, int rate) throws Exception {
        String sql = "INSERT INTO discounted_product (product_id, store_id, discount_rate) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, storeId);
            ps.setInt(3, rate);
            ps.executeUpdate();
        }
    }

    public void updateRate(int id, int rate) throws Exception {
        String sql = "UPDATE discounted_product SET discount_rate = ? WHERE discounted_product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, rate);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws Exception {
        String sql = "DELETE FROM discounted_product WHERE discounted_product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}