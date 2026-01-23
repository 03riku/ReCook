package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.CookMenu;
import bean.StoreProduct;
import dao.CookMenuDAO;
import dao.StoreProductDAO;

@WebServlet("/super/couponPage")
public class CouponPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession();
            Integer storeId = (Integer) session.getAttribute("store_id");
            if (storeId == null) { resp.sendRedirect(req.getContextPath() + "/super/account/Sp_Login.jsp"); return; }

            StoreProductDAO spDAO = new StoreProductDAO();
            CookMenuDAO cmDAO = new CookMenuDAO();

            // 左側用：自店舗の商品
            List<StoreProduct> ingredients = spDAO.findByStoreId(storeId);
            // 右側用：料理の選択肢
            List<CookMenu> menus = cmDAO.selectAll();

            req.setAttribute("ingredients", ingredients);
            req.setAttribute("menus", menus);

            req.getRequestDispatcher("/super/coupon/Sp_Coupon.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }
}