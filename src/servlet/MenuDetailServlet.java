package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.CookMenu;
import dao.UserDAO;

/**
 * 料理の詳細情報を取得し、詳細画面へ渡すサーブレット
 */
@WebServlet("/user/MenuDetail") // ← このURLがリンク先と一致している必要があります
public class MenuDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. リクエストパラメータからメニューID（id）を取得
        String idStr = request.getParameter("id");

        try {
            // IDが送られてきているかチェック
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);

                // 2. UserDAOをインスタンス化
                UserDAO dao = new UserDAO();

                // 3. データベースから特定の料理情報を取得（以前UserDAOに追加したメソッド）
                CookMenu menu = dao.getCookMenuById(id);

                if (menu != null) {
                    // 4. 取得したオブジェクトをリクエストスコープにセット
                    request.setAttribute("cookMenu", menu);

                    // 5. 料理詳細表示画面（Us_RecipeDetail.jsp）へフォワード
                    request.getRequestDispatcher("/user/main/Us_RecipeDetail.jsp").forward(request, response);
                } else {
                    // データが見つからない場合は検索画面へ
                    response.sendRedirect(request.getContextPath() + "/user/main/Us_Search.jsp");
                }
            } else {
                // IDが空の場合も検索画面へ
                response.sendRedirect(request.getContextPath() + "/user/main/Us_Search.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 例外が発生した場合はコンソールにログを出し、検索画面へ戻す
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Search.jsp");
        }
    }
}