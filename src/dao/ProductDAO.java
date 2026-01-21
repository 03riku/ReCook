package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Product;

public class ProductDAO extends DAO {

    // ... (Giữ nguyên các phương thức getAllProducts, searchProducts, isProductNameExists) ...
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

    public void saveOrUpdate(Product p) throws Exception {
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

    public void bulkDelete(String[] ids) throws Exception {
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

    /**
     * Lấy danh sách các category duy nhất đang có trong DB
     */
    public List<String> getAllCategories() throws Exception {
        List<String> list = new ArrayList<>();
        // Lấy các category duy nhất (DISTINCT) từ bảng product
        String sql = "SELECT DISTINCT category FROM product WHERE category IS NOT NULL AND category != '' ORDER BY category";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("category"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e; // Ném lỗi để Servlet xử lý
        }
        return list;
    }


}