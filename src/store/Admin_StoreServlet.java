package store;

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
import dao.StoreDAO;

@WebServlet("/admin/store/StoreServlet")
public class Admin_StoreServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StoreDAO dao = new StoreDAO();
        String keyword = request.getParameter("keyword");
        String editIdStr = request.getParameter("editId");
        String mode = request.getParameter("mode");

        try {
            List<Store> list = (keyword != null && !keyword.isEmpty()) ? dao.searchByName(keyword) : dao.selectAll();
            List<String[]> viewList = new ArrayList<>();
            for (Store s : list) {
                viewList.add(new String[]{ String.valueOf(s.getStoreId()), s.getStoreName() });
            }
            request.setAttribute("stores", viewList);

            if (editIdStr != null) {
                Store s = dao.selectById(Integer.parseInt(editIdStr));
                request.setAttribute("selectedStore", s);
                request.setAttribute("mode", mode);
            }

            HttpSession session = request.getSession();
            request.setAttribute("message", session.getAttribute("message"));
            session.removeAttribute("message");

        } catch (Exception e) { e.printStackTrace(); }

        request.getRequestDispatcher("/admin/store/Ad_store.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr = request.getParameter("storeId");
        String oldIdStr = request.getParameter("oldStoreId");
        String name = request.getParameter("storeName");
        String pass = request.getParameter("storePassword");
        String addr = request.getParameter("storeAddress");

        StoreDAO dao = new StoreDAO();
        HttpSession session = request.getSession();

        try {
            if (idStr == null || idStr.length() != 10 || !idStr.matches("\\d+")) {
                session.setAttribute("message", "Error: 店舗IDは10桁の数字で入力してください。");
                response.sendRedirect(request.getContextPath() + "/admin/store/StoreServlet");
                return;
            }

            int id = Integer.parseInt(idStr);
            Store s = new Store(id, name, pass, addr);

            if ("add".equals(action)) {
                if (dao.isIdExists(id)) {
                    session.setAttribute("message", "Error: 店舗ID既に存在します。");
                } else {
                    dao.insert(s);
                    session.setAttribute("message", "追加しました。");
                }
            } else if ("update".equals(action)) {
                int oldId = Integer.parseInt(oldIdStr);
                if (id != oldId && dao.isIdExists(id)) {
                    session.setAttribute("message", "Error: 店舗ID既に存在します。");
                } else {
                    dao.update(s, oldId);
                    session.setAttribute("message", "更新しました。");
                }
            } else if ("delete".equals(action)) {
                dao.delete(id);
                session.setAttribute("message", "削除しました。");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: システムエラーが発生しました。");
        }
        response.sendRedirect(request.getContextPath() + "/admin/store/StoreServlet");
    }
}