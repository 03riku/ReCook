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
        resp.sendRedirect(req.getContextPath() + "/admin/account/Ad_login.jsp");
    }

    @Override
    protected void post(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String adminIdStr = request.getParameter("username") != null ?
                            request.getParameter("username").trim() : "";

        String adminPass = request.getParameter("password") != null ?
                           request.getParameter("password").trim() : "";

        String redirectURL;
        String contextPath = request.getContextPath();

        if (adminIdStr.isEmpty() || adminPass.isEmpty()) {
             redirectURL = contextPath + "/admin/account/Ad_login.jsp?error=emptyfields";
             response.sendRedirect(redirectURL);
             return;
        }

        try {
            int adminId = Integer.parseInt(adminIdStr);

            AdminDAO dao = new AdminDAO();
            Admin admin = dao.findAdmin(adminId, adminPass);

            if (admin != null) {
                HttpSession session = request.getSession();
                session.setAttribute("currentAdmin", admin);

                redirectURL = contextPath + "/product/Admin_ProductServlet";
                response.sendRedirect(redirectURL);
                return;

            } else {
                redirectURL = contextPath + "/admin/account/Ad_login.jsp?error=invalid";
            }

        } catch (NumberFormatException e) {
            redirectURL = contextPath + "/admin/account/Ad_login.jsp?error=notnumber";

        } catch (Exception e) {
            throw e;
        }

        response.sendRedirect(redirectURL);
    }
}