package admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Store;
import dao.AdminDAO;

/**
 * 店舗管理機能（一覧表示、検索、追加、編集、削除）を制御するサーブレット
 */
@WebServlet("/admin/store/StoreServlet")
public class Admin_StoreServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * GETリクエスト：店舗一覧の表示（検索含む）および編集・削除確認モードの制御
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 文字コード指定 (検索キーワードの文字化け防止)
        request.setCharacterEncoding("UTF-8");

        AdminDAO dao = new AdminDAO();
        try {
            // 1. 検索キーワードの取得
            String keyword = request.getParameter("keyword");
            List<Store> list;

            // 2. 検索キーワードの有無で処理を分岐
            if (keyword != null && !keyword.trim().isEmpty()) {
                // 検索実行 (DAOに searchStores メソッドが必要)
                list = dao.searchStores(keyword.trim());
            } else {
                // 全件取得
                list = dao.selectAll();
            }

            // 3. 表示用にデータを加工 (List<String[]>)
            List<String[]> viewList = new ArrayList<>();
            if (list != null) {
                for (Store s : list) {
                    viewList.add(new String[]{String.valueOf(s.getStoreId()), s.getStoreName()});
                }
            }
            request.setAttribute("stores", viewList);

            // 4. 編集モードまたは削除確認モードの判定
            String editId = request.getParameter("editId");
            if (editId != null && !editId.isEmpty()) {
                try {
                    long id = Long.parseLong(editId);
                    request.setAttribute("selectedStore", dao.selectById(id));
                    request.setAttribute("mode", request.getParameter("mode")); // "confirm" など
                } catch (NumberFormatException e) {
                    // IDが不正な場合は無視
                }
            }

            // 5. フラッシュメッセージの処理
            HttpSession session = request.getSession();
            String msg = (String) session.getAttribute("message");
            if (msg != null) {
                request.setAttribute("message", msg);
                session.removeAttribute("message");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: システムエラーが発生しました。");
        }

        // JSPへフォワード
        request.getRequestDispatcher("/admin/store/Ad_store.jsp").forward(request, response);
    }

    /**
     * POSTリクエスト：データの追加・更新・削除処理
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String idStr = request.getParameter("storeId");
        String oldIdStr = request.getParameter("oldStoreId");
        HttpSession session = request.getSession();

        AdminDAO dao = new AdminDAO();

        try {
            // --- バリデーション ---
            if (idStr == null || idStr.length() != 10 || !idStr.matches("\\d+")) {
                session.setAttribute("message", "Error: 店舗IDは10桁の数字で入力してください。");
            } else if (idStr.startsWith("0")) {
                session.setAttribute("message", "Error: 最初の桁は０以外入力してください。");
            } else {
                long id = Long.parseLong(idStr);
                Store s = new Store(id, request.getParameter("storeName"), request.getParameter("storePassword"), request.getParameter("storeAddress"));

                if ("add".equals(action)) {
                    if (dao.isIdExists(id)) {
                        session.setAttribute("message", "Error: 店舗ID既に存在します。");
                    } else {
                        dao.insert(s);
                        session.setAttribute("message", "追加しました。");
                    }
                } else if ("update".equals(action)) {
                    long oldId = Long.parseLong(oldIdStr);
                    if (id != oldId && dao.isIdExists(id)) {
                        session.setAttribute("message", "Error: 店舗ID既に存在します。");
                    } else {
                        dao.update(s, oldId);
                        session.setAttribute("message", "更新しました。");
                    }
                } else if ("delete".equals(action)) {
                    dao.delete(id);
                    session.setAttribute("message", "削除しました。");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: システムエラー");
        }

        // 処理完了後はリダイレクト (検索キーワードがあれば維持したい場合はURLパラメータに追加が必要だが、
        // 基本的には一覧トップに戻る挙動で問題ない)
        response.sendRedirect(request.getContextPath() + "/admin/store/StoreServlet");
    }
}