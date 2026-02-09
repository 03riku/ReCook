package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * ログアウト処理（セッション破棄）を担当するサーブレット
 */
@WebServlet("/User_LogoutServlet") // URLもクラス名に合わせました
public class User_LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. セッションを取得（なければnull）
        HttpSession session = request.getSession(false);

        if (session != null) {
            // 2. セッションを無効化（ログアウト処理の本体）
            session.invalidate();
        }

        // 3. ログアウト完了後、ログイン画面へ移動
        response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp");
    }
}