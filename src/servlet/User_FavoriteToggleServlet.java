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

@WebServlet("/user/User_FavoriteToggle")
public class User_FavoriteToggleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        GeneralUser user = (GeneralUser) session.getAttribute("loginUser");

        // 未ログインなら401エラー（JavaScript側で判別可能）
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String idStr = request.getParameter("id");
        String ajax = request.getParameter("ajax"); // AJAXフラグ

        try {
            if (idStr != null) {
                int menuItemId = Integer.parseInt(idStr);
                UserDAO dao = new UserDAO();

                // お気に入り状態を反転
                dao.toggleFavorite(user.getUserId(), menuItemId);

                // ★ 非同期通信（AJAX）の場合、リダイレクトせずに「ok」とだけ返す
                if ("true".equals(ajax)) {
                    response.setContentType("text/plain");
                    response.getWriter().write("ok");
                    return;
                }

                // AJAXでなければ通常のリダイレクト（履歴を汚さないようタイムスタンプは削除）
                response.sendRedirect("MenuDetail?id=" + menuItemId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}