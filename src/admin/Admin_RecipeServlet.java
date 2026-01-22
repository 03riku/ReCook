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
import javax.servlet.http.Part;

import bean.CookMenu;
import bean.Genre;
import bean.Product;
import dao.AdminDAO;

@WebServlet("/admin/recipe/RecipeServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class Admin_RecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // =========================================================================
    // ★ 重要：ワークスペース（ソースコード）への保存パス
    // 指定されたパスを設定しました。Javaではパス区切りに "/" を使うのが一般的です。
    // =========================================================================
    private static final String WORKSPACE_PATH = "C:/Users/t_dat/git/ReCook/WebContent/pic";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        AdminDAO dao = new AdminDAO();
        String searchName = request.getParameter("searchName");

        try {
            // 1. ジャンル一覧を取得（ドロップダウン用）
            List<Genre> genres = dao.getAllGenresForRecipe();
            List<String> categoryNames = new ArrayList<>();
            for (Genre g : genres) categoryNames.add(g.getGenreName());
            request.setAttribute("categories", categoryNames);

            // 2. 全商品リストを取得（オートコンプリートとバリデーション用）
            List<Product> allProducts = dao.getAllProducts();
            // 商品リストをJSON形式の文字列に変換: ["肉", "魚", "卵"...]
            StringBuilder jsonProd = new StringBuilder("[");
            for(int i=0; i<allProducts.size(); i++){
                String pName = allProducts.get(i).getProductName().replace("\"", "\\\"");
                jsonProd.append("\"").append(pName).append("\"");
                if(i < allProducts.size() - 1) jsonProd.append(",");
            }
            jsonProd.append("]");
            request.setAttribute("jsonAllProductNames", jsonProd.toString());

            // 3. レシピ一覧を取得（表示用）
            List<CookMenu> fullRecipes = dao.getAllRecipesFull(searchName);
            request.setAttribute("recipeObjects", fullRecipes);

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

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        AdminDAO dao = new AdminDAO();
        String action = request.getParameter("action");

        try {
            if ("save".equals(action)) {
                // --- データの受け取り ---
                String idStr = request.getParameter("recipeId");
                String name = request.getParameter("recipeName");
                String categoryName = request.getParameter("category");
                String timeStr = request.getParameter("cookTime");
                String desc = request.getParameter("recipeDescription");

                String[] productNamesArr = request.getParameterValues("productNames");
                List<String> productNames = (productNamesArr != null) ? Arrays.asList(productNamesArr) : new ArrayList<>();

                CookMenu menu = new CookMenu();
                if (idStr != null && !idStr.isEmpty()) {
                    menu.setMenuItemId(Integer.parseInt(idStr));
                }
                menu.setDishName(name);
                menu.setCookTime((timeStr != null && !timeStr.isEmpty()) ? Integer.parseInt(timeStr) : 0);
                menu.setDescription(desc);

                // --- 画像ファイルの処理（2箇所に保存） ---
                Part filePart = request.getPart("recipeImage");

                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                    // 場所1：サーバーのデプロイパス（即時表示のため）
                    String serverPath = getServletContext().getRealPath("/pic");
                    saveFile(filePart, serverPath, fileName);

                    // 場所2：指定されたワークスペースパス（永続保存のため）
                    File workspaceDir = new File(WORKSPACE_PATH);

                    // パスが存在しない場合は作成を試みる
                    if (!workspaceDir.exists()) {
                         workspaceDir.mkdirs();
                    }

                    if (workspaceDir.exists() && workspaceDir.isDirectory()) {
                        saveFile(filePart, WORKSPACE_PATH, fileName);
                        System.out.println("ワークスペースに画像を保存しました: " + WORKSPACE_PATH + File.separator + fileName);
                    } else {
                        System.out.println("警告: WORKSPACE_PATH が見つかりません。パスを確認してください: " + WORKSPACE_PATH);
                    }

                    menu.setImage(fileName);
                } else {
                    // 編集モードで新しい画像が選択されていない場合、元の画像を維持（nullをセット）
                    menu.setImage(null);
                }

                // DBに保存
                dao.saveRecipeTransaction(menu, categoryName, productNames);
                request.setAttribute("message", "保存しました。");

            } else if ("bulkDelete".equals(action)) {
                // --- 一括削除処理 ---
                String[] deleteIds = request.getParameterValues("deleteIds");
                if (deleteIds != null && deleteIds.length > 0) {
                    dao.deleteRecipes(deleteIds);
                    request.setAttribute("message", "削除しました。");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "エラー: " + e.getMessage());
        }

        doGet(request, response);
    }

    // ファイル保存用のヘルパーメソッド
    private void saveFile(Part filePart, String outputDir, String fileName) throws IOException {
        File dir = new File(outputDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        File file = new File(outputDir, fileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }
    }
}