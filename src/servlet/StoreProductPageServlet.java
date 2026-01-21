package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Product;
import bean.StoreProduct;
import dao.ProductDAO;
import dao.StoreProductDAO;

@WebServlet("/super/storeProductPage")
public class StoreProductPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            HttpSession session = req.getSession();
            Integer storeId = (Integer) session.getAttribute("store_id");

            if (storeId == null) {
                resp.sendRedirect(req.getContextPath() + "/super/account/Sp_Login.jsp");
                return;
            }

            ProductDAO productDAO = new ProductDAO();
            StoreProductDAO storeDAO = new StoreProductDAO();

            // DBから両方のリストを取得してリクエスト属性にセット
            List<Product> productList = productDAO.getAllProducts();
            List<StoreProduct> storeProductList = storeDAO.findByStoreId(storeId);

            req.setAttribute("productList", productList);
            req.setAttribute("storeProductList", storeProductList);

            // JSPへ移動
            req.getRequestDispatcher("/super/item/Sp_Item.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}