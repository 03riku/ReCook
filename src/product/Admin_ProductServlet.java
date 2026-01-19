package product;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Product;
import dao.ProductDAO;

@WebServlet("/product/Admin_ProductServlet")
public class Admin_ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDao = new ProductDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String searchName = request.getParameter("searchName");

        try {
            List<Product> products;
            if (searchName != null && !searchName.trim().isEmpty()) {
                products = productDao.searchProducts(searchName.trim());
            } else {
                products = productDao.getAllProducts();
            }

            // Lấy danh sách category từ DB để hiển thị trong datalist
            List<String> categories = productDao.getAllCategories();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories); // Truyền danh sách category sang JSP
            request.setAttribute("lastSearch", searchName);

            request.getRequestDispatcher("/admin/product/Ad_Product.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải dữ liệu.");
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

                if (productDao.isProductNameExists(name, productId)) {
                    request.setAttribute("error", "既に存在しています。"); // Thông báo lỗi: Đã tồn tại

                    // Giữ lại dữ liệu đang nhập
                    Product p = new Product(productId, name, category);
                    request.setAttribute("editingProduct", p);

                    doGet(request, response);
                    return;
                }

                Product p = new Product(productId, name, category);
                productDao.saveOrUpdate(p);

                // Đặt thông báo thành công
                request.setAttribute("message", "更新しました。"); // Thông báo thành công: Đã cập nhật

            } else if ("bulkDelete".equals(action)) {
                String[] deleteIds = request.getParameterValues("deleteIds");
                if (deleteIds != null && deleteIds.length > 0) {
                    productDao.bulkDelete(deleteIds);
                    request.setAttribute("message", "削除しました。"); // Thông báo xóa thành công
                }
            }

            // Thay vì redirect, ta gọi lại doGet để tải lại dữ liệu MỚI NHẤT và hiển thị cùng thông báo
            // Lưu ý: Forward sẽ giữ lại attribute 'message' trong request
            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "エラーが発生しました: " + e.getMessage());
            doGet(request, response);
        }
    }
}