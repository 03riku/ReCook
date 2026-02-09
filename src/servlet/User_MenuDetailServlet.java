package servlet;

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
import bean.GeneralUser;
import bean.Product;
import bean.StoreProduct;
import dao.UserDAO;

@WebServlet("/user/MenuDetail")
public class User_MenuDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        String fromStore = request.getParameter("fromStore");
        String storeIdStr = request.getParameter("storeId");

        HttpSession session = request.getSession();
        GeneralUser user = (GeneralUser) session.getAttribute("loginUser");
        int userId = (user != null) ? user.getUserId() : 0;

        try {
            if (idStr != null) {
                int menuItemId = Integer.parseInt(idStr);
                UserDAO dao = new UserDAO();
                CookMenu menu = dao.getCookMenuById(menuItemId, userId);

                if ("true".equals(fromStore) && storeIdStr != null) {
                    long storeId = Long.parseLong(storeIdStr);

                    // 1. 各材料のリストを取得し、定価の合計を計算
                    List<StoreProduct> ingredients = dao.getIngredientsWithPrices(menuItemId, storeId);
                    int originalTotal = 0;
                    for (StoreProduct sp : ingredients) {
                        originalTotal += sp.getPrice();
                    }

                    // 2. 店舗設定の販売価格と値引き率を取得
                    Map<String, Integer> pricing = dao.getStorePricing(menuItemId, storeId);

                    request.setAttribute("ingredientsList", ingredients);
                    request.setAttribute("originalTotal", originalTotal); // 元の合計(2609円)

                    if (pricing != null) {
                        request.setAttribute("discountPrice", pricing.get("price")); // 販売価格(2426円)
                        request.setAttribute("discountRate", pricing.get("rate"));   // 値引き率(7%)
                    }
                } else {
                    List<Product> ingredients = dao.getIngredientsByMenuId(menuItemId);
                    request.setAttribute("ingredientsList", ingredients);
                }

                request.setAttribute("cookMenu", menu);
                request.setAttribute("fromStore", fromStore);
                request.getRequestDispatcher("/user/main/Us_RecipeDetail.jsp").forward(request, response);
            } else {
                response.sendRedirect("main/Us_Top.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main/Us_Top.jsp");
        }
    }
}