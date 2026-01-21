package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.CookMenu;
import bean.GeneralUser;
import dao.UserDAO;

@WebServlet("/user/User_FavoriteList")
public class User_FavoriteListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        GeneralUser user = (GeneralUser) session.getAttribute("loginUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp");
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            // 自分(userId)が登録したものだけを取得
            List<CookMenu> list = dao.getFavoriteMenus(user.getUserId());

            request.setAttribute("menuList", list);
            request.setAttribute("pageTitle", "お気に入りメニュー");

            request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Account.jsp");
        }
    }
}