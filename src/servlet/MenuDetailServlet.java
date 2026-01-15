package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.CookMenu;
import dao.UserDAO;

@WebServlet("/user/MenuDetail")
public class MenuDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ★文字化け対策
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String idStr = request.getParameter("id");
        // 店舗経由かどうかのフラグを取得
        String fromStore = request.getParameter("fromStore");

        try {
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                UserDAO dao = new UserDAO();
                CookMenu menu = dao.getCookMenuById(id);

                if (menu != null) {
                    request.setAttribute("cookMenu", menu);

                    // 店舗経由(fromStore=true)の場合のみクーポンを表示するフラグをセット
                    request.setAttribute("showCoupon", "true".equals(fromStore));

                    request.getRequestDispatcher("/user/main/Us_RecipeDetail.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/main/Us_Search.jsp");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/user/main/Us_Search.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Search.jsp");
        }
    }
}