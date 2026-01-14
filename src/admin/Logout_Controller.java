package admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/logout")

public class Logout_Controller extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)

            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/admin/Ad_logout.jsp").forward(request, response);

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)

            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {

            session.invalidate();

        }

        response.sendRedirect(request.getContextPath() + "/admin/account/Ad_login.jsp");

    }

}
