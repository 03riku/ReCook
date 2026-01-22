package admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; // Cần import thêm cái này

import bean.Product;
import dao.AdminDAO;

@WebServlet("/product/Admin_ProductServlet")
public class Admin_ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AdminDAO adminDao = new AdminDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // --- XỬ LÝ FLASH MESSAGE (Hiển thị 1 lần rồi xóa) ---
        HttpSession session = request.getSession();
        String sessionMessage = (String) session.getAttribute("message");
        if (sessionMessage != null) {
            // Chuyển từ Session sang Request để hiển thị ở JSP
            request.setAttribute("message", sessionMessage);
            // Xóa ngay khỏi Session để F5 không hiện lại
            session.removeAttribute("message");
        }
        // ----------------------------------------------------

        String searchName = request.getParameter("searchName");

        try {
            List<Product> products;

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
        HttpSession session = request.getSession(); // Lấy session

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

                // 1. Kiểm tra Category
                if (category == null || category.trim().isEmpty()) {
                    request.setAttribute("error", "カテゴリを入力してください。");
                    Product p = new Product(productId, name, category);
                    request.setAttribute("editingProduct", p);
                    // Lỗi validation thì dùng Forward để giữ lại dữ liệu form
                    doGet(request, response);
                    return;
                }

                // 2. Kiểm tra trùng tên
                if (adminDao.isProductNameExists(name, productId)) {
                    request.setAttribute("error", "既に存在しています。");
                    Product p = new Product(productId, name, category);
                    request.setAttribute("editingProduct", p);
                    // Lỗi validation thì dùng Forward
                    doGet(request, response);
                    return;
                }

                // 3. Lưu thành công
                Product p = new Product(productId, name, category);
                adminDao.saveOrUpdate(p);

                // --- SỬ DỤNG REDIRECT ---
                // Lưu thông báo vào Session thay vì Request
                session.setAttribute("message", "更新しました。");

                // Chuyển hướng về trang danh sách (Reset URL về dạng GET)
                response.sendRedirect(request.getContextPath() + "/product/Admin_ProductServlet");
                return; // Kết thúc doPost tại đây

            } else if ("bulkDelete".equals(action)) {
                String[] deleteIds = request.getParameterValues("deleteIds");
                if (deleteIds != null && deleteIds.length > 0) {
                    adminDao.bulkDelete(deleteIds);

                    // --- SỬ DỤNG REDIRECT ---
                    session.setAttribute("message", "削除しました。");
                    response.sendRedirect(request.getContextPath() + "/product/Admin_ProductServlet");
                    return;
                }
            }

            // Mặc định nếu không vào case nào thì load lại trang
            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "エラーが発生しました: " + e.getMessage());
            doGet(request, response);
        }
    }
}