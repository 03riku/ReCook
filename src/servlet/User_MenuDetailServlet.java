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
import bean.Product;
import dao.UserDAO;

@WebServlet("/user/MenuDetail")
public class User_MenuDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 【追加】ブラウザのキャッシュを無効化（戻るボタン対策）
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
        response.setDateHeader("Expires", 0); // Proxies.

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        String fromStore = request.getParameter("fromStore");

        HttpSession session = request.getSession();
        GeneralUser user = (GeneralUser) session.getAttribute("loginUser");
        int userId = (user != null) ? user.getUserId() : 0;

        try {
            if (idStr != null) {
                int menuItemId = Integer.parseInt(idStr);
                UserDAO dao = new UserDAO();

                CookMenu menu = dao.getCookMenuById(menuItemId, userId);
                List<Product> ingredients = dao.getIngredientsByMenuId(menuItemId);

                request.setAttribute("cookMenu", menu);
                request.setAttribute("ingredientsList", ingredients);
                request.setAttribute("fromStore", fromStore);

                request.getRequestDispatcher("/user/main/Us_RecipeDetail.jsp").forward(request, response);
            } else {
                response.sendRedirect("main/Us_Top.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main/Us_Top.jsp");
        }
    }
}