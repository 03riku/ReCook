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
@WebServlet("/User_SignupServlet")
public class User_SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String username = request.getParameter("username");

        UserDAO dao = new UserDAO();
        try {
            // 1. まずメールアドレスが既に使われていないかチェック
            if (dao.isEmailExists(email)) {
                // 重複していたら、URLに専用のエラーコードを付けて戻す
                response.sendRedirect(request.getContextPath() + "/user/main/Us_NewAccount.jsp?error=email_exists");
                return;
            }

            // 2. 重複がなければ登録実行
            boolean isSuccess = dao.registerUser(email, password, username);

            if (isSuccess) {
                // 成功：ログイン画面へ
                response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp?register=success");
            } else {
                // 失敗：登録画面へ
                response.sendRedirect(request.getContextPath() + "/user/main/Us_NewAccount.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/main/Us_NewAccount.jsp?error=exception");
        }
    }
}