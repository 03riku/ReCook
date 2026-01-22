package admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Store;
import dao.AdminDAO; // Đã đổi từ StoreDAO sang AdminDAO

@WebServlet("/admin/store/StoreServlet")
public class Admin_StoreServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Khởi tạo AdminDAO
        AdminDAO dao = new AdminDAO();
        try {
            // Gọi hàm xử lý Store từ AdminDAO
            List<Store> list = dao.selectAll();
            List<String[]> viewList = new ArrayList<>();
            for (Store s : list) viewList.add(new String[]{String.valueOf(s.getStoreId()), s.getStoreName()});
            request.setAttribute("stores", viewList);

            String editId = request.getParameter("editId");
            if (editId != null) {
                request.setAttribute("selectedStore", dao.selectById(Long.parseLong(editId)));
                request.setAttribute("mode", request.getParameter("mode"));
            }
            HttpSession session = request.getSession();
            request.setAttribute("message", session.getAttribute("message"));
            session.removeAttribute("message");
        } catch (Exception e) { e.printStackTrace(); }
        request.getRequestDispatcher("/admin/store/Ad_store.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr = request.getParameter("storeId");
        String oldIdStr = request.getParameter("oldStoreId");
        HttpSession session = request.getSession();

        // Khởi tạo AdminDAO
        AdminDAO dao = new AdminDAO();

        try {
            // Validation: 10 chữ số và không bắt đầu bằng 0
            if (idStr == null || idStr.length() != 10 || !idStr.matches("\\d+")) {
                session.setAttribute("message", "Error: 店舗IDは10桁の数字で入力してください。");
            } else if (idStr.startsWith("0")) {
                session.setAttribute("message", "Error: 最初の桁は０以外入力してください。");
            } else {
                long id = Long.parseLong(idStr);
                Store s = new Store(id, request.getParameter("storeName"), request.getParameter("storePassword"), request.getParameter("storeAddress"));

                if ("add".equals(action)) {
                    // Gọi hàm kiểm tra và insert từ AdminDAO
                    if (dao.isIdExists(id)) session.setAttribute("message", "Error: 店舗ID既に存在します。");
                    else { dao.insert(s); session.setAttribute("message", "追加しました。"); }
                } else if ("update".equals(action)) {
                    long oldId = Long.parseLong(oldIdStr);
                    // Gọi hàm update từ AdminDAO
                    if (id != oldId && dao.isIdExists(id)) session.setAttribute("message", "Error: 店舗ID既に存在します。");
                    else { dao.update(s, oldId); session.setAttribute("message", "更新しました。"); }
                } else if ("delete".equals(action)) {
                    // Gọi hàm delete từ AdminDAO
                    dao.delete(id); session.setAttribute("message", "削除しました。");
                }
            }
        } catch (Exception e) { e.printStackTrace(); session.setAttribute("message", "Error: システムエラー"); }
        response.sendRedirect(request.getContextPath() + "/admin/store/StoreServlet");
    }
}