<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="java.lang.StringBuilder"%>
<%@ page import="bean.Product"%>

<%!
    // Body 1: 商品リスト生成 (左カラム)
	private String createBody1Content(List<Product> products, String contextPath) {
		StringBuilder sb = new StringBuilder();
		sb.append("<h4 class=\"mb-4 text-dark\">商品一覧</h4>");

		// 検索フォーム
		sb.append("<form action=\"").append(contextPath)
				.append("/product/Admin_ProductServlet\" method=\"get\" class=\"mb-4\">");
		sb.append("<div class=\"input-group\">");
		sb.append(
				"<input type=\"text\" name=\"searchName\" class=\"form-control form-control-line\" placeholder=\"商品名で検索...\">");
		sb.append("<button class=\"btn btn-dark\" type=\"submit\">検索</button>");
		sb.append("</div>");
		sb.append("</form>");

		// 削除用フォーム (ラッパーとして機能し、送信処理はJSで行う)
		sb.append("<form id=\"BulkDeleteForm\" action=\"").append(contextPath)
				.append("/product/Admin_ProductServlet\" method=\"post\">");
		sb.append("<input type=\"hidden\" name=\"action\" value=\"bulkDelete\">");

        // JSが送信時に動的にhidden inputを追加するコンテナ
		sb.append("<div id=\"hiddenInputsContainer\"></div>");

		sb.append("<div class=\"table-responsive\">");
		sb.append("<table class=\"table table-hover product-list-table\">");
		sb.append("<thead><tr class=\"table-secondary\">");
		sb.append("<th>商品名</th>");

		// 削除ボタン表示エリア
		sb.append("<th style=\"width: 80px; text-align: center;\">");
		sb.append("<div id=\"deleteBtnContainer\" style=\"display: none;\">");
		// 選択中の件数を表示する削除ボタン
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
				// JSのエラーを防ぐためにシングルクォートをエスケープ
				String safeName = name.replace("'", "\\'");

				sb.append("<tr>");
				sb.append("<td>");
				sb.append("<span class=\"me-2\">・</span>");
				// 商品名クリックで編集フォームに入力値をセット
				sb.append("<a href=\"#\" class=\"text-dark text-decoration-none product-link\" onclick=\"fillForm('")
						.append(id).append("', '").append(safeName).append("', '").append(category)
						.append("'); return false;\">");
				sb.append(name);
				sb.append("</a>");
				sb.append("</td>");

				// チェックボックス: name属性は削除し、二重送信を防ぐ。JSで処理する。
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

	// Body 2: 編集・追加フォーム および 削除確認画面 (右カラム)
	private String createBody2Content(String contextPath, String message, String error,
			List<String> existingCategories) {
		StringBuilder sb = new StringBuilder();

		// --- パート1: 入力フォーム ---
		sb.append("<div id=\"editModeContainer\">");
		sb.append("<h4 class=\"mb-4 text-dark\">商品編集・追加</h4>");

		// 処理成功メッセージ (JSで検知してセッションストレージをクリアするために使用)
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
				"<button type=\"submit\" name=\"action\" value=\"save\" class=\"btn btn-dark btn-large-stacked\">追加/更新</button>");
		sb.append(
				"<button type=\"button\" onclick=\"resetForm()\" class=\"btn btn-outline-dark btn-large-stacked\">クリア</button>");
		sb.append("</div>");
		sb.append("</div>");
		sb.append("</div>");
		sb.append("</form>");
		sb.append("</div>");

		// --- パート2: 削除確認画面 ---
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
    // --- ページを跨ぐ選択状態の保存ロジック (Session Storage) ---

    // 選択された商品を保持するグローバルオブジェクト { "id": "商品名" }
    let selectedProducts = {};

    // ページ読み込み完了時の処理
    window.addEventListener('DOMContentLoaded', (event) => {

        // 1. 削除成功直後かチェック (成功していればストレージをクリア)
        const successDiv = document.getElementById('successAlert');
        if (successDiv && successDiv.innerText.includes('削除しました')) {
            sessionStorage.removeItem('selectedProducts');
            selectedProducts = {};
        } else {
            // 2. そうでなければ、ストレージから保存された選択データを読み込む
            const stored = sessionStorage.getItem('selectedProducts');
            if (stored) {
                selectedProducts = JSON.parse(stored);
            }
        }

        // 3. 現在のページのチェックボックス状態を復元
        const checkboxes = document.querySelectorAll('.product-checkbox');
        checkboxes.forEach(cb => {
            if (selectedProducts.hasOwnProperty(cb.value)) {
                cb.checked = true;
            }
        });

        // 4. 削除ボタンの表示更新
        updateDeleteUI();
    });

    // チェックボックス変更時の処理
    function handleCheckboxChange(checkbox) {
        if (checkbox.checked) {
            // オブジェクトに追加
            selectedProducts[checkbox.value] = checkbox.getAttribute('data-name');
        } else {
            // オブジェクトから削除
            delete selectedProducts[checkbox.value];
        }
        // SessionStorageに保存
        sessionStorage.setItem('selectedProducts', JSON.stringify(selectedProducts));

        updateDeleteUI();
    }

    // 削除UIの更新 (ボタン表示/非表示 + 件数)
    function updateDeleteUI() {
        const count = Object.keys(selectedProducts).length;
        const btnContainer = document.getElementById('deleteBtnContainer');
        const countDisplay = document.getElementById('countDisplay');

        if (count > 0) {
            btnContainer.style.display = 'block';
            countDisplay.innerText = count;
        } else {
            btnContainer.style.display = 'none';
            // 確認画面表示中にすべての選択を解除した場合、元の画面に戻す
            if (document.getElementById('deleteConfirmContainer').style.display === 'block') {
                cancelDelete();
            }
        }
    }

    // --- 以下、既存のUI操作関数 ---

    // 編集フォームに入力値をセット
    function fillForm(id, name, category) {
        // 削除確認中は編集不可
        if(document.getElementById('deleteConfirmContainer').style.display === 'block') return;
        document.getElementById('editId').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editCategory').value = category;

        // アラートを非表示
        document.querySelectorAll('.alert').forEach(a => a.style.display = 'none');
    }

    // フォームのリセット
    function resetForm() {
        document.getElementById('ProductActionForm').reset();
        document.getElementById('editId').value = "";
    }

    // 削除確認画面の表示 (DOMではなくメモリ上のデータを使用)
    function showDeleteConfirmation() {
        const listContainer = document.getElementById('selectedItemsList');
        const editMode = document.getElementById('editModeContainer');
        const confirmMode = document.getElementById('deleteConfirmContainer');
        const confirmCount = document.getElementById('confirmCount');

        listContainer.innerHTML = '';
        const keys = Object.keys(selectedProducts);

        // オブジェクトをループして商品名を表示
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

    // 削除キャンセル
    function cancelDelete() {
        document.getElementById('editModeContainer').style.display = 'block';
        document.getElementById('deleteConfirmContainer').style.display = 'none';
    }

    // 一括削除の実行
    function confirmBulkDelete() {
        const form = document.getElementById('BulkDeleteForm');
        const hiddenContainer = document.getElementById('hiddenInputsContainer');

        // 古いinputがあれば削除
        hiddenContainer.innerHTML = '';

        // メモリ内にある全ての商品ID分のhidden inputを生成 (他ページ分含む)
        for (const [id, name] of Object.entries(selectedProducts)) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'deleteIds'; // サーバー側はこの名前で配列を受け取る
            input.value = id;
            hiddenContainer.appendChild(input);
        }

        form.submit();
        // 送信後、SessionStorageの削除は次回のonloadイベント(フラッシュメッセージ判定)で行われる
    }
</script>

<%
    // ページ基本設定
	request.setAttribute("pageTitle", "商品管理");
	request.setAttribute("currentMenu", "product");

	@SuppressWarnings("unchecked")
	List<Product> productList = (List<Product>) request.getAttribute("products");

	String message = (String) request.getAttribute("message");
	String error = (String) request.getAttribute("error");

	@SuppressWarnings("unchecked")
	List<String> existingCategories = (List<String>) request.getAttribute("categories");

    // 左カラム生成
	String body1 = createBody1Content(productList, request.getContextPath());
	request.setAttribute("pageContentBody1", body1);

    // 右カラム生成
	String body2 = createBody2Content(request.getContextPath(), message, error, existingCategories);
	request.setAttribute("pageContentBody2", body2);
%>

<c:import url="/admin/Ad_base.jsp" />