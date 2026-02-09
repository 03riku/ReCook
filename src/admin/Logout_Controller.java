package admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 管理者ログアウト処理を行うコントローラー
 */
@WebServlet("/admin/logout")
public class Logout_Controller extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * GETリクエスト: ログアウト確認画面などを表示する場合に使用
     * (現在の実装では確認画面のJSPへフォワードしています)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ログアウト確認画面 (JSP) へフォワード
        // 注意: /WEB-INF/ 配下のファイルは直接URLでアクセスできないため、フォワードを使用
        request.getRequestDispatcher("/WEB-INF/admin/Ad_logout.jsp").forward(request, response);
    }

    /**
     * POSTリクエスト: 実際のログアウト処理（セッション無効化）を実行
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 現在のセッションを取得
        // 引数 false: セッションが存在しない場合、新規作成せずに null を返す
        HttpSession session = request.getSession(false);

        if (session != null) {
            // セッションを無効化（保存されているすべての属性を削除し、ログアウト状態にする）
            session.invalidate();
        }

        // 処理完了後、ログイン画面へリダイレクト
        response.sendRedirect(request.getContextPath() + "/admin/account/Ad_login.jsp");
    }

}