package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDAO;

@WebServlet("/user/StoreList")
public class User_StoreServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("keyword");
        String pref = request.getParameter("pref");

        try {
            UserDAO dao = new UserDAO();

            // 検索・絞り込み実行
            request.setAttribute("storeList", dao.searchStores(keyword, pref));
            // 県リスト取得
            request.setAttribute("prefList", dao.getPrefectures());
            request.setAttribute("pageTitle", "店舗一覧");

            // JSPへ移動
            request.getRequestDispatcher("/user/main/Us_Store.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main/Us_Top.jsp");
        }
    }
}