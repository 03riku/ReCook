package admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Product;
import dao.AdminDAO; // Đã đổi từ ProductDAO sang AdminDAO

@WebServlet("/product/Admin_ProductServlet")
public class Admin_ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Khởi tạo AdminDAO thay vì ProductDAO
    private AdminDAO adminDao = new AdminDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String searchName = request.getParameter("searchName");

        try {
            List<Product> products;
            // Gọi hàm từ adminDao
            if (searchName != null && !searchName.trim().isEmpty()) {
                products = adminDao.searchProducts(searchName.trim());
            } else {
                products = adminDao.getAllProducts();
            }
            List<String> categories = adminDao.getAllCategories();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("lastSearch", searchName);

            request.getRequestDispatcher("/admin/product/Ad_Product.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "error");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
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

                // Gọi hàm kiểm tra từ adminDao
                if (adminDao.isProductNameExists(name, productId)) {
                    request.setAttribute("error", "既に存在しています。");

                    Product p = new Product(productId, name, category);
                    request.setAttribute("editingProduct", p);

                    doGet(request, response);
                    return;
                }

                Product p = new Product(productId, name, category);
                // Gọi hàm lưu từ adminDao
                adminDao.saveOrUpdate(p);

                request.setAttribute("message", "更新しました。");

            } else if ("bulkDelete".equals(action)) {
                String[] deleteIds = request.getParameterValues("deleteIds");
                if (deleteIds != null && deleteIds.length > 0) {
                    // Gọi hàm xóa từ adminDao
                    adminDao.bulkDelete(deleteIds);
                    request.setAttribute("message", "削除しました。");
                }
            }

            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "エラーが発生しました: " + e.getMessage());
            doGet(request, response);
        }
    }
}