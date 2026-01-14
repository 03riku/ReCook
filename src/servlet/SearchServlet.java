package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.CookMenu;
import dao.UserDAO; // ★ここがUserDAOになっていることを確認

@WebServlet("/user/Search")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        try {
            UserDAO dao = new UserDAO();
            // ★UserDAOに作った検索メソッドを呼ぶ
            List<CookMenu> list = dao.searchCookMenu(keyword);

            request.setAttribute("menuList", list);
            request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}