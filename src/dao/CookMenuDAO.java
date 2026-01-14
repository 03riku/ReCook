package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.CookMenu;

public class CookMenuDAO {
    // 接続先URL (画像に基づいた設定)
    private final String URL = "jdbc:h2:tcp://localhost/~/Re.Cook";
    private final String USER = "sa";
    private final String PASS = "";

    public List<CookMenu> search(String keyword) throws Exception {
        List<CookMenu> list = new ArrayList<>();
        Class.forName("org.h2.Driver");

        try (Connection con = DriverManager.getConnection(URL, USER, PASS)) {
            // DISH_NAME(料理名) または DESCRIPTION(説明文) で検索
            String sql = "SELECT * FROM COOK_MENU WHERE DISH_NAME LIKE ? OR DESCRIPTION LIKE ?";
            PreparedStatement st = con.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            st.setString(2, "%" + keyword + "%");

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CookMenu menu = new CookMenu();
                menu.setMenuItemId(rs.getInt("MENU_ITEM_ID"));
                menu.setMenuName(rs.getString("DISH_NAME")); // DBのDISH_NAMEを格納
                // ※DBにCOOK_TIMEカラムがない場合は適当な値を入れるか、DBにカラム追加してください
                // menu.setCookTime(rs.getInt("COOK_TIME"));
                list.add(menu);
            }
        }
        return list;
    }
}