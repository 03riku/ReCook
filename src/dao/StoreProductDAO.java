package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.StoreProduct;

public class StoreProductDAO extends DAO {

    // 右側の自店舗商品一覧取得
    public List<StoreProduct> findByStoreId(int storeId) throws Exception {
        List<StoreProduct> list = new ArrayList<>();
        String sql = "SELECT store_product_id, product_name, category, price FROM store_product WHERE store_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StoreProduct sp = new StoreProduct();
                    sp.setStoreProductId(rs.getInt("store_product_id"));
                    sp.setProductName(rs.getString("product_name"));
                    sp.setCategory(rs.getString("category"));
                    sp.setPrice(rs.getInt("price"));
                    list.add(sp);
                }
            }
        }
        return list;
    }

    // 左から右への追加（マスターから情報をコピー）
    public void insertFromProduct(int productId, int storeId) throws Exception {
        String sql = "INSERT INTO store_product (product_name, category, price, store_id, product_id) " +
                     "SELECT product_name, category, 0, ?, product_id FROM product WHERE product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }

    public void updatePrice(int storeProductId, int price) throws Exception {
        String sql = "UPDATE store_product SET price = ? WHERE store_product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, price);
            ps.setInt(2, storeProductId);
            ps.executeUpdate();
        }
    }

    // 商品を削除する
    public void delete(int storeProductId) throws Exception {
        String sql = "DELETE FROM store_product WHERE store_product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, storeProductId);
            ps.executeUpdate();
        }
    }
    public boolean isExists(int productId, int storeId) throws Exception {
        String sql = "SELECT COUNT(*) FROM store_product WHERE product_id = ? AND store_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, storeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}