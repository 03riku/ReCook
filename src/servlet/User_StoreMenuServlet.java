package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.CookMenu;
import bean.User_Store;
import dao.UserDAO;

@WebServlet("/user/StoreMenu")
public class User_StoreMenuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String idStr = request.getParameter("id");
        try {
            if (idStr != null) {
                int storeId = Integer.parseInt(idStr);
                UserDAO dao = new UserDAO();

                // ★店舗名を取得してタイトルを作成
                User_Store store = dao.getStoreById(storeId);
                String title = (store != null) ? store.getStoreName() + " 限定メニュー" : "店舗限定メニュー";

                List<CookMenu> list = dao.getMenusByStoreId(storeId);

                request.setAttribute("menuList", list);
                request.setAttribute("pageTitle", title); // 動的なタイトルをセット
                request.setAttribute("fromStore", true);

                request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("StoreList");
        }
    }
}