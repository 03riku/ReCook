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

@WebServlet("/user/Search")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("keyword");
        try {
            UserDAO dao = new UserDAO();
            List<CookMenu> list = dao.searchCookMenu(keyword);

            request.setAttribute("menuList", list);
            // ★タイトルを必ずセット（JSPでのエラー防止）
            request.setAttribute("pageTitle", "「" + (keyword != null ? keyword : "") + "」の検索結果");

            request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main/Us_Top.jsp");
        }
    }
}