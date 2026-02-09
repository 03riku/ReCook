package store;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.StoreDao;

@WebServlet("/super/discountAction")
public class DiscountActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setCharacterEncoding("UTF-8");
            String action = req.getParameter("action");

            String dpIdStr = req.getParameter("discountedProductId");
            if (dpIdStr == null || dpIdStr.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/super/discountPage");
                return;
            }
            int dpId = Integer.parseInt(dpIdStr);

            StoreDao storeDao = new StoreDao();

            if ("update".equals(action)) {
                String rateStr = req.getParameter("rate");
                if (rateStr != null && !rateStr.isEmpty()) {
                    int rate = Integer.parseInt(rateStr);
                    storeDao.updateDiscountRate(dpId, rate);
                }
            } else if ("delete".equals(action)) {
                storeDao.deleteDiscountedProduct(dpId);
            }

            resp.sendRedirect(req.getContextPath() + "/super/discountPage");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}