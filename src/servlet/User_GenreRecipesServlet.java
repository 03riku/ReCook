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
 * 【ジャンル別レシピ一覧表示サーブレット】
 * ユーザーが「和食」「洋食」などのボタンを押したときに、
 * そのジャンルに合った料理をDBから取り出して一覧画面に送る役割です。
 */
@WebServlet("/user/GenreRecipes")
public class User_GenreRecipesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 文字化け対策（日本語が正しく表示されるように設定）
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // 2. 画面から送られてきたパラメータ（ジャンルIDと名前）を受け取る
        // 例：genreId="1", genreName="和食" などのデータが届く
        String genreIdStr = request.getParameter("genreId");
        String genreName = request.getParameter("genreName");

        try {
            // ジャンルIDがちゃんと届いているかチェック
            if (genreIdStr != null) {
                // 文字列で届いたIDを計算や検索に使えるように数値（int）に変換
                int genreId = Integer.parseInt(genreIdStr);

                // 3. データベース操作クラス（DAO）を使って、該当するジャンルの料理を検索
                UserDAO dao = new UserDAO();
                List<CookMenu> list = dao.getMenusByGenreId(genreId);

                // 4. 検索結果を次の画面（JSP）へ渡す準備
                // 取得した料理リストを "menuList" という名前で保存
                request.setAttribute("menuList", list);
                // 画面のタイトルとしてジャンル名（例：和食）を保存
                request.setAttribute("pageTitle", genreName);

                // 5. 共通の料理一覧表示画面（Us_Recipes.jsp）を呼び出す
                // 検索結果や店舗別リストと同じJSPを「再利用」して表示します
                request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // もしエラー（DB接続失敗など）が発生した場合は、原因を出力して元のジャンル選択画面に戻す
            e.printStackTrace();
            response.sendRedirect("main/Us_RecipeGenre.jsp");
        }
    }
}