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

/**
 * お気に入りの登録・解除（トグル処理）を担当するサーブレット
 */
@WebServlet("/user/User_FavoriteToggle")
public class User_FavoriteToggleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // セッションからログインユーザー情報を取得
        HttpSession session = request.getSession();
        GeneralUser user = (GeneralUser) session.getAttribute("loginUser");

        if (user == null) {
            // ログインしていない場合はログイン画面へ
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp");
            return;
        }

        // 料理IDを取得
        String idStr = request.getParameter("id");
        try {
            if (idStr != null) {
                int menuItemId = Integer.parseInt(idStr);
                UserDAO dao = new UserDAO();

                // データベース側でお気に入りの有無を反転（トグル）させる
                dao.toggleFavorite(user.getUserId(), menuItemId);

                // ★ 詳細画面へリダイレクトして戻る
                // User_MenuDetailServlet の設定URL (@WebServlet("/user/MenuDetail")) に合わせます
                response.sendRedirect("MenuDetail?id=" + menuItemId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // エラー時はトップへ
            response.sendRedirect("main/Us_Top.jsp");
        }
    }
}