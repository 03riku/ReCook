package admin;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; // Sessionを利用
import javax.servlet.http.Part;

import bean.CookMenu;
import bean.Genre;
import bean.Product;
import dao.AdminDAO;

/**
 * 料理管理（一覧、追加、編集、削除）および画像アップロードを処理するサーブレット
 */
@WebServlet("/admin/recipe/RecipeServlet")
// ファイルアップロード設定 (サイズ制限など)
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class Admin_RecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 画像保存先のワークスペースパス (環境に合わせて変更が必要)
    // 注意: Eclipse上で再デプロイするとサーバー上の画像が消えるため、ソースフォルダにも保存する設定
    private static final String WORKSPACE_PATH = "C:/Users/t_dat/git/ReCook/WebContent/pic";

    /**
     * GETリクエスト: 料理一覧画面の表示
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // --- フラッシュメッセージ処理 (PRGパターン) ---
        // セッションからメッセージを取得し、リクエスト属性に移してからセッションから削除する
        // これにより、画面更新(F5)時にメッセージが消える挙動を実現
        HttpSession session = request.getSession();
        String sessionMsg = (String) session.getAttribute("message");
        String sessionErr = (String) session.getAttribute("error");

        if (sessionMsg != null) {
            request.setAttribute("message", sessionMsg);
            session.removeAttribute("message"); // 取得後すぐに削除
        }
        if (sessionErr != null) {
            request.setAttribute("error", sessionErr);
            session.removeAttribute("error"); // 取得後すぐに削除
        }
        // -----------------------------------------------------------

        AdminDAO dao = new AdminDAO();
        String searchName = request.getParameter("searchName");

        try {
            // 1. ジャンル一覧の取得 (ドロップダウン用)
            List<Genre> genres = dao.getAllGenresForRecipe();
            List<String> categoryNames = new ArrayList<>();
            for (Genre g : genres) categoryNames.add(g.getGenreName());
            request.setAttribute("categories", categoryNames);

            // 2. 商品一覧の取得 (オートコンプリート用JSONデータの生成)
            // Javaのリストを JavaScript の配列形式文字列 ("[ "A", "B" ]") に変換
            List<Product> allProducts = dao.getAllProducts();
            StringBuilder jsonProd = new StringBuilder("[");
            for(int i=0; i<allProducts.size(); i++){
                // JSエラー回避のためダブルクォートをエスケープ
                String pName = allProducts.get(i).getProductName().replace("\"", "\\\"");
                jsonProd.append("\"").append(pName).append("\"");
                if(i < allProducts.size() - 1) jsonProd.append(",");
            }
            jsonProd.append("]");
            request.setAttribute("jsonAllProductNames", jsonProd.toString());

            // 3. 料理一覧の取得
            List<CookMenu> fullRecipes = dao.getAllRecipesFull(searchName);
            request.setAttribute("recipeObjects", fullRecipes);

            // 一覧表示用にデータを簡易的なString配列リストに変換
            List<String[]> recipeStringData = new ArrayList<>();
            for (CookMenu m : fullRecipes) {
                String[] row = new String[4];
                row[0] = String.valueOf(m.getMenuItemId());
                row[1] = m.getDishName();
                row[2] = m.getGenreName() != null ? m.getGenreName() : "";
                row[3] = String.valueOf(m.getCookTime());
                recipeStringData.add(row);
            }
            request.setAttribute("recipes", recipeStringData);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "エラー: " + e.getMessage());
        }

        request.getRequestDispatcher("/admin/recipe/Ad_recipe.jsp").forward(request, response);
    }

    /**
     * POSTリクエスト: 料理の保存(追加・更新)と削除
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(); // メッセージ保存用セッション
        AdminDAO dao = new AdminDAO();
        String action = request.getParameter("action");

        try {
            // --- 保存処理 (追加 / 更新) ---
            if ("save".equals(action)) {
                // フォームデータの取得
                String idStr = request.getParameter("recipeId");
                String name = request.getParameter("recipeName");
                String categoryName = request.getParameter("category");
                String timeStr = request.getParameter("cookTime");
                String desc = request.getParameter("recipeDescription");

                // 商品タグ（複数）の取得
                String[] productNamesArr = request.getParameterValues("productNames");
                List<String> productNames = (productNamesArr != null) ? Arrays.asList(productNamesArr) : new ArrayList<>();

                CookMenu menu = new CookMenu();
                if (idStr != null && !idStr.isEmpty()) {
                    menu.setMenuItemId(Integer.parseInt(idStr));
                }
                menu.setDishName(name);
                menu.setCookTime((timeStr != null && !timeStr.isEmpty()) ? Integer.parseInt(timeStr) : 0);
                menu.setDescription(desc);

                // --- 画像アップロード処理 ---
                Part filePart = request.getPart("recipeImage");

                // ファイルが選択されている場合のみ保存処理を行う
                if (filePart != null && filePart.getSize() > 0) {
                    // ファイル名の取得
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                    // 1. サーバーのデプロイ先に保存 (実行中のアプリから参照するため)
                    String serverPath = getServletContext().getRealPath("/pic");
                    saveFile(filePart, serverPath, fileName);

                    // 2. 開発ワークスペースに保存 (サーバー再起動後もファイルを保持するため)
                    // 注: ローカル開発環境特有の処理です
                    File workspaceDir = new File(WORKSPACE_PATH);
                    if (workspaceDir.exists()) {
                        saveFile(filePart, WORKSPACE_PATH, fileName);
                    }
                    menu.setImage(fileName);
                } else {
                    // ファイル未選択時はnull (DAO側で画像の更新をスキップする判定に使用)
                    menu.setImage(null);
                }

                // トランザクション処理でDB保存 (料理情報 + 画像パス + 商品タグ)
                dao.saveRecipeTransaction(menu, categoryName, productNames);

                // 成功メッセージをセッションに保存
                session.setAttribute("message", "保存しました。");

            // --- 一括削除処理 ---
            } else if ("bulkDelete".equals(action)) {
                String[] deleteIds = request.getParameterValues("deleteIds");
                if (deleteIds != null && deleteIds.length > 0) {
                    dao.deleteRecipes(deleteIds);
                    session.setAttribute("message", "削除しました。");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // エラーメッセージをセッションに保存
            session.setAttribute("error", "エラー: " + e.getMessage());
        }

        // --- Post-Redirect-Get (PRG) パターン ---
        // 処理完了後はリダイレクトを行い、二重送信を防ぐ
        response.sendRedirect(request.getContextPath() + "/admin/recipe/RecipeServlet");
    }

    /**
     * 指定されたディレクトリにファイルを保存するヘルパーメソッド
     */
    private void saveFile(Part filePart, String outputDir, String fileName) throws IOException {
        File dir = new File(outputDir);
        if (!dir.exists()) dir.mkdirs(); // ディレクトリがない場合は作成
        File file = new File(outputDir, fileName);

        // 入力ストリームからファイルへコピー
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }
    }
}