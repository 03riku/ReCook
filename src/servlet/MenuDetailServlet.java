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
import bean.Product; // ★追加
import dao.UserDAO;

@WebServlet("/user/MenuDetail")
public class MenuDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String fromStore = request.getParameter("fromStore");

        HttpSession session = request.getSession();
        GeneralUser user = (GeneralUser) session.getAttribute("loginUser");
        int userId = (user != null) ? user.getUserId() : 0;

        try {
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                UserDAO dao = new UserDAO();

                CookMenu menu = dao.getCookMenuById(id, userId);
                // ★ ここを List<Product> に修正
                List<Product> ingredients = dao.getIngredientsByMenuId(id);

                request.setAttribute("cookMenu", menu);
                request.setAttribute("ingredientsList", ingredients);
                // 検索から来ても店舗から来ても fromStore パラメータでボタンを制御
                request.setAttribute("fromStore", fromStore);

                request.getRequestDispatcher("/user/main/Us_RecipeDetail.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main/Us_Top.jsp");
        }
    }
}