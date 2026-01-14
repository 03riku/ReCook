
package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.GeneralUser;
import dao.UserDAO;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        try {
            // ログインチェック
            GeneralUser user = dao.checkLogin(email, password);

            if (user != null) {
                // ■ ログイン成功！
                // セッションにユーザー情報を保存（これでログイン状態を維持します）
                HttpSession session = request.getSession();
                session.setAttribute("loginUser", user);

                // トップ画面（ホーム）へ移動
                response.sendRedirect(request.getContextPath() + "/user/main/Us_Top.jsp");
            } else {
                // ■ ログイン失敗
                // ログイン画面に戻す
                response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp?error=login_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp?error=exception");
        }
    }
}