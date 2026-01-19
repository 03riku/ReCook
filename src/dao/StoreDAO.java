package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Store;

public class StoreDAO extends DAO {

    public List<Store> selectAll() throws Exception {
        List<Store> storeList = new ArrayList<>();
        Connection con = getConnection();
        String sql = "SELECT * FROM store ORDER BY store_id ASC";
        PreparedStatement st = con.prepareStatement(sql);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            storeList.add(new Store(rs.getInt("store_id"), rs.getString("store_name"),
                                    rs.getString("store_password"), rs.getString("store_address")));
        }
        st.close(); con.close();
        return storeList;
    }

    public List<Store> searchByName(String name) throws Exception {
        List<Store> storeList = new ArrayList<>();
        Connection con = getConnection();
        String sql = "SELECT * FROM store WHERE store_name LIKE ? ORDER BY store_id ASC";
        PreparedStatement st = con.prepareStatement(sql);
        st.setString(1, "%" + name + "%");
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            storeList.add(new Store(rs.getInt("store_id"), rs.getString("store_name"),
                                    rs.getString("store_password"), rs.getString("store_address")));
        }
        st.close(); con.close();
        return storeList;
    }

    public Store selectById(int id) throws Exception {
        Store store = null;
        Connection con = getConnection();
        String sql = "SELECT * FROM store WHERE store_id = ?";
        PreparedStatement st = con.prepareStatement(sql);
        st.setInt(1, id);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            store = new Store(rs.getInt("store_id"), rs.getString("store_name"),
                              rs.getString("store_password"), rs.getString("store_address"));
        }
        st.close(); con.close();
        return store;
    }

    public boolean isIdExists(int id) throws Exception {
        boolean exists = false;
        Connection con = getConnection();
        String sql = "SELECT COUNT(*) FROM store WHERE store_id = ?";
        PreparedStatement st = con.prepareStatement(sql);
        st.setInt(1, id);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            if (rs.getInt(1) > 0) exists = true;
        }
        st.close(); con.close();
        return exists;
    }

    public int insert(Store store) throws Exception {
        Connection con = getConnection();
        String sql = "INSERT INTO store VALUES (?, ?, ?, ?)";
        PreparedStatement st = con.prepareStatement(sql);
        st.setInt(1, store.getStoreId());
        st.setString(2, store.getStoreName());
        st.setString(3, store.getStorePassword());
        st.setString(4, store.getStoreAddress());
        int line = st.executeUpdate();
        st.close(); con.close();
        return line;
    }

    public int update(Store store, int oldId) throws Exception {
        Connection con = getConnection();
        String sql = "UPDATE store SET store_id=?, store_name=?, store_password=?, store_address=? WHERE store_id=?";
        PreparedStatement st = con.prepareStatement(sql);
        st.setInt(1, store.getStoreId());
        st.setString(2, store.getStoreName());
        st.setString(3, store.getStorePassword());
        st.setString(4, store.getStoreAddress());
        st.setInt(5, oldId);
        int line = st.executeUpdate();
        st.close(); con.close();
        return line;
    }

    public int delete(int id) throws Exception {
        Connection con = getConnection();
        String sql = "DELETE FROM store WHERE store_id=?";
        PreparedStatement st = con.prepareStatement(sql);
        st.setInt(1, id);
        int line = st.executeUpdate();
        st.close(); con.close();
        return line;
    }
}