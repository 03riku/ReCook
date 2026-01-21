package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SuperLoginServlet")
public class SuperLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        String pass = request.getParameter("pass");

        boolean isSuccess = false;
        String storeName = "";

        try {
            Class.forName("org.h2.Driver");
            String url = "jdbc:h2:tcp://localhost/~/Re.Cook";
            try (Connection conn = DriverManager.getConnection(url, "sa", "")) {
                String sql = "SELECT STORE_NAME FROM STORE WHERE STORE_ID = ? AND STORE_PASSWORD = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, idStr);
                pstmt.setString(2, pass);

                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    isSuccess = true;
                    storeName = rs.getString("STORE_NAME");
                }
            }
        } catch (Exception e) { e.printStackTrace(); }

        if (isSuccess) {
            HttpSession session = request.getSession();
            // 名前を "store_id" に統一し、数値型で保存
            session.setAttribute("store_id", Integer.parseInt(idStr));
            session.setAttribute("storeName", storeName);

            // 【最重要】表示用サーブレットへリダイレクト
            response.sendRedirect(request.getContextPath() + "/super/storeProductPage");
        } else {
            request.setAttribute("errorMsg", "IDまたはパスワードが正しくありません。");
            request.getRequestDispatcher("/super/account/Sp_Login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/super/account/Sp_Login.jsp");
    }
}