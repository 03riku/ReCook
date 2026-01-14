package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDAO;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 文字化け防止
        request.setCharacterEncoding("UTF-8");

        // 2. フォームから入力値を受け取る
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String username = request.getParameter("username");

        // 3. DAOを使ってデータベースに保存する
        UserDAO dao = new UserDAO();
        try {
            // ★ここが保存処理の核心です
            boolean isSuccess = dao.registerUser(email, password, username);

            if (isSuccess) {
                // 保存成功！ -> ログイン画面へ
                response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp");
            } else {
                // 保存失敗... -> 登録画面に戻す
                response.sendRedirect(request.getContextPath() + "/user/main/Us_NewAccount.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // エラー時も登録画面に戻す
            response.sendRedirect(request.getContextPath() + "/user/main/Us_NewAccount.jsp?error=exception");
        }
    }
}