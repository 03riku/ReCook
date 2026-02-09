package store;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Product;
import dao.StoreDao;

@WebServlet("/super/getIngredientsByMenu")
public class GetIngredientsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");

        try {
            String menuIdStr = req.getParameter("menuId");
            Long storeId = (Long) req.getSession().getAttribute("store_id");

            if (menuIdStr == null || storeId == null) {
                resp.getWriter().print("[]");
                return;
            }

            int menuId = Integer.parseInt(menuIdStr);

            StoreDao dao = new StoreDao();
            List<Product> ingredients = dao.getIngredientsWithPrice(menuId, storeId);

            PrintWriter out = resp.getWriter();
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < ingredients.size(); i++) {
                Product p = ingredients.get(i);
                json.append("{")
                    .append("\"name\":\"").append(p.getProductName()).append("\",")
                    .append("\"price\":").append(p.getPrice()) // 価格を追加
                    .append("}");
                if (i < ingredients.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}