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
import dao.AdminDAO; // AdminDAOを使用

/**
 * 店舗管理機能（一覧表示、追加、編集、削除）を制御するサーブレット
 */
@WebServlet("/admin/store/StoreServlet")
public class Admin_StoreServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * GETリクエスト：店舗一覧の表示および編集・削除確認モードの制御
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        AdminDAO dao = new AdminDAO();
        try {
            // 1. 全店舗データの取得
            List<Store> list = dao.selectAll();

            // 表示用にデータを加工 (List<String[]>)
            List<String[]> viewList = new ArrayList<>();
            for (Store s : list) viewList.add(new String[]{String.valueOf(s.getStoreId()), s.getStoreName()});
            request.setAttribute("stores", viewList);

            // 2. 編集モードまたは削除確認モードの判定
            // URLパラメータに 'editId' がある場合、その店舗の詳細を取得してフォームにセットする
            String editId = request.getParameter("editId");
            if (editId != null) {
                request.setAttribute("selectedStore", dao.selectById(Long.parseLong(editId)));
                request.setAttribute("mode", request.getParameter("mode")); // "confirm" などのモード判定用
            }

            // 3. フラッシュメッセージの処理
            // doPostからリダイレクトされた際にセッションに保存されたメッセージを表示用に取得
            HttpSession session = request.getSession();
            request.setAttribute("message", session.getAttribute("message"));
            session.removeAttribute("message"); // 一度表示したら削除

        } catch (Exception e) { e.printStackTrace(); }

        // JSPへフォワード
        request.getRequestDispatcher("/admin/store/Ad_store.jsp").forward(request, response);
    }

    /**
     * POSTリクエスト：データの追加・更新・削除処理
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // パラメータの取得
        String action = request.getParameter("action");     // 処理の種類 (add, update, delete)
        String idStr = request.getParameter("storeId");     // 入力された店舗ID
        String oldIdStr = request.getParameter("oldStoreId"); // 更新前の店舗ID（更新時のみ使用）
        HttpSession session = request.getSession();

        // AdminDAOの初期化
        AdminDAO dao = new AdminDAO();

        try {
            // --- バリデーション (入力チェック) ---

            // チェック1: IDがnull、10桁でない、または数字以外が含まれている場合
            if (idStr == null || idStr.length() != 10 || !idStr.matches("\\d+")) {
                session.setAttribute("message", "Error: 店舗IDは10桁の数字で入力してください。");

            // チェック2: IDの先頭が '0' で始まる場合 (Javaの数値変換での予期せぬ挙動やビジネスルール違反を防ぐ)
            } else if (idStr.startsWith("0")) {
                session.setAttribute("message", "Error: 最初の桁は０以外入力してください。");

            } else {
                // バリデーション通過後、数値に変換
                long id = Long.parseLong(idStr);
                // 入力データからStoreオブジェクトを作成
                Store s = new Store(id, request.getParameter("storeName"), request.getParameter("storePassword"), request.getParameter("storeAddress"));

                // --- アクションごとの処理 ---

                if ("add".equals(action)) {
                    // [新規追加]
                    // ID重複チェック
                    if (dao.isIdExists(id)) {
                        session.setAttribute("message", "Error: 店舗ID既に存在します。");
                    } else {
                        dao.insert(s);
                        session.setAttribute("message", "追加しました。");
                    }

                } else if ("update".equals(action)) {
                    // [更新]
                    long oldId = Long.parseLong(oldIdStr);

                    // IDを変更する場合のみ重複チェックを行う
                    // (変更後のIDが、自分以外の他の店舗IDと被っていないか)
                    if (id != oldId && dao.isIdExists(id)) {
                        session.setAttribute("message", "Error: 店舗ID既に存在します。");
                    } else {
                        dao.update(s, oldId);
                        session.setAttribute("message", "更新しました。");
                    }

                } else if ("delete".equals(action)) {
                    // [削除]
                    dao.delete(id);
                    session.setAttribute("message", "削除しました。");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: システムエラー");
        }

        // 処理完了後、一覧画面へリダイレクト (Post-Redirect-Getパターン)
        response.sendRedirect(request.getContextPath() + "/admin/store/StoreServlet");
    }
}