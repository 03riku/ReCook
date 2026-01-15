package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDAO;

/**
 * お気に入りの状態（1:未登録, 2:登録済）を反転させるサーブレット
 */
@WebServlet("/user/User_FavoriteToggle")
public class User_FavoriteToggleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // リクエストパラメータからメニューIDを取得
        String idStr = request.getParameter("id");

        try {
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);

                UserDAO dao = new UserDAO();
                // DAOで状態を反転させる
                dao.toggleFavorite(id);

                // 完了後、元の詳細画面へリダイレクトして情報を再読み込みさせる
                response.sendRedirect("MenuDetail?id=" + id);
            } else {
                response.sendRedirect("main/Us_Top.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main/Us_Top.jsp");
        }
    }
}