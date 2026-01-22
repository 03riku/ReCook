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
import javax.servlet.http.HttpSession; // Import Session
import javax.servlet.http.Part;

import bean.CookMenu;
import bean.Genre;
import bean.Product;
import dao.AdminDAO;

@WebServlet("/admin/recipe/RecipeServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class Admin_RecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Đường dẫn lưu ảnh (Thay đổi tùy theo máy của bạn)
    private static final String WORKSPACE_PATH = "C:/Users/t_dat/git/ReCook/WebContent/pic";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // --- [MỚI] XỬ LÝ HIỂN THỊ THÔNG BÁO 1 LẦN (PRG PATTERN) ---
        HttpSession session = request.getSession();
        String sessionMsg = (String) session.getAttribute("message");
        String sessionErr = (String) session.getAttribute("error");

        if (sessionMsg != null) {
            request.setAttribute("message", sessionMsg);
            session.removeAttribute("message"); // Xóa ngay sau khi lấy
        }
        if (sessionErr != null) {
            request.setAttribute("error", sessionErr);
            session.removeAttribute("error"); // Xóa ngay sau khi lấy
        }
        // -----------------------------------------------------------

        AdminDAO dao = new AdminDAO();
        String searchName = request.getParameter("searchName");

        try {
            // 1. Genres
            List<Genre> genres = dao.getAllGenresForRecipe();
            List<String> categoryNames = new ArrayList<>();
            for (Genre g : genres) categoryNames.add(g.getGenreName());
            request.setAttribute("categories", categoryNames);

            // 2. Products (Autocomplete)
            List<Product> allProducts = dao.getAllProducts();
            StringBuilder jsonProd = new StringBuilder("[");
            for(int i=0; i<allProducts.size(); i++){
                String pName = allProducts.get(i).getProductName().replace("\"", "\\\"");
                jsonProd.append("\"").append(pName).append("\"");
                if(i < allProducts.size() - 1) jsonProd.append(",");
            }
            jsonProd.append("]");
            request.setAttribute("jsonAllProductNames", jsonProd.toString());

            // 3. Recipes
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
        HttpSession session = request.getSession(); // Dùng Session để lưu thông báo
        AdminDAO dao = new AdminDAO();
        String action = request.getParameter("action");

        try {
            if ("save".equals(action)) {
                // ... Nhận dữ liệu Form ...
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

                // ... Xử lý ảnh ...
                Part filePart = request.getPart("recipeImage");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                    // Lưu vào Server (Deploy path)
                    String serverPath = getServletContext().getRealPath("/pic");
                    saveFile(filePart, serverPath, fileName);

                    // Lưu vào Workspace (Source path)
                    File workspaceDir = new File(WORKSPACE_PATH);
                    if (workspaceDir.exists()) {
                        saveFile(filePart, WORKSPACE_PATH, fileName);
                    }
                    menu.setImage(fileName);
                } else {
                    menu.setImage(null);
                }

                // Lưu DB
                dao.saveRecipeTransaction(menu, categoryName, productNames);

                // [MỚI] Lưu thông báo vào Session
                session.setAttribute("message", "保存しました。");

            } else if ("bulkDelete".equals(action)) {
                String[] deleteIds = request.getParameterValues("deleteIds");
                if (deleteIds != null && deleteIds.length > 0) {
                    dao.deleteRecipes(deleteIds);
                    // [MỚI] Lưu thông báo vào Session
                    session.setAttribute("message", "削除しました。");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // [MỚI] Lưu lỗi vào Session
            session.setAttribute("error", "エラー: " + e.getMessage());
        }

        // [MỚI] Dùng sendRedirect để tránh resubmit khi F5 (PRG Pattern)
        // Redirect về chính trang này (sẽ gọi doGet)
        response.sendRedirect(request.getContextPath() + "/admin/recipe/RecipeServlet");
    }

    private void saveFile(Part filePart, String outputDir, String fileName) throws IOException {
        File dir = new File(outputDir);
        if (!dir.exists()) dir.mkdirs();
        File file = new File(outputDir, fileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }
    }
}