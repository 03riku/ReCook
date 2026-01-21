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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // セッションからログインユーザー情報を取得
        HttpSession session = request.getSession();
        GeneralUser user = (GeneralUser) session.getAttribute("loginUser");

        if (user == null) {
            // ログインしていない場合はログイン画面へ（安全策）
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        try {
            if (idStr != null) {
                int menuItemId = Integer.parseInt(idStr);
                UserDAO dao = new UserDAO();

                // ログインユーザーのIDを使ってお気に入りを切り替える
                dao.toggleFavorite(user.getUserId(), menuItemId);

                // 詳細画面へ戻る（表示を更新するため）
                response.sendRedirect("MenuDetail?id=" + menuItemId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main/Us_Top.jsp");
        }
    }
}