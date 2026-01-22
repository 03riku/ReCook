package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.DiscountedProductDAO;

@WebServlet("/super/discountAction")
public class DiscountActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setCharacterEncoding("UTF-8");
            String action = req.getParameter("action");
            int dpId = Integer.parseInt(req.getParameter("discountedProductId"));

            DiscountedProductDAO dao = new DiscountedProductDAO();

            if ("update".equals(action)) {
                int rate = Integer.parseInt(req.getParameter("rate"));
                dao.updateRate(dpId, rate);
            } else if ("delete".equals(action)) {
                dao.delete(dpId);
            }

            resp.sendRedirect(req.getContextPath() + "/super/discountPage");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}