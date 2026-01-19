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
            // 文字化け対策
            request.setCharacterEncoding("UTF-8");

            // 検索キーワードを取得
            String keyword = request.getParameter("keyword");

            UserDAO dao = new UserDAO();
            List<User_Store> list;

            if (keyword != null && !keyword.isEmpty()) {
                // キーワードがあれば検索を実行
                list = dao.searchStores(keyword);
                request.setAttribute("pageTitle", "店舗検索結果");
            } else {
                // キーワードがなければ全件取得
                list = dao.getAllStores();
                request.setAttribute("pageTitle", "店舗一覧");
            }

            // リストをJSPへ渡す
            request.setAttribute("storeList", list);
            request.getRequestDispatcher("/user/main/Us_Store.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Top.jsp");
        }
    }
}