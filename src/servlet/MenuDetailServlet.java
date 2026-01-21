package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.CookMenu;
import bean.GeneralUser;
import dao.UserDAO;

@WebServlet("/user/MenuDetail")
public class MenuDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String fromStore = request.getParameter("fromStore");

        // ログイン中のユーザーIDを取得（お気に入り判定用）
        HttpSession session = request.getSession();
        GeneralUser user = (GeneralUser) session.getAttribute("loginUser");
        int userId = (user != null) ? user.getUserId() : 0;

        try {
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                UserDAO dao = new UserDAO();

                // お気に入り状態を含めた料理情報を取得
                CookMenu menu = dao.getCookMenuById(id, userId);

                request.setAttribute("cookMenu", menu);
                request.setAttribute("showCoupon", "true".equals(fromStore));

                request.getRequestDispatcher("/user/main/Us_RecipeDetail.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main/Us_Top.jsp");
        }
    }
}