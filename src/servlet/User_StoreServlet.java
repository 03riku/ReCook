package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.User_Store;
import dao.UserDAO;

@WebServlet("/user/StoreList")
public class User_StoreServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            UserDAO dao = new UserDAO();
            // DBから店舗一覧を取得
            List<User_Store> list = dao.getAllStores();

            // JSPへ渡す
            request.setAttribute("storeList", list);
            request.getRequestDispatcher("/user/main/Us_Store.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Top.jsp");
        }
    }
}