package store;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.DiscountedProduct;
import bean.StoreProduct;
import dao.StoreDao;

/**
 * 値引き商品管理画面を表示するサーブレット
 */
@WebServlet("/super/discountPage")
public class DiscountedPageServlet extends HttpServlet {

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

            // 【修正】左側：商品マスタではなく「自店舗に登録済みの商品」を取得する
            List<StoreProduct> storeProductList = storeDao.findStoreProductsByStoreId(storeId);

            // 右側：現在値引き中の商品
            List<DiscountedProduct> discountList = storeDao.findDiscountedProductsByStoreId(storeId);

            // セットする名前を JSP に合わせる
            req.setAttribute("storeProductList", storeProductList);
            req.setAttribute("discountList", discountList);

            req.getRequestDispatcher("/super/item/Sp_Discount.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}