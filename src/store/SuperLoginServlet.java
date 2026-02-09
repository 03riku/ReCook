package store;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.StoreDao;

@WebServlet("/SuperLoginServlet")
public class SuperLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        String pass = request.getParameter("pass");

        String storeName = null;
        boolean isSuccess = false;

        try {
            long storeId = Long.parseLong(idStr);

            StoreDao dao = new StoreDao();
            storeName = dao.loginStore(storeId, pass);

            if (storeName != null) {
                isSuccess = true;
            }

            if (isSuccess) {
                HttpSession session = request.getSession();
                session.setAttribute("store_id", storeId);
                session.setAttribute("storeName", storeName);

                response.sendRedirect(request.getContextPath() + "/super/storeProductPage");
            } else {
                request.setAttribute("errorMsg", "IDまたはパスワードが正しくありません。");
                request.getRequestDispatcher("/super/account/Sp_Login.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "IDは数値を入力してください(桁数が大きすぎる可能性があります)。");
            request.getRequestDispatcher("/super/account/Sp_Login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "システムエラーが発生しました。");
            request.getRequestDispatcher("/super/account/Sp_Login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/super/account/Sp_Login.jsp");
    }
}