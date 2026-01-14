package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import bean.Admin;

public class AdminDAO extends DAO {

    public Admin findAdmin(int adminId, String adminPass) {
        Admin admin = null;
        String sql = "SELECT * FROM admin WHERE admin_id = ? AND admin_pass = ?";

        try (
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
        ) {
            ps.setInt(1, adminId);
            ps.setString(2, adminPass.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setAdminPass(rs.getString("admin_pass"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }


}