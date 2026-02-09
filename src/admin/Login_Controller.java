package admin;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import dao.AdminDAO;
import tool.CommonServlet;

/**
 * 管理者ログイン処理を制御するコントローラー
 */
@WebServlet("/Ad_LoginServlet")
public class Login_Controller extends CommonServlet {
    private static final long serialVersionUID = 1L;

    /**
     * GETリクエスト処理：ログイン画面を表示する
     */
    @Override
    protected void get(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        // ログインページへリダイレクト
        resp.sendRedirect(req.getContextPath() + "/admin/account/Ad_login.jsp");
    }

    /**
     * POSTリクエスト処理：ログイン認証を行う
     */
    @Override
    protected void post(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        // パラメータの取得（前後の空白を削除）
        String adminIdStr = request.getParameter("username") != null ?
                            request.getParameter("username").trim() : "";

        String adminPass = request.getParameter("password") != null ?
                           request.getParameter("password").trim() : "";

        String redirectURL;
        String contextPath = request.getContextPath();

        // 1. 入力チェック（必須項目が空でないか確認）
        if (adminIdStr.isEmpty() || adminPass.isEmpty()) {
             // 未入力エラーコードを付与してリダイレクト
             redirectURL = contextPath + "/admin/account/Ad_login.jsp?error=emptyfields";
             response.sendRedirect(redirectURL);
             return;
        }

        try {
            // 2. IDの数値変換と認証処理
            int adminId = Integer.parseInt(adminIdStr);

            AdminDAO dao = new AdminDAO();
            // DBに問い合わせて管理者を検索
            Admin admin = dao.findAdmin(adminId, adminPass);

            if (admin != null) {
                // --- 認証成功 (Authentication Success) ---

                // セッションの取得（なければ新規作成）
                HttpSession session = request.getSession();
                // セッションに管理者情報を保存（ログイン状態にする）
                session.setAttribute("currentAdmin", admin);

                // 商品管理画面（トップページ）へリダイレクト
                redirectURL = contextPath + "/product/Admin_ProductServlet";
                response.sendRedirect(redirectURL);
                return;

            } else {
                // --- 認証失敗 (Authentication Failed) ---
                // IDまたはパスワードが一致しない場合
                redirectURL = contextPath + "/admin/account/Ad_login.jsp?error=invalid";
            }

        } catch (NumberFormatException e) {
            // IDに数字以外が入力された場合のエラー処理
            redirectURL = contextPath + "/admin/account/Ad_login.jsp?error=notnumber";

        } catch (Exception e) {
            // その他の例外は上位へスロー
            throw e;
        }

        // エラーページ（ログイン画面）へリダイレクト
        response.sendRedirect(redirectURL);
    }
}