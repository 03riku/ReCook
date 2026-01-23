package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDAO;

/**
 * 新規ユーザー登録処理を担当するサーブレット
 */
@WebServlet("/User_SignupServlet") // JSPのactionと一致させるURL
public class User_SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 文字化け対策
        request.setCharacterEncoding("UTF-8");

        // JSPのフォームから入力値を取得
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String username = request.getParameter("username");

        UserDAO dao = new UserDAO();
        try {
            // データベースにユーザー情報を登録
            boolean isSuccess = dao.registerUser(email, password, username);

            if (isSuccess) {
                // ■ 登録成功
                // ログイン画面へリダイレクト（成功メッセージなどは任意で追加）
                response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp?register=success");
            } else {
                // ■ 登録失敗
                // 新規登録画面に戻す
                response.sendRedirect(request.getContextPath() + "/user/main/Us_NewAccount.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // システムエラー時も新規登録画面に戻す
            response.sendRedirect(request.getContextPath() + "/user/main/Us_NewAccount.jsp?error=exception");
        }
    }
}