package store;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.StoreDao;

@WebServlet("/super/storeAction")
public class StoreActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");

        String spIdStr = req.getParameter("storeProductId");

        if (spIdStr == null || spIdStr.isEmpty()) {
             resp.sendRedirect(req.getContextPath() + "/super/storeProductPage");
             return;
        }

        int spId = Integer.parseInt(spIdStr);

        StoreDao dao = new StoreDao();

        try {
            if ("update".equals(action)) {
                String priceStr = req.getParameter("price");
                if (priceStr != null && !priceStr.isEmpty()) {
                    int price = Integer.parseInt(priceStr);
                    dao.updateStoreProductPrice(spId, price);
                }
            } else if ("delete".equals(action)) {
                dao.deleteStoreProduct(spId);
            }

            resp.sendRedirect(req.getContextPath() + "/super/storeProductPage");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}