package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.User_Store;
import dao.UserDAO;

@WebServlet("/user/StoreMenu")
public class User_StoreMenuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        try {
            if (idStr != null) {
                // ★ Integer.parseInt から Long.parseLong に変更
                long storeId = Long.parseLong(idStr);
                UserDAO dao = new UserDAO();

                User_Store store = dao.getStoreById(storeId);
                String title = (store != null) ? store.getStoreName() + " 限定メニュー" : "店舗限定メニュー";

                request.setAttribute("menuList", dao.getMenusByStoreId(storeId));
                request.setAttribute("pageTitle", title);
                request.setAttribute("fromStore", true);

                request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("StoreList");
        }
    }
}