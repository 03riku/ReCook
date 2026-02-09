package admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Product;
import dao.AdminDAO;

/**
 * 商品管理（一覧表示、検索、追加、更新、削除）を行うサーブレット
 */
@WebServlet("/product/Admin_ProductServlet")
public class Admin_ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AdminDAO adminDao = new AdminDAO();

    /**
     * GETリクエスト処理：商品一覧画面の表示
     * - 検索機能
     * - リダイレクト後のメッセージ表示（Flash Scope的な処理）
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // --- リダイレクト後のメッセージ処理 ---
        // doPostで保存されたセッションメッセージを取得し、リクエスト属性に移す
        // これにより、画面更新(F5)してもメッセージが消える（Flash Message）
        HttpSession session = request.getSession();
        String sessionMessage = (String) session.getAttribute("message");
        if (sessionMessage != null) {
            request.setAttribute("message", sessionMessage);
            session.removeAttribute("message"); // 一度表示したら削除
        }

        // 検索キーワードの取得
        String searchName = request.getParameter("searchName");

        try {
            List<Product> products;

            // 検索キーワードの有無によって処理を分岐
            if (searchName != null && !searchName.trim().isEmpty()) {
                // 部分一致検索
                products = adminDao.searchProducts(searchName.trim());
            } else {
                // 全件取得
                products = adminDao.getAllProducts();
            }
            // カテゴリドロップダウン用のリスト取得
            List<String> categories = adminDao.getAllCategories();

            // JSPへデータを渡す
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("lastSearch", searchName);

            // 一覧画面へフォワード
            request.getRequestDispatcher("/admin/product/Ad_Product.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "error");
        }
    }

    /**
     * POSTリクエスト処理：データの保存（追加・更新）および削除
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession(); // セッション取得

        try {
            // --- 保存処理 (追加 / 更新) ---
            if ("save".equals(action)) {
                String idStr = request.getParameter("productId");
                String name = request.getParameter("productName");
                String category = request.getParameter("category");

                int productId = 0;
                if (idStr != null && !idStr.trim().isEmpty()) {
                    try {
                        productId = Integer.parseInt(idStr);
                    } catch (NumberFormatException e) {
                        productId = 0;
                    }
                }

                // 1. カテゴリの入力チェック
                if (category == null || category.trim().isEmpty()) {
                    request.setAttribute("error", "カテゴリを入力してください。");

                    // エラー時は入力値を保持して画面を再表示（フォワード）
                    Product p = new Product(productId, name, category);
                    request.setAttribute("editingProduct", p);
                    doGet(request, response);
                    return;
                }

                // 2. 商品名の重複チェック
                if (adminDao.isProductNameExists(name, productId)) {
                    request.setAttribute("error", "既に存在しています。");

                    // エラー時は入力値を保持して画面を再表示（フォワード）
                    Product p = new Product(productId, name, category);
                    request.setAttribute("editingProduct", p);
                    doGet(request, response);
                    return;
                }

                // 3. DB保存処理実行
                Product p = new Product(productId, name, category);
                adminDao.saveOrUpdate(p);

                // --- Post-Redirect-Get (PRG) パターン ---
                // 二重送信を防ぐため、処理成功後はリダイレクトを行う。
                // メッセージはリクエストではなくセッションに保存する。
                session.setAttribute("message", "更新しました。");

                // 一覧画面へリダイレクト (GETリクエストが発生)
                response.sendRedirect(request.getContextPath() + "/product/Admin_ProductServlet");
                return; // 処理終了

            // --- 一括削除処理 ---
            } else if ("bulkDelete".equals(action)) {
                String[] deleteIds = request.getParameterValues("deleteIds");
                if (deleteIds != null && deleteIds.length > 0) {
                    adminDao.bulkDelete(deleteIds);

                    // 削除完了後、メッセージをセッションに保存してリダイレクト
                    session.setAttribute("message", "削除しました。");
                    response.sendRedirect(request.getContextPath() + "/product/Admin_ProductServlet");
                    return;
                }
            }

            // アクションが不明な場合は一覧を再表示
            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();

            // 【修正箇所】: エラーメッセージの内容をチェックして、日本語に変換する
            // FK_STORE_PRODUCT_PRODUCT というエラーコードが含まれていたら、指定のメッセージを表示
            if (errorMsg != null && (errorMsg.contains("FK_STORE_PRODUCT_PRODUCT") || errorMsg.contains("store_product"))) {
                request.setAttribute("error", "この商品は既にスーパーが使っています。");
            } else {
                // その他のエラーの場合
                request.setAttribute("error", "エラーが発生しました: " + errorMsg);
            }

            // エラー時はフォワードして画面を表示（リダイレクトしない）
            doGet(request, response);
        }
    }
}