package tool;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 共通エラーページへの遷移を行うサーブレット。
 * 例外処理時に /error にリダイレクトすることでエラーページを表示できる。
 */
@WebServlet(urlPatterns = { "/error" })
public class Error extends CommonServlet {

    /**
     * GETリクエストでエラーページに遷移する。
     * 例: resp.sendRedirect("/error") によって呼び出される。
     */
    @Override
    protected void get(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        // error.jsp にフォワードしてエラー画面を表示
        req.getRequestDispatcher("ERRO001.jsp").forward(req, resp);
    }

    /**
     * POSTリクエストが来た場合（基本的には使わない）
     */
    @Override
    protected void post(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        // 必要があれば POST に対するエラー処理もここで実装可能
        // 今は未実装のため、GETと同様に処理してもよい
        get(req, resp);
    }
}
