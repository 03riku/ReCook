package store;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.CookMenu;
import bean.StoreProduct;
import dao.StoreDao;

@WebServlet("/super/couponPage")
public class CouponPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession();
            Long storeId = (Long) session.getAttribute("store_id");

            if (storeId == null) {
                resp.sendRedirect(req.getContextPath() + "/super/account/Sp_Login.jsp");
                return;
            }

            StoreDao storeDao = new StoreDao();

            // ============================================================
            // ★【追加】期限切れクーポンの自動削除を実行
            // データを取得する前に実行することで、画面には常に有効なものだけが出ます。
            // ============================================================
            storeDao.deleteExpiredCoupons();

            // 具材リスト
            List<StoreProduct> ingredients = storeDao.findStoreProductsByStoreId(storeId);
            // 料理選択用メニューリスト
            List<CookMenu> menus = storeDao.selectAllCookMenus();

            // 登録済みクーポン一覧を取得
            List<Map<String, Object>> couponList = storeDao.getRegisteredCoupons(storeId);

            req.setAttribute("ingredients", ingredients);
            req.setAttribute("menus", menus);
            req.setAttribute("couponList", couponList);

            req.getRequestDispatcher("/super/coupon/Sp_Coupon.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}