<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List" %>
<%@ page import="java.lang.StringBuilder" %>
<%@ page import="bean.Product" %>

<%!
    // Body 1: 商品一覧表示
    private String createBody1Content(List<Product> products, String contextPath) {
        StringBuilder sb = new StringBuilder();
        sb.append("<h4 class=\"mb-4 text-dark\">商品一覧</h4>");

        // 検索フォーム
        sb.append("<form action=\"").append(contextPath).append("/product/Admin_ProductServlet\" method=\"get\" class=\"mb-4\">");
        sb.append("<div class=\"input-group\">");
        sb.append("<input type=\"text\" name=\"searchName\" class=\"form-control form-control-line\" placeholder=\"商品名で検索...\">");
        sb.append("<button class=\"btn btn-dark\" type=\"submit\">検索</button>");
        sb.append("</div>");
        sb.append("</form>");

        // 一括削除フォーム
        sb.append("<form id=\"BulkDeleteForm\" action=\"").append(contextPath).append("/product/Admin_ProductServlet\" method=\"post\">");
        sb.append("<input type=\"hidden\" name=\"action\" value=\"bulkDelete\">");

        sb.append("<div class=\"table-responsive\">");
        sb.append("<table class=\"table table-hover product-list-table\">");
        sb.append("<thead><tr class=\"table-secondary\">");
        sb.append("<th>商品名</th>");
        sb.append("<th style=\"width: 80px; text-align: center;\">");
        sb.append("<div id=\"deleteBtnContainer\" style=\"display: none;\">");
        sb.append("<button type=\"button\" onclick=\"showDeleteConfirmation()\" class=\"btn btn-danger btn-sm\">削除</button>");
        sb.append("</div>");
        sb.append("</th>");
        sb.append("</tr></thead>");

        sb.append("<tbody>");

        if (products != null && !products.isEmpty()) {
            for (Product p : products) {
                int id = p.getProductId();
                String name = p.getProductName() != null ? p.getProductName() : "";
                String category = p.getCategory() != null ? p.getCategory() : "";
                String safeName = name.replace("'", "\\'");

                sb.append("<tr>");
                sb.append("<td>");
                sb.append("<span class=\"me-2\">・</span>");
                sb.append("<a href=\"#\" class=\"text-dark text-decoration-none product-link\" onclick=\"fillForm('")
                  .append(id).append("', '")
                  .append(safeName).append("', '")
                  .append(category).append("'); return false;\">");
                sb.append(name);
                sb.append("</a>");
                sb.append("</td>");
                sb.append("<td style=\"text-align: center;\">");
                sb.append("<input type=\"checkbox\" name=\"deleteIds\" value=\"").append(id).append("\" data-name=\"").append(name).append("\" class=\"product-checkbox\" onchange=\"toggleDeleteButton()\">");
                sb.append("</td>");
                sb.append("</tr>");
            }
        } else {
            sb.append("<tr><td colspan=\"2\" class=\"text-center\">商品が登録されていません。</td></tr>");
        }

        sb.append("</tbody></table></div>");
        sb.append("</form>");
        return sb.toString();
    }

    // Body 2: 商品編集・追加フォーム & 削除確認
    private String createBody2Content(String contextPath, String message, String error, List<String> existingCategories) {
        StringBuilder sb = new StringBuilder();

        // --- 編集モード ---
        sb.append("<div id=\"editModeContainer\">");
        sb.append("<h4 class=\"mb-4 text-dark\">商品編集・追加</h4>");

        // Hiển thị thông báo (Thành công / Lỗi)
        if (message != null && !message.isEmpty()) {
            sb.append("<div class=\"alert alert-success py-2\">").append(message).append("</div>");
        }
        if (error != null && !error.isEmpty()) {
            sb.append("<div class=\"alert alert-danger py-2\">").append(error).append("</div>");
        }

        sb.append("<form id=\"ProductActionForm\" action=\"").append(contextPath).append("/product/Admin_ProductServlet\" method=\"post\">");
        sb.append("<div class=\"row\">");
        sb.append("<div class=\"col-8\">");
        sb.append("<input type=\"hidden\" id=\"editId\" name=\"productId\">");

        // 1. 商品名
        sb.append("<div class=\"row g-3 align-items-center mb-4\">");
        sb.append("<div class=\"col-4\"><label class=\"form-label fw-bold\">商品名</label></div>");
        sb.append("<div class=\"col-8\">");
        sb.append("<input type=\"text\" id=\"editName\" name=\"productName\" class=\"form-control form-control-line\" required>");
        sb.append("</div>");
        sb.append("</div>");

        // 2. カテゴリ (Hiển thị danh sách từ DB + Cho phép nhập mới)
        sb.append("<div class=\"row g-3 align-items-center mb-4\">");
        sb.append("<div class=\"col-4\"><label class=\"form-label fw-bold\">カテゴリ</label></div>");
        sb.append("<div class=\"col-8\">");
        sb.append("<input type=\"text\" list=\"categoryList\" id=\"editCategory\" name=\"category\" class=\"form-control form-control-line\" placeholder=\"選択または入力\">");

        // Tạo datalist từ danh sách category được truyền vào
        sb.append("<datalist id=\"categoryList\">");
        if (existingCategories != null && !existingCategories.isEmpty()) {
            for (String cat : existingCategories) {
                // Thoát ký tự đặc biệt nếu cần (ở đây giả định category an toàn)
                sb.append("<option value=\"").append(cat).append("\">");
            }
        } else {
            // Fallback nếu chưa có category nào
            sb.append("<option value=\"肉\">");
            sb.append("<option value=\"野菜\">");
            sb.append("<option value=\"乳製品\">");
        }
        sb.append("</datalist>");

        sb.append("</div>");
        sb.append("</div>");
        sb.append("</div>"); // End col-8

        // ボタンエリア
        sb.append("<div class=\"col-4 d-flex justify-content-end align-items-start pt-4\">");
        sb.append("<div class=\"d-grid gap-3\">");
        sb.append("<button type=\"submit\" name=\"action\" value=\"save\" class=\"btn btn-dark btn-large-stacked\">追加/更新</button>");
        sb.append("<button type=\"button\" onclick=\"resetForm()\" class=\"btn btn-outline-dark btn-large-stacked\">クリア</button>");
        sb.append("</div>");
        sb.append("</div>");
        sb.append("</div>"); // End row
        sb.append("</form>");
        sb.append("</div>");

        // --- 削除確認モード ---
        sb.append("<div id=\"deleteConfirmContainer\" style=\"display: none;\">");
        sb.append("<h4 class=\"mb-4 text-danger\">削除の確認</h4>");
        sb.append("<div class=\"alert alert-light border border-danger mb-4\">");
        sb.append("<p class=\"fw-bold\">以下の商品が削除されます。よろしいですか？</p>");
        sb.append("<ul id=\"selectedItemsList\" class=\"list-group list-group-flush\"></ul>");
        sb.append("</div>");
        sb.append("<div class=\"d-flex justify-content-end gap-3\">");
        sb.append("<button type=\"button\" onclick=\"cancelDelete()\" class=\"btn btn-outline-dark btn-large-stacked\">戻る</button>");
        sb.append("<button type=\"button\" onclick=\"confirmBulkDelete()\" class=\"btn btn-danger btn-large-stacked\">確認</button>");
        sb.append("</div>");
        sb.append("</div>");

        return sb.toString();
    }
%>

<style>
    .form-control-line {
        border: none;
        border-bottom: 1px solid #333;
        border-radius: 0;
        padding: 5px 0;
        background-color: transparent;
        box-shadow: none !important;
    }
    .form-control-line:focus {
        border-bottom-color: #007bff;
    }
    .btn-large-stacked {
        width: 150px;
        height: 60px;
        font-size: 1.1rem;
        font-weight: bold;
    }
    .product-list-table {
        font-size: 0.95rem;
    }
    .product-checkbox {
        width: 18px;
        height: 18px;
        cursor: pointer;
    }
    #selectedItemsList {
        max-height: 200px;
        overflow-y: auto;
    }
</style>

<script>
    function fillForm(id, name, category) {
        if(document.getElementById('deleteConfirmContainer').style.display === 'block') return;
        document.getElementById('editId').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editCategory').value = category;

        // Ẩn thông báo cũ khi người dùng chọn sản phẩm mới để sửa
        var alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            alert.style.display = 'none';
        });
    }

    function resetForm() {
        document.getElementById('ProductActionForm').reset();
        document.getElementById('editId').value = "";
    }

    function toggleDeleteButton() {
        const checkboxes = document.querySelectorAll('.product-checkbox');
        const deleteContainer = document.getElementById('deleteBtnContainer');
        let isAnyChecked = false;
        checkboxes.forEach(cb => { if (cb.checked) isAnyChecked = true; });

        deleteContainer.style.display = isAnyChecked ? 'block' : 'none';

        if(!isAnyChecked && document.getElementById('deleteConfirmContainer').style.display === 'block') {
            cancelDelete();
        }
    }

    function showDeleteConfirmation() {
        const checkboxes = document.querySelectorAll('.product-checkbox:checked');
        const listContainer = document.getElementById('selectedItemsList');
        const editMode = document.getElementById('editModeContainer');
        const confirmMode = document.getElementById('deleteConfirmContainer');

        listContainer.innerHTML = '';
        checkboxes.forEach(cb => {
            const li = document.createElement('li');
            li.className = 'list-group-item bg-transparent';
            li.innerHTML = '・ ' + cb.getAttribute('data-name');
            listContainer.appendChild(li);
        });

        editMode.style.display = 'none';
        confirmMode.style.display = 'block';
    }

    function cancelDelete() {
        document.getElementById('editModeContainer').style.display = 'block';
        document.getElementById('deleteConfirmContainer').style.display = 'none';
    }

    function confirmBulkDelete() {
        document.getElementById('BulkDeleteForm').submit();
    }
</script>

<%
    request.setAttribute("pageTitle", "商品管理");
    request.setAttribute("currentMenu", "product");

    @SuppressWarnings("unchecked")
    List<Product> productList = (List<Product>) request.getAttribute("products");

    // Lấy thông báo từ Servlet
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");

    // Lấy danh sách category từ Servlet
    @SuppressWarnings("unchecked")
    List<String> existingCategories = (List<String>) request.getAttribute("categories");

    String body1 = createBody1Content(productList, request.getContextPath());
    request.setAttribute("pageContentBody1", body1);

    // Truyền category list vào hàm tạo Body 2
    String body2 = createBody2Content(request.getContextPath(), message, error, existingCategories);
    request.setAttribute("pageContentBody2", body2);
%>

<c:import url="/admin/Ad_base.jsp" />