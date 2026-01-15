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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ★文字化け対策
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String keyword = request.getParameter("keyword");
        try {
            UserDAO dao = new UserDAO();
            List<CookMenu> list = dao.searchCookMenu(keyword);

            request.setAttribute("menuList", list);
            // 検索経由なので fromStore はセットしない（または false になる）

            request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}