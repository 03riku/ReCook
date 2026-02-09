package store;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.StoreDao;

@WebServlet("/super/addStoreProduct")
public class StoreAddStoreProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            HttpSession session = req.getSession();
            Long storeId = (Long) session.getAttribute("store_id");
            if (storeId == null) {
                resp.sendRedirect(req.getContextPath() + "/super/account/Sp_Login.jsp");
                return;
            }

            String[] selectedProductIds = req.getParameterValues("productIds");
            if (selectedProductIds != null) {
                StoreDao storeDAO = new StoreDao();

                boolean hasDuplicate = false;

                for (String pid : selectedProductIds) {
                    int productId = Integer.parseInt(pid);

                    // 重複チェック
                    if (storeDAO.isStoreProductExists(productId, storeId)) {
                        hasDuplicate = true; // 重複があったフラグを立てる
                    } else {
                        // 重複していない場合のみ追加
                        storeDAO.insertStoreProductFromProduct(productId, storeId);
                    }
                }

                if (hasDuplicate) {
                    // 指定されたエラーメッセージをセット
                    session.setAttribute("errorMsg", "選択された商品は既に自店舗に存在しています。");
                }
            }

            resp.sendRedirect(req.getContextPath() + "/super/storeProductPage");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}