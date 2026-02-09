package admin;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import bean.CookMenu;
import bean.Genre;
import bean.Product;
import dao.AdminDAO;

/**
 * 料理（レシピ）管理機能のコントローラー
 * 画像アップロードに対応するため @MultipartConfig アノテーションが必要
 */
@WebServlet("/admin/recipe/RecipeServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class Admin_RecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /** 画像保存先ディレクトリ名 (WebContent直下) */
    private static final String UPLOAD_DIR = "pic";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        AdminDAO dao = new AdminDAO();

        try {
            // 1. 検索キーワード取得
            String searchName = request.getParameter("searchName");
            if (searchName != null) searchName = searchName.trim();

            // 2. レシピ一覧データの取得 (検索対応)
            List<CookMenu> fullRecipes = dao.getAllRecipesFull(searchName);

            // 表示用にデータを加工 (List<String[]>) - JSPでの表示互換性のため
            List<String[]> viewList = new ArrayList<>();
            for (CookMenu m : fullRecipes) {
                viewList.add(new String[] {
                    String.valueOf(m.getMenuItemId()),
                    m.getDishName(),
                    m.getGenreName(),
                    String.valueOf(m.getCookTime())
                });
            }
            request.setAttribute("recipes", viewList);      // リスト表示用 (簡易データ)
            request.setAttribute("recipeObjects", fullRecipes); // 詳細データ (編集用)

            // 3. フォーム用のデータ準備 (ジャンル一覧)
            List<Genre> genres = dao.getAllGenresForRecipe();
            List<String> genreNames = new ArrayList<>();
            for(Genre g : genres) genreNames.add(g.getGenreName());
            request.setAttribute("categories", genreNames);

            // 4. オートコンプリート用の全商品リスト (JSON文字列として渡す)
            List<Product> allProducts = dao.getAllProducts();
            StringBuilder jsonProd = new StringBuilder("[");
            for (int i = 0; i < allProducts.size(); i++) {
                jsonProd.append("\"").append(allProducts.get(i).getProductName().replace("\"", "\\\"")).append("\"");
                if (i < allProducts.size() - 1) jsonProd.append(",");
            }
            jsonProd.append("]");
            request.setAttribute("jsonAllProductNames", jsonProd.toString());

            // 5. フラッシュメッセージの処理
            String msg = (String) session.getAttribute("message");
            String err = (String) session.getAttribute("error");
            if (msg != null) { request.setAttribute("message", msg); session.removeAttribute("message"); }
            if (err != null) { request.setAttribute("error", err); session.removeAttribute("error"); }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "システムエラーが発生しました: " + e.getMessage());
        }

        request.getRequestDispatcher("/admin/recipe/Ad_recipe.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        AdminDAO dao = new AdminDAO();

        try {
            if ("save".equals(action)) {
                // --- 保存・更新処理 ---

                // パラメータ取得
                String idStr = request.getParameter("recipeId");
                String name = request.getParameter("recipeName");
                String category = request.getParameter("category");
                String timeStr = request.getParameter("cookTime");
                String desc = request.getParameter("recipeDescription");

                // 使用する商品（複数）を取得
                String[] productNames = request.getParameterValues("productNames");
                List<String> productList = new ArrayList<>();
                if (productNames != null) {
                    for (String p : productNames) productList.add(p);
                }

                int cookTime = 0;
                try { cookTime = Integer.parseInt(timeStr); } catch(NumberFormatException e) {}

                // 画像アップロード処理
                String fileName = null;
                Part filePart = request.getPart("recipeImage");

                // 新しい画像が選択されている場合のみ保存処理を行う
                if (filePart != null && filePart.getSize() > 0) {
                    // 保存先パスの構築
                    String applicationPath = request.getServletContext().getRealPath("");
                    String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

                    // ディレクトリがなければ作成
                    File uploadDir = new File(uploadFilePath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    // ファイル名の生成 (重複防止のためUUIDを使用)
                    String originalFileName = getFileName(filePart);
                    String fileExt = "";
                    if (originalFileName.contains(".")) {
                        fileExt = originalFileName.substring(originalFileName.lastIndexOf("."));
                    }
                    fileName = UUID.randomUUID().toString() + fileExt;

                    // ファイル書き込み (try-with-resourcesで確実にcloseする)
                    File file = new File(uploadFilePath + File.separator + fileName);
                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new IOException("画像の保存に失敗しました。");
                    }
                } else {
                    // 画像が選択されていない場合、編集モードなら既存の画像名を維持するロジックが必要
                    // (DAO側で画像名がnullなら更新しないように制御している前提)
                    fileName = null;
                }

                // Bean作成
                CookMenu menu = new CookMenu();
                if (idStr != null && !idStr.isEmpty()) {
                    menu.setMenuItemId(Integer.parseInt(idStr));
                }
                menu.setDishName(name);
                menu.setCookTime(cookTime);
                menu.setDescription(desc);
                menu.setImage(fileName); // 新しい画像があればセット、なければnull

                // トランザクション保存実行 (レシピ本体 + ジャンル紐付け + 商品紐付け)
                dao.saveRecipeTransaction(menu, category, productList);

                session.setAttribute("message", "レシピを保存しました。");

            } else if ("bulkDelete".equals(action)) {
                // --- 一括削除処理 ---
                String[] deleteIds = request.getParameterValues("deleteIds");
                if (deleteIds != null && deleteIds.length > 0) {
                    // 必要であればここで画像の削除処理も入れる
                    // (DBから画像名を取得 -> File.delete())

                    dao.deleteRecipes(deleteIds);
                    session.setAttribute("message", deleteIds.length + "件のレシピを削除しました。");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "エラーが発生しました: " + e.getMessage());
        }

        // 処理完了後はリダイレクト (二重送信防止)
        response.sendRedirect(request.getContextPath() + "/admin/recipe/RecipeServlet");
    }

    /**
     * Partからファイル名を取得するユーティリティメソッド
     * ブラウザごとの挙動の違いを吸収します
     */
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}