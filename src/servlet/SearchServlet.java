package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.CookMenu;
import dao.CookMenuDAO;

@WebServlet("/user/Search")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        try {
            CookMenuDAO dao = new CookMenuDAO();
            List<CookMenu> list = dao.search(keyword);

            // 検索結果のリストをリクエストスコープにセット
            request.setAttribute("menuList", list);

            // 検索結果表示用JSPへ転送
            request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}