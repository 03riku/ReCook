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

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            // 1. セッションチェック
            Long storeIdObj = (Long) session.getAttribute("store_id");
            if (storeIdObj == null) {
                response.sendRedirect(request.getContextPath() + "/super/account/Sp_Login.jsp");
                return;
            }
            long storeId = storeIdObj.longValue();

            // 2. アクションを取得
            String action = request.getParameter("action");
            if (action == null || action.isEmpty()) action = "register";

            StoreDao storeDao = new StoreDao();

            // 3. 共通パラメータ
            String menuIdStr = request.getParameter("menuItemId");
            String couponIdStr = request.getParameter("couponId");

            int menuItemId = (menuIdStr != null && !menuIdStr.isEmpty()) ? Integer.parseInt(menuIdStr) : 0;
            int couponId = (couponIdStr != null && !couponIdStr.isEmpty()) ? Integer.parseInt(couponIdStr) : 0;

            // --- 削除処理 ---
            if ("delete".equals(action)) {
                if (couponId > 0 && menuItemId > 0) {
                    storeDao.deleteCouponAndResetMenu(couponId, storeId, menuItemId);
                    session.setAttribute("successMsg", "クーポンを削除しました。");
                } else {
                    session.setAttribute("errorMsg", "削除対象が見つかりません。");
                }
            }
            // --- 登録 / 更新処理 ---
            else {
                String rateStr = request.getParameter("discountRate");
                String startStr = request.getParameter("startTime");
                String endStr = request.getParameter("endTime");

                if (rateStr == null || startStr == null || endStr == null || rateStr.isEmpty()) {
                    throw new IllegalArgumentException("必須項目が不足しています");
                }

                int discountRate = Integer.parseInt(rateStr);

                // 日時フォーマット整形
                String startTime = startStr.replace("T", " ") + (startStr.length() <= 16 ? ":00" : "");
                String endTime = endStr.replace("T", " ") + (endStr.length() <= 16 ? ":00" : "");

                // ★追加: 時間重複チェック
                if (storeDao.isCouponTimeOverlapping(storeId, menuItemId, startTime, endTime, couponId)) {
                    session.setAttribute("errorMsg", "この料理は選択された時間に既に存在しています。");
                    response.sendRedirect(request.getContextPath() + "/super/couponPage");
                    return;
                }

                if ("update".equals(action)) {
                    // 更新実行
                    if (couponId > 0) {
                        storeDao.updateCouponAndMenu(couponId, discountRate, storeId, menuItemId, startTime, endTime);
                        session.setAttribute("successMsg", "クーポン情報を更新しました。");
                    }
                } else {
                    // 新規登録実行
                    int newId = storeDao.insertCoupon(discountRate, storeId, menuItemId, startTime, endTime);
                    storeDao.registerStoreMenu(storeId, menuItemId, newId, discountRate);
                    session.setAttribute("successMsg", "新しいクーポンを登録しました。");
                }
            }

            response.sendRedirect(request.getContextPath() + "/super/couponPage");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "数値の入力が正しくありません。");
            response.sendRedirect(request.getContextPath() + "/super/couponPage");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "システムエラーが発生しました: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/super/couponPage");
        }
    }
}