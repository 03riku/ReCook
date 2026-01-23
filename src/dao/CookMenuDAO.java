package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.CookMenu;

public class CookMenuDAO extends DAO {

    /**
     * 料理マスタ(cook_menu)から全ての料理を取得する
     * クーポン画面のドロップダウンリスト用
     */
    public List<CookMenu> selectAll() throws Exception {
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

    /**
     * 特定のIDの料理情報を取得する（詳細表示用などが必要な場合）
     */
    public CookMenu selectById(int menuItemId) throws Exception {
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
                    // 必要に応じて他のフィールドもセット
                }
            }
        }
        return cm;
    }
}