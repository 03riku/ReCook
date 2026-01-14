<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.lang.StringBuilder" %>
<%@ page import="java.util.Arrays" %>

<%!
    // Danh sách mẫu (Dummy) cho Body 1
    private final List<String[]> DUMMY_RECIPES = Arrays.asList(
        new String[]{"001", "和風パスタ"},
        new String[]{"002", "トマトサラダ"},
        new String[]{"003", "チキンカレー"},
        new String[]{"004", "海鮮丼"}
    );

    // Danh sách mẫu cho Danh mục/Thể loại (ジャンル)
    private final List<String> DUMMY_CATEGORIES = Arrays.asList("和食", "洋食 ", "中華", "デザート");

    private String createBody1Content(List<String[]> recipes) {
        StringBuilder sb = new StringBuilder();
        sb.append("<h4 class=\"mb-4 text-dark\">レシピ一覧</h4>");
        sb.append("<div class=\"table-responsive\">");
        sb.append("<table class=\"table table-hover recipe-list-table\">");
        sb.append("<thead><tr class=\"table-secondary\"><th>ID</th><th>料理名</th></tr></thead>");
        sb.append("<tbody>");

        List<String[]> list = (recipes != null && !recipes.isEmpty()) ? recipes : DUMMY_RECIPES;

        for (String[] recipe : list) {
            String recipeId = recipe[0];
            String recipeName = recipe[1];
            sb.append("<tr>");
            sb.append("<td>").append(recipeId).append("</td>");
            sb.append("<td>");
            sb.append("<a href=\"#\" class=\"text-dark\" onclick=\"console.log('Đã chọn món ăn ID: ").append(recipeId).append("'); return false;\">");
            sb.append(recipeName);
            sb.append("</a>");
            sb.append("</td>");
            sb.append("</tr>");
        }

        sb.append("</tbody></table></div>");
        return sb.toString();
    }

    private String createBody2Content(List<String> categories) {
        StringBuilder sb = new StringBuilder();
        sb.append("<h4 class=\"mb-4 text-dark\">料理メニュー追加画面</h4>");
        sb.append("<form id=\"RecipeForm\" action=\"RecipeServlet\" method=\"post\" enctype=\"multipart/form-data\">");

        sb.append("<div class=\"row\">");

        // Khu vực Form Inputs chính (col-8)
        sb.append("<div class=\"col-8\">");

        // Dòng 1: Tên món ăn (料理名) và Thể loại (ジャンル)
        sb.append("<div class=\"row g-3 mb-4\">");

        // Cột Tên món ăn (料理名)
        sb.append("<div class=\"col-6\">");
        sb.append("<label class=\"form-label fw-bold\">料理名</label>");
        sb.append("<input type=\"text\" name=\"recipeName\" class=\"form-control form-control-line\" required>");
        sb.append("</div>");

        // Cột Thể loại (ジャンル) - ComboBox
        sb.append("<div class=\"col-6\">");
        sb.append("<label class=\"form-label fw-bold\">ジャンル</label>");
        sb.append("<select name=\"category\" class=\"form-select form-control-line\" required>");
        sb.append("<option value=\"\" disabled selected>選択してください</option>");
        List<String> list = (categories != null && !categories.isEmpty()) ? categories : DUMMY_CATEGORIES;
        for (String cat : list) {
            sb.append("<option value=\"").append(cat).append("\">").append(cat).append("</option>");
        }
        sb.append("</select>");
        sb.append("</div>");
        sb.append("</div>");

        // Dòng 2: Danh sách sản phẩm (商品一覧) và Ảnh (写真)
        sb.append("<div class=\"row g-3 mb-4\">");

        // Cột Danh sách sản phẩm (商品一覧) - Vùng nhập liệu lớn (textarea)
        sb.append("<div class=\"col-6\">");
        sb.append("<label class=\"form-label fw-bold\">商品一覧</label>");
        sb.append("<textarea name=\"productList\" class=\"form-control\" rows=\"5\" placeholder=\"...\"></textarea>");
        sb.append("</div>");

        // Cột Ảnh (写真) - Upload File
        sb.append("<div class=\"col-6\">");
        sb.append("<label class=\"form-label fw-bold\">写真</label>");
        // Giả định sử dụng input type file và một placeholder hiển thị "ファイル選択" (Chọn file)
        sb.append("<div class=\"input-group\">");
        sb.append("<input type=\"file\" name=\"recipeImage\" class=\"form-control\" id=\"inputGroupFile01\" accept=\"image/*\">");
        // Bỏ button giả lập 'ファイル選択' vì input type file đã xử lý
        sb.append("</div>");
        sb.append("</div>");
        sb.append("</div>");

        // Dòng 3: Mô tả món ăn (料理説明)
        sb.append("<div class=\"row g-3 mb-5\">");
        sb.append("<div class=\"col-12\">");
        sb.append("<label class=\"form-label fw-bold\">料理説明</label>");
        sb.append("<textarea name=\"recipeDescription\" class=\"form-control\" rows=\"5\" required></textarea>");
        sb.append("</div>");
        sb.append("</div>");

        sb.append("</div>"); // End col-8

        // Khu vực Buttons (col-4)
        // Các nút "追加" (Thêm) và "戻る" (Trở về)
        sb.append("<div class=\"col-4 d-flex justify-content-end align-items-end\">");
        sb.append("<div class=\"d-grid gap-3\">");

        // Nút Thêm (追加)
        sb.append("<button type=\"submit\" name=\"action\" value=\"add\" form=\"RecipeForm\" class=\"btn btn-dark btn-large-stacked\">追加</button>");

        // Nút Trở về (戻る)
        sb.append("<button type=\"button\" onclick=\"window.history.back()\" class=\"btn btn-outline-dark btn-large-stacked\">戻る</button>");

        sb.append("</div>");
        sb.append("</div>");

        sb.append("</div>"); // End row
        sb.append("</form>");

        return sb.toString();
    }
%>

<style>
    /* CSS Tùy chỉnh cho Form trong Body 2 (Đã lấy từ Ad_Item/Ad_store.jsp) */
    .form-control-line {
        border: none;
        border-bottom: 1px solid black;
        border-radius: 0;
        padding: 5px 0;
        box-shadow: none !important;
        width: 100%;
        transition: border-color 0.15s ease-in-out;
    }
    .form-control-line:focus {
        border-bottom-color: #007bff; /* Màu xanh khi focus */
    }
    .btn-large-stacked {
        width: 150px;
        height: 60px;
        font-size: 1.1rem;
        font-weight: bold;
    }
    /* Đảm bảo textarea không có border dưới */
    .form-control:not(.form-control-line) {
        border: 1px solid #ccc; /* Border chuẩn cho textarea */
        border-radius: 5px;
    }

    /* Căn chỉnh các trường label */
    .form-label {
        margin-bottom: 0.5rem;
    }

    /* Style cho bảng danh sách món ăn trong Body 1 */
    .recipe-list-table {
        font-size: 0.9rem;
        cursor: pointer;
    }
    .recipe-list-table th, .recipe-list-table td {
        padding: 8px;
        text-align: left;
    }
</style>

<%
    request.setAttribute("pageTitle", "料理");
    request.setAttribute("currentMenu", "recipe");

    @SuppressWarnings("unchecked")
    List<String[]> recipeList = (List<String[]>) request.getAttribute("recipes");
    String body1Content = createBody1Content(recipeList);
    request.setAttribute("pageContentBody1", body1Content);

    // 3. Tạo và Đặt Nội dung Body 2 (Form thêm/chỉnh sửa)
    @SuppressWarnings("unchecked")
    List<String> categories = (List<String>) request.getAttribute("categories");
    String body2Content = createBody2Content(categories);
    request.setAttribute("pageContentBody2", body2Content);
%>

<!-- 4. Nhúng template cơ sở. Giả định Ad_recipe.jsp nằm trong /admin/recipe/ -->
<c:import url="../../admin/Ad_base.jsp" />