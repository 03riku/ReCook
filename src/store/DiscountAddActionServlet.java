package store;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.StoreDao;

@WebServlet("/super/addDiscount")
public class DiscountAddActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            HttpSession session = req.getSession();
            Long storeId = (Long) session.getAttribute("store_id");
            String[] productIds = req.getParameterValues("productIds");

            String defaultRateStr = req.getParameter("defaultRate");
            int defaultRate = (defaultRateStr != null && !defaultRateStr.isEmpty()) ? Integer.parseInt(defaultRateStr) : 0;

            if (productIds != null && storeId != null) {
                StoreDao storeDao = new StoreDao();

                boolean duplicate = false;
                for (String pid : productIds) {
                    int productId = Integer.parseInt(pid);

                    if (!storeDao.isDiscountedProductExists(productId, storeId)) {
                        storeDao.insertDiscountedProduct(productId, storeId, defaultRate);
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