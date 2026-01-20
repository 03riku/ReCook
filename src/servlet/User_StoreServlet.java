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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            String keyword = request.getParameter("keyword");
            String pref = request.getParameter("pref"); // 県のパラメータ取得

            UserDAO dao = new UserDAO();

            // 検索実行（キーワードと県の両方を渡す）
            List<User_Store> list = dao.searchStores(keyword, pref);
            // プルダウン用の県リスト取得
            List<String> prefList = dao.getPrefectures();

            request.setAttribute("storeList", list);
            request.setAttribute("prefList", prefList); // JSPへ渡す
            request.setAttribute("pageTitle", "店舗一覧");

            request.getRequestDispatcher("/user/main/Us_Store.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Top.jsp");
        }
    }
}