package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * スーパーログイン用サーブレット
 * 対応URL: /SuperLoginServlet
 */
@WebServlet("/SuperLoginServlet")
public class SuperLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // データベース接続情報（H2 Consoleの表示に基づく）
    private static final String JDBC_URL = "jdbc:h2:tcp://localhost/~/Re.Cook";
    private static final String DB_USER = "sa";
    private static final String DB_PASS = "";

    /**
     * POSTリクエスト：ログインボタンが押された時の処理
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 文字エンコーディングの設定と入力値の取得
        request.setCharacterEncoding("UTF-8");
        String id = request.getParameter("id");
        String pass = request.getParameter("pass");

        boolean isSuccess = false;
        String storeName = "";

        // 2. データベースで認証チェック
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // H2 JDBCドライバのロード
            Class.forName("org.h2.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);

            // STOREテーブルからIDとパスワードが一致するレコードを検索
            String sql = "SELECT STORE_NAME FROM STORE WHERE STORE_ID = ? AND STORE_PASSWORD = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, pass);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                // 一致するデータがあればログイン成功
                isSuccess = true;
                storeName = rs.getString("STORE_NAME");
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // DBリソースのクローズ
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // 3. 認証結果に応じた画面遷移
        if (isSuccess) {
            // 成功：セッションにログイン情報を保存
            HttpSession session = request.getSession();
            session.setAttribute("storeId", id);
            session.setAttribute("storeName", storeName);

            // メニュー画面へ移動（Sp_Menu.jspはsuperフォルダ直下にあるため、パスを修正）
            response.sendRedirect(request.getContextPath() + "/super/Sp_Menu.jsp");
        } else {
            // 失敗：エラーメッセージをセットして元のログイン画面に戻す
            request.setAttribute("errorMsg", "店舗IDまたはパスワードが正しくありません。");

            // WebContentからの相対パスを指定
            request.getRequestDispatcher("/super/account/Sp_Login.jsp").forward(request, response);
        }
    }

    /**
     * 直接URLが叩かれた場合（GETリクエスト）はログイン画面に飛ばす
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/super/account/Sp_Login.jsp");
    }
}