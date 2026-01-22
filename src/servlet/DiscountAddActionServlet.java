package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.DiscountedProductDAO;

@WebServlet("/super/addDiscount")
public class DiscountAddActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            HttpSession session = req.getSession();
            Integer storeId = (Integer) session.getAttribute("store_id");
            String[] productIds = req.getParameterValues("productIds");
            int defaultRate = Integer.parseInt(req.getParameter("defaultRate"));

            if (productIds != null && storeId != null) {
                DiscountedProductDAO dao = new DiscountedProductDAO();
                boolean duplicate = false;
                for (String pid : productIds) {
                    int productId = Integer.parseInt(pid);
                    if (!dao.isExists(productId, storeId)) {
                        dao.insert(productId, storeId, defaultRate);
                    } else {
                        duplicate = true;
                    }
                }
                if (duplicate) {
                    session.setAttribute("errorMsg", "選択された一部の商品は既に値引き設定されています。");
                }
            }
            resp.sendRedirect(req.getContextPath() + "/super/discountPage");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}