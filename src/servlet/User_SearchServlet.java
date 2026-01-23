package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.CookMenu;
import dao.UserDAO;

/**
 * 料理のキーワード検索（料理名・材料名）を担当するサーブレット
 */
@WebServlet("/user/Search")
public class User_SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. リクエストの文字エンコーディングを設定
        request.setCharacterEncoding("UTF-8");

        // 2. JSPの検索フォーム（name="keyword"）から入力値を取得
        String keyword = request.getParameter("keyword");

        try {
            // 3. DAOを使ってデータベース検索を実行
            UserDAO dao = new UserDAO();
            List<CookMenu> list = dao.searchCookMenu(keyword);

            // 4. 検索結果とタイトルをリクエスト属性に保存
            request.setAttribute("menuList", list);

            String displayKeyword = (keyword != null && !keyword.isEmpty()) ? keyword : "全件";
            request.setAttribute("pageTitle", "「" + displayKeyword + "」の検索結果");

            // 5. 料理一覧表示用JSP（Us_Recipes.jsp）へ画面を切り替える
            request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // エラーが発生した場合は、元の検索画面へリダイレクト
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Search.jsp");
        }
    }
}