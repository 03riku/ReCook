package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.CookMenu;
import dao.UserDAO;

/**
 * FAVORITE_ID = 2 の料理一覧を取得して表示するサーブレット
 */
@WebServlet("/user/User_FavoriteList")
public class User_FavoriteListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            UserDAO dao = new UserDAO();
            // お気に入り登録済みのリストを取得
            List<CookMenu> list = dao.getFavoriteMenus();

            // リクエストスコープにセット
            request.setAttribute("menuList", list);
            request.setAttribute("pageTitle", "お気に入りメニュー");

            // 検索結果画面（Us_Recipes.jsp）を再利用して表示
            request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Account.jsp");
        }
    }
}