package store;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.StoreDao;

@WebServlet("/super/storeBulkUpdate")
public class StoreBulkUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // JSPから配列として受け取る
            String[] ids = req.getParameterValues("storeProductIds");
            String[] prices = req.getParameterValues("prices");

            if (ids != null && prices != null) {
                StoreDao dao = new StoreDao();

                // ids.length に修正しました
                for (int i = 0; i < ids.length; i++) {
                    int id = Integer.parseInt(ids[i]);
                    int price = Integer.parseInt(prices[i]);

                    dao.updateStoreProductPrice(id, price);
                }
            }

            // 更新後は一覧ページへ戻る
            resp.sendRedirect(req.getContextPath() + "/super/storeProductPage");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}