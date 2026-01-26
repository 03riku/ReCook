package store;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.User_Store;
import dao.UserDAO;

@WebServlet("/user/StoreByMenu")
public class StoreByMenuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String menuIdStr = request.getParameter("menuId");
        String dishName = request.getParameter("dishName");

        try {
            if (menuIdStr != null) {
                int menuId = Integer.parseInt(menuIdStr);
                UserDAO dao = new UserDAO();

                // 特定のメニューIDを取り扱っている店舗のみ取得
                List<User_Store> storeList = dao.getStoresByMenuItemId(menuId);

                request.setAttribute("storeList", storeList);
                request.setAttribute("pageTitle", "「" + dishName + "」取扱店舗一覧");

                // 店舗一覧画面を表示
                request.getRequestDispatcher("/user/main/Us_Store.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Top.jsp");
        }
    }
}