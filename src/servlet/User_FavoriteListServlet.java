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
import dao.UserDAO;

/**
 * 【お気に入り一覧表示サーブレット】
 * ユーザーが登録したお気に入り料理をデータベースから取り出し、
 * 一覧画面（Us_Recipes.jsp）に表示する橋渡しを行います。
 */
@WebServlet("/user/User_FavoriteList")
public class User_FavoriteListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. ログイン状態の確認
        // セッション（サーバー上の個人用メモ帳）からログインユーザー情報を取り出す
        HttpSession session = request.getSession();
        GeneralUser user = (GeneralUser) session.getAttribute("loginUser");

        // ログインしていない（情報が空）場合は、安全のためログイン画面へ飛ばす
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp");
            return; // ここで処理を終了
        }

        try {
            // 2. データベースからデータの取得
            UserDAO dao = new UserDAO();

            // ログイン中のユーザーIDを使って、その人の「お気に入り料理リスト」をDBから取得
            List<CookMenu> list = dao.getFavoriteMenus(user.getUserId());

            // 3. 画面（JSP）へ渡すデータの準備
            // 取得したリストを "menuList" という名前でセット（JSPの c:forEach で使う）
            request.setAttribute("menuList", list);

            // 画面のヘッダーに表示するタイトルを指定
            request.setAttribute("pageTitle", "お気に入りメニュー");

            // 4. 画面の切り替え
            // 料理一覧を表示するための共通レイアウト（Us_Recipes.jsp）を呼び出す
            request.getRequestDispatcher("/user/main/Us_Recipes.jsp").forward(request, response);

        } catch (Exception e) {
            // もしエラー（DB接続失敗など）が起きたら、ログを出力してアカウント画面へ戻す
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/main/Us_Account.jsp");
        }
    }
}