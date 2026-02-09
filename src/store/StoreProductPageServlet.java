package store;

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
import dao.StoreDao;

@WebServlet("/super/storeProductPage")
public class StoreProductPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            HttpSession session = req.getSession();

            Long storeId = (Long) session.getAttribute("store_id");

            if (storeId == null) {
                resp.sendRedirect(req.getContextPath() + "/super/account/Sp_Login.jsp");
                return;
            }

            StoreDao storeDao = new StoreDao();

            // DBから両方のリストを取得してリクエスト属性にセット
            List<Product> productList = storeDao.getAllProducts();

            // StoreDao đã được cập nhật để nhận tham số long, nên ta truyền storeId (Long) vào được
            List<StoreProduct> storeProductList = storeDao.findStoreProductsByStoreId(storeId);

            req.setAttribute("productList", productList);
            req.setAttribute("storeProductList", storeProductList);

            // JSPへ移動
            req.getRequestDispatcher("/super/item/Sp_Item.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}