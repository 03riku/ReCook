<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="java.lang.StringBuilder"%>
<%@ page import="bean.Product"%>

<%!
	private String createBody1Content(List<Product> products, String contextPath) {
		StringBuilder sb = new StringBuilder();
		sb.append("<h4 class=\"mb-4 text-dark\">商品一覧</h4>");

        // 【修正点 1】: 検索フォームに onsubmit イベントを追加
        // 検索ボタンを押した時だけ「検索中フラグ」を立てるため
		sb.append("<form action=\"").append(contextPath)
				.append("/product/Admin_ProductServlet\" method=\"get\" class=\"mb-4\" onsubmit=\"setSearchFlag()\">");
		sb.append("<div class=\"input-group\">");
		sb.append(
				"<input type=\"text\" name=\"searchName\" class=\"form-control form-control-line\" placeholder=\"商品名で検索...\">");
		sb.append("<button class=\"btn btn-dark\" type=\"submit\">検索</button>");
		sb.append("</div>");
		sb.append("</form>");

		sb.append("<form id=\"BulkDeleteForm\" action=\"").append(contextPath)
				.append("/product/Admin_ProductServlet\" method=\"post\">");
		sb.append("<input type=\"hidden\" name=\"action\" value=\"bulkDelete\">");
		sb.append("<div id=\"hiddenInputsContainer\"></div>");

		sb.append("<div class=\"table-responsive\">");
		sb.append("<table class=\"table table-hover product-list-table\">");
		sb.append("<thead><tr class=\"table-secondary\">");
		sb.append("<th>商品名</th>");

		sb.append("<th style=\"width: 80px; text-align: center;\">");
		sb.append("<div id=\"deleteBtnContainer\" style=\"display: none;\">");
		sb.append(
				"<button type=\"button\" onclick=\"showDeleteConfirmation()\" class=\"btn btn-danger btn-sm text-nowrap\">削除 (<span id=\"countDisplay\">0</span>)</button>");
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
						.append(id).append("', '").append(safeName).append("', '").append(category)
						.append("'); return false;\">");
				sb.append(name);
				sb.append("</a>");
				sb.append("</td>");

				sb.append("<td style=\"text-align: center;\">");
				sb.append("<input type=\"checkbox\" value=\"").append(id).append("\" data-name=\"").append(name)
						.append("\" class=\"product-checkbox\" onchange=\"handleCheckboxChange(this)\">");
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

	private String createBody2Content(String contextPath, String message, String error,
			List<String> existingCategories) {
		StringBuilder sb = new StringBuilder();

		// --- Edit Mode ---
		sb.append("<div id=\"editModeContainer\">");
		sb.append("<h4 class=\"mb-4 text-dark\">商品編集・追加</h4>");

		if (message != null && !message.isEmpty()) {
			sb.append("<div id=\"successAlert\" class=\"alert alert-success py-2\">").append(message).append("</div>");
		}
		if (error != null && !error.isEmpty()) {
			sb.append("<div class=\"alert alert-danger py-2\">").append(error).append("</div>");
		}

		sb.append("<form id=\"ProductActionForm\" action=\"").append(contextPath)
				.append("/product/Admin_ProductServlet\" method=\"post\">");
		sb.append("<div class=\"row\">");
		sb.append("<div class=\"col-8\">");
		sb.append("<input type=\"hidden\" name=\"action\" value=\"save\">");
		sb.append("<input type=\"hidden\" id=\"editId\" name=\"productId\">");

		sb.append("<div class=\"row g-3 align-items-center mb-4\">");
		sb.append("<div class=\"col-4\"><label class=\"form-label fw-bold\">商品名</label></div>");
		sb.append("<div class=\"col-8\">");
		sb.append(
				"<input type=\"text\" id=\"editName\" name=\"productName\" class=\"form-control form-control-line\" required>");
		sb.append("</div>");
		sb.append("</div>");

		sb.append("<div class=\"row g-3 align-items-center mb-4\">");
		sb.append("<div class=\"col-4\"><label class=\"form-label fw-bold\">カテゴリ</label></div>");
		sb.append("<div class=\"col-8\">");
		sb.append(
				"<input type=\"text\" list=\"categoryList\" id=\"editCategory\" name=\"category\" class=\"form-control form-control-line\" placeholder=\"選択または入力\" required>");
		sb.append("<datalist id=\"categoryList\">");
		if (existingCategories != null && !existingCategories.isEmpty()) {
			for (String cat : existingCategories) {
				sb.append("<option value=\"").append(cat).append("\">");
			}
		} else {
			sb.append("<option value=\"肉\"><option value=\"野菜\">");
		}
		sb.append("</datalist>");
		sb.append("</div>");
		sb.append("</div>");
		sb.append("</div>"); // End col-8

		sb.append("<div class=\"col-4 d-flex justify-content-end align-items-start pt-4\">");
		sb.append("<div class=\"d-grid gap-3\">");
		sb.append(
				"<button type=\"submit\" class=\"btn btn-dark btn-large-stacked\">追加/更新</button>");
		sb.append(
				"<button type=\"button\" onclick=\"resetForm()\" class=\"btn btn-outline-dark btn-large-stacked\">クリア</button>");
		sb.append("</div>");
		sb.append("</div>");
		sb.append("</div>");
		sb.append("</form>");
		sb.append("</div>");

		// --- Confirm Mode ---
		sb.append("<div id=\"deleteConfirmContainer\" style=\"display: none;\">");
		sb.append("<h4 class=\"mb-4 text-danger\">削除の確認</h4>");
		sb.append("<div class=\"alert alert-light border border-danger mb-4\">");
		sb.append("<p class=\"fw-bold\">以下の <span id=\"confirmCount\" class=\"text-danger\"></span> 件の商品が削除されます。</p>");
		sb.append("<ul id=\"selectedItemsList\" class=\"list-group list-group-flush\"></ul>");
		sb.append("</div>");
		sb.append("<div class=\"d-flex justify-content-end gap-3\">");
		sb.append(
				"<button type=\"button\" onclick=\"cancelDelete()\" class=\"btn btn-outline-dark btn-large-stacked\">戻る</button>");
		sb.append(
				"<button type=\"button\" onclick=\"confirmBulkDelete()\" class=\"btn btn-danger btn-large-stacked\">確認</button>");
		sb.append("</div>");
		sb.append("</div>");

		return sb.toString();
	}%>

<style>
.form-control-line {
	border: none;
	border-bottom: 1px solid #333;
	border-radius: 0;
	padding: 5px 0;
	background-color: transparent;
	box-shadow: none !important;
}
.form-control-line:focus { border-bottom-color: #007bff; }
.btn-large-stacked { width: 150px; height: 60px; font-size: 1.1rem; font-weight: bold; }
.product-list-table { font-size: 0.95rem; }
.product-checkbox { width: 18px; height: 18px; cursor: pointer; }
#selectedItemsList { max-height: 200px; overflow-y: auto; }
</style>

<script>
    let selectedProducts = {};

    // 【修正点 2】: 検索ボタンを押した時にフラグを立てる関数
    function setSearchFlag() {
        sessionStorage.setItem('isSearching', 'true');
    }

    window.addEventListener('DOMContentLoaded', (event) => {

        // 【修正点 3】: ロード時の判定ロジック
        // 1. 成功メッセージがある場合（削除/更新完了後） -> クリア
        const successAlert = document.getElementById('successAlert');
        if (successAlert && successAlert.innerText.trim() !== "") {
            sessionStorage.removeItem('selectedProducts');
            sessionStorage.removeItem('isSearching');
            selectedProducts = {};

        // 2. 「検索中フラグ」がある場合 -> 保持（検索リロードとみなす）
        } else if (sessionStorage.getItem('isSearching') === 'true') {
            // フラグは一度使ったら消す（リロード対策）
            sessionStorage.removeItem('isSearching');

            const stored = sessionStorage.getItem('selectedProducts');
            if (stored) {
                selectedProducts = JSON.parse(stored);
            }

        // 3. それ以外（他ページからの遷移、F5リロードなど） -> クリア
        } else {
            sessionStorage.removeItem('selectedProducts');
            selectedProducts = {};
        }

        // チェックボックスの状態を同期
        const checkboxes = document.querySelectorAll('.product-checkbox');
        checkboxes.forEach(cb => {
            if (selectedProducts.hasOwnProperty(cb.value)) {
                cb.checked = true;
            } else {
                cb.checked = false;
            }
        });

        updateDeleteUI();
    });

    function handleCheckboxChange(checkbox) {
        if (checkbox.checked) {
            selectedProducts[checkbox.value] = checkbox.getAttribute('data-name');
        } else {
            delete selectedProducts[checkbox.value];
        }
        sessionStorage.setItem('selectedProducts', JSON.stringify(selectedProducts));
        updateDeleteUI();
    }

    function updateDeleteUI() {
        const count = Object.keys(selectedProducts).length;
        const btnContainer = document.getElementById('deleteBtnContainer');
        const countDisplay = document.getElementById('countDisplay');

        if (count > 0) {
            btnContainer.style.display = 'block';
            countDisplay.innerText = count;
        } else {
            btnContainer.style.display = 'none';
        }
    }

    // --- フォーム操作 ---

    function fillForm(id, name, category) {
        if(document.getElementById('deleteConfirmContainer').style.display === 'block') return;
        document.getElementById('editId').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editCategory').value = category;
        document.querySelectorAll('.alert').forEach(a => a.style.display = 'none');
    }

    function resetForm() {
        document.getElementById('ProductActionForm').reset();
        document.getElementById('editId').value = "";
        document.getElementById('editName').value = "";
        document.getElementById('editCategory').value = "";
        document.querySelectorAll('.alert').forEach(a => a.style.display = 'none');
    }

    function showDeleteConfirmation() {
        const listContainer = document.getElementById('selectedItemsList');
        const editMode = document.getElementById('editModeContainer');
        const confirmMode = document.getElementById('deleteConfirmContainer');
        const confirmCount = document.getElementById('confirmCount');

        listContainer.innerHTML = '';
        const keys = Object.keys(selectedProducts);

        keys.forEach(key => {
            const li = document.createElement('li');
            li.className = 'list-group-item bg-transparent';
            li.innerHTML = '・ ' + selectedProducts[key];
            listContainer.appendChild(li);
        });

        confirmCount.innerText = keys.length;
        editMode.style.display = 'none';
        confirmMode.style.display = 'block';
    }

    function cancelDelete() {
        sessionStorage.removeItem('selectedProducts');
        sessionStorage.removeItem('isSearching'); // 念のため検索フラグも消す

        // ページをリロードして完全に初期状態に戻す
        window.location.href = "${pageContext.request.contextPath}/product/Admin_ProductServlet";
    }

    function confirmBulkDelete() {
        const form = document.getElementById('BulkDeleteForm');
        const hiddenContainer = document.getElementById('hiddenInputsContainer');
        hiddenContainer.innerHTML = '';

        for (const [id, name] of Object.entries(selectedProducts)) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'deleteIds';
            input.value = id;
            hiddenContainer.appendChild(input);
        }
        form.submit();
    }
</script>

<%
	request.setAttribute("pageTitle", "商品管理");
	request.setAttribute("currentMenu", "product");

	@SuppressWarnings("unchecked")
	List<Product> productList = (List<Product>) request.getAttribute("products");

	String message = (String) request.getAttribute("message");
	String error = (String) request.getAttribute("error");

	@SuppressWarnings("unchecked")
	List<String> existingCategories = (List<String>) request.getAttribute("categories");

	String body1 = createBody1Content(productList, request.getContextPath());
	request.setAttribute("pageContentBody1", body1);

	String body2 = createBody2Content(request.getContextPath(), message, error, existingCategories);
	request.setAttribute("pageContentBody2", body2);
%>

<c:import url="/admin/Ad_base.jsp" />