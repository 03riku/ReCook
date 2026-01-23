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

/**
 * 料理の詳細情報を表示するためのサーブレット
 */
@WebServlet("/user/MenuDetail") // JSPからのリンク先URL
public class User_MenuDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 文字化け対策
        request.setCharacterEncoding("UTF-8");

        // 2. パラメータ（料理ID、店舗経由フラグ）を取得
        String idStr = request.getParameter("id");
        String fromStore = request.getParameter("fromStore"); // 店舗画面から来たかどうかの判別

        // セッションからログインユーザー情報を取得（お気に入り判定用）
        HttpSession session = request.getSession();
        GeneralUser user = (GeneralUser) session.getAttribute("loginUser");
        int userId = (user != null) ? user.getUserId() : 0;

        try {
            if (idStr != null) {
                int menuItemId = Integer.parseInt(idStr);
                UserDAO dao = new UserDAO();

                // 3. 料理の基本情報を取得（お気に入り状況含む）
                CookMenu menu = dao.getCookMenuById(menuItemId, userId);

                // 4. その料理に必要な材料リストを取得
                List<Product> ingredients = dao.getIngredientsByMenuId(menuItemId);

                // 5. リクエスト属性にセットしてJSPへ渡す
                request.setAttribute("cookMenu", menu);
                request.setAttribute("ingredientsList", ingredients);
                request.setAttribute("fromStore", fromStore); // JSPでクーポンの表示制御に使用

                // 詳細画面（Us_RecipeDetail.jsp）へフォワード
                request.getRequestDispatcher("/user/main/Us_RecipeDetail.jsp").forward(request, response);
            } else {
                // IDがない場合はトップへ
                response.sendRedirect("main/Us_Top.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main/Us_Top.jsp");
        }
    }
}