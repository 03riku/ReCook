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

@WebServlet("/user/GenreRecipes")
public class User_GenreRecipesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String genreIdStr = request.getParameter("genreId");
        String genreName = request.getParameter("genreName");

        try {
            if (genreIdStr != null) {
                int genreId = Integer.parseInt(genreIdStr);
                UserDAO dao = new UserDAO();
                List<CookMenu> list = dao.getMenusByGenreId(genreId);

                request.setAttribute("menuList", list);
                request.setAttribute("pageTitle", genreName); // ジャンル名をタイトルに

                // 表示には既存の Us_Recipes.jsp を再利用します
                request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main/Us_RecipeGenre.jsp");
        }
    }
}