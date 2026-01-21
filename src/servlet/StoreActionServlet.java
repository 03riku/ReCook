package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.StoreProductDAO;

@WebServlet("/super/storeAction")
public class StoreActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action"); // "update" か "delete"
        int spId = Integer.parseInt(req.getParameter("storeProductId"));

        StoreProductDAO dao = new StoreProductDAO();

        try {
            if ("update".equals(action)) {
                int price = Integer.parseInt(req.getParameter("price"));
                dao.updatePrice(spId, price);
            } else if ("delete".equals(action)) {
                dao.delete(spId);
            }

            // 処理が終わったら一覧ページに戻る
            resp.sendRedirect(req.getContextPath() + "/super/storeProductPage");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}