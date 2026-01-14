package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import bean.GeneralUser;

public class UserDAO {

    // ■ データベース接続メソッド（直接記述方式）
    private Connection getConnection() throws Exception {
        // H2データベースのドライバクラスをロード
        Class.forName("org.h2.Driver");

        // 接続情報（画像の通りに設定）
        String url = "jdbc:h2:tcp://localhost/~/Re.Cook";
        String user = "sa";     // デフォルトユーザー名
        String password = "";   // デフォルトパスワード（空文字）

        // 接続を確立して返す
        return DriverManager.getConnection(url, user, password);
    }

    // ■ 新規登録用：ユーザーをDBに保存する
    public boolean registerUser(String email, String password, String name) throws Exception {
        // USER_IDは自動採番(AUTO_INCREMENT)と想定
        String sql = "INSERT INTO GENERAL_USER (EMAIL, USER_PASSWORD, ACCOUNT_NAME) VALUES (?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, name);

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    // ■ ログイン用：メールとパスワードが一致するユーザーを探す
    public GeneralUser checkLogin(String email, String password) throws Exception {
        String sql = "SELECT * FROM GENERAL_USER WHERE EMAIL = ? AND USER_PASSWORD = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // 見つかった場合、そのユーザー情報をBeanに入れて返す
                GeneralUser user = new GeneralUser();
                user.setUserId(rs.getInt("USER_ID"));
                user.setEmail(rs.getString("EMAIL"));
                user.setUserPassword(rs.getString("USER_PASSWORD"));
                user.setAccountName(rs.getString("ACCOUNT_NAME"));
                return user;
            }
            return null; // 見つからなかった場合
        }
    }
}