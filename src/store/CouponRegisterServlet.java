package store;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.StoreDao;

@WebServlet("/super/addCoupon")
public class CouponRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 文字化け防止
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. セッションチェック
            HttpSession session = request.getSession();

            Long storeIdInt = (Long) session.getAttribute("store_id");

            if (storeIdInt == null) {
                response.sendRedirect(request.getContextPath() + "/super/account/Sp_Login.jsp");
                return;
            }

            // BIGINT対応のため long に変換
            long storeId = storeIdInt.longValue();

            // 2. パラメータ取得
            String rateStr = request.getParameter("discountRate");
            String menuIdStr = request.getParameter("menuItemId");
            String startStr = request.getParameter("startTime");
            String endStr = request.getParameter("endTime");

            // 3. バリデーション
            if (rateStr == null || menuIdStr == null || startStr == null || endStr == null ||
                rateStr.isEmpty() || menuIdStr.isEmpty() || startStr.isEmpty() || endStr.isEmpty()) {

                session.setAttribute("errorMsg", "全ての項目を正しく入力してください。");
                response.sendRedirect(request.getContextPath() + "/super/couponPage");
                return;
            }

            int discountRate = Integer.parseInt(rateStr);
            int menuItemId = Integer.parseInt(menuIdStr);

            // 日時フォーマット調整 (YYYY-MM-DDTHH:mm -> YYYY-MM-DD HH:mm:00)
            String startTime = startStr.replace("T", " ") + ":00";
            String endTime = endStr.replace("T", " ") + ":00";

            // ★ 修正箇所: StoreDao をインスタンス化
            StoreDao storeDao = new StoreDao();

            // 4. クーポン登録処理
            // 旧: couponDao.insert(...) -> 新: storeDao.insertCoupon(...)
            int newCouponId = storeDao.insertCoupon(discountRate, storeId, menuItemId, startTime, endTime);

            // 5. メニュー価格更新処理
            // 旧: menuDao.registerStoreMenu(...) -> 新: storeDao.registerStoreMenu(...)
            // (registerStoreMenu は StoreDao にそのままの名前で統合しました)
            storeDao.registerStoreMenu(storeId, menuItemId, newCouponId, discountRate);

            // 6. 完了処理
            session.setAttribute("successMsg", "クーポンを登録し、メニュー価格を更新しました。");
            response.sendRedirect(request.getContextPath() + "/super/couponPage");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "数値の入力が正しくありません。");
            response.sendRedirect(request.getContextPath() + "/super/couponPage");
        } catch (Exception e) {
            e.printStackTrace();
            // エラー発生時はコンソールに出しつつ、エラー画面や一覧へ
            request.getSession().setAttribute("errorMsg", "システムエラーが発生しました。");
            response.sendRedirect(request.getContextPath() + "/super/couponPage");
        }
    }
}