package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.StoreProductDAO;

@WebServlet("/super/addStoreProduct")
public class StoreAddStoreProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Integer storeId = (Integer) req.getSession().getAttribute("store_id");
            if (storeId == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String[] selectedProductIds = req.getParameterValues("productIds");
            if (selectedProductIds != null) {
                StoreProductDAO storeDAO = new StoreProductDAO();
                for (String pid : selectedProductIds) {
                    int productId = Integer.parseInt(pid);
                    storeDAO.insertFromProduct(productId, storeId);
                }
            }

            // 追加後は GET ページにリダイレクト
            resp.sendRedirect(req.getContextPath() + "/super/storeProductPage");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
