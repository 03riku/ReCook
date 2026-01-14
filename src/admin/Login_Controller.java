package admin;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Admin;
import dao.AdminDAO;
import tool.CommonServlet;

@WebServlet("/Ad_LoginServlet")
public class Login_Controller extends CommonServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void get(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        // Luôn chuyển hướng đến trang đăng nhập nếu truy cập bằng GET
        resp.sendRedirect(req.getContextPath() + "/admin/account/Ad_login.jsp");
    }

    @Override
    protected void post(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        // 1. Lấy và kiểm tra tham số (Khắc phục NullPointerException)
        String adminIdStr = request.getParameter("username") != null ?
                            request.getParameter("username").trim() : "";

        String adminPass = request.getParameter("password") != null ?
                           request.getParameter("password").trim() : "";

        String redirectURL;
        String contextPath = request.getContextPath(); // Lấy Context Path một lần

        // 2. Kiểm tra trường trống (Logic đã ổn)
        if (adminIdStr.isEmpty() || adminPass.isEmpty()) {
             redirectURL = contextPath + "/admin/account/Ad_login.jsp?error=emptyfields";
             response.sendRedirect(redirectURL);
             return;
        }

        try {
            int adminId = Integer.parseInt(adminIdStr);

            AdminDAO dao = new AdminDAO();
            Admin admin = dao.findAdmin(adminId, adminPass); // Giả định AdminDAO hoạt động đúng

            if (admin != null) {
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("currentAdmin", admin);

                // Đường dẫn thành công: Đảm bảo khớp với WebContent/admin/product/Ad_product.jsp
                redirectURL = contextPath + "/admin/product/Ad_Product.jsp";
                response.sendRedirect(redirectURL);
                return;

            } else {
                // Đăng nhập thất bại (ID/Pass không khớp)
                redirectURL = contextPath + "/admin/account/Ad_login.jsp?error=invalid";
            }

        } catch (NumberFormatException e) {
            // Lỗi ID không phải là số
            redirectURL = contextPath + "/admin/account/Ad_login.jsp?error=notnumber";

        } catch (Exception e) {
            // Lỗi hệ thống/CSDL (Được bắt bởi CommonServlet và hiển thị)
            throw e;
        }

        // Redirect cho trường hợp thất bại (Đã được gán redirectURL)
        response.sendRedirect(redirectURL);
    }
}