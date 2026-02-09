<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List" %>
<%@ page import="bean.CookMenu" %>
<%@ page import="bean.Product" %>

<%!
    // ==========================================
    // Body 1: 左カラム（料理一覧リスト & 検索）
    // ==========================================
    private String createBody1Content(List<String[]> recipes, List<CookMenu> fullRecipes, String contextPath) {
        StringBuilder sb = new StringBuilder();
        sb.append("<h4 class=\"mb-4 text-dark\">料理一覧</h4>");

        // --- 検索フォーム ---
        sb.append("<form action=\"RecipeServlet\" method=\"get\" class=\"mb-4\">");
        sb.append("<div class=\"input-group\">");
        sb.append("<input type=\"text\" name=\"searchName\" class=\"form-control form-control-line\" placeholder=\"料理名で検索...\">");
        sb.append("<button class=\"btn btn-dark\" type=\"submit\">検索</button>");
        sb.append("</div>");
        sb.append("</form>");

        // --- 一括削除フォーム ---
        sb.append("<form id=\"BulkDeleteForm\" action=\"RecipeServlet\" method=\"post\">");
        sb.append("<input type=\"hidden\" name=\"action\" value=\"bulkDelete\">");

        sb.append("<div class=\"table-responsive\">");
        sb.append("<table class=\"table table-hover recipe-list-table\">");
        sb.append("<thead><tr class=\"table-secondary\">");
        sb.append("<th>料理名</th>");
        sb.append("<th style=\"width: 80px; text-align: center;\">");

        // 削除ボタン (チェックボックス選択時に表示)
        sb.append("<div id=\"deleteBtnContainer\" style=\"display: none;\">");
        sb.append("<button type=\"button\" onclick=\"showDeleteConfirmation()\" class=\"btn btn-danger btn-sm\">削除</button>");
        sb.append("</div>");

        sb.append("</th></tr></thead>");
        sb.append("<tbody>");

        if (recipes != null && !recipes.isEmpty()) {
            for (int i = 0; i < recipes.size(); i++) {
                String[] r = recipes.get(i);
                CookMenu detail = fullRecipes.get(i); // 詳細データ

                String id = r[0];
                String name = r[1];
                String genre = r[2];
                String time = r[3];
                // JSのエラー回避のためエスケープ処理
                String descSafe = (detail.getDescription() != null) ? detail.getDescription().replace("\"", "&quot;").replace("\n", "\\n").replace("\r", "") : "";
                String imageName = (detail.getImage() != null) ? detail.getImage() : "";

                // 使用食材(Product)リストをJSON配列文字列に変換してJSに渡す
                StringBuilder tagsJson = new StringBuilder("[");
                if(detail.getProductList() != null) {
                    for(int k=0; k<detail.getProductList().size(); k++) {
                        tagsJson.append("\"").append(detail.getProductList().get(k).getProductName().replace("\"", "\\\"")).append("\"");
                        if(k < detail.getProductList().size() - 1) tagsJson.append(",");
                    }
                }
                tagsJson.append("]");

                sb.append("<tr>");
                sb.append("<td><span class=\"me-2\">・</span>");
                // 料理名リンク (クリックで編集フォームへ値をセット)
                sb.append("<a href=\"#\" class=\"text-dark text-decoration-none\" onclick='fillForm(")
                  .append("\"").append(id).append("\", ")
                  .append("\"").append(name.replace("'", "\\'")).append("\", ")
                  .append("\"").append(genre).append("\", ")
                  .append("\"").append(time).append("\", ")
                  .append("\"").append(descSafe).append("\", ")
                  .append(tagsJson.toString()).append(", ")
                  .append("\"").append(imageName).append("\"")
                  .append("); return false;'>");
                sb.append(name);
                sb.append("</a></td>");

                // 削除用チェックボックス
                sb.append("<td style=\"text-align: center;\">");
                sb.append("<input type=\"checkbox\" name=\"deleteIds\" value=\"").append(id).append("\" data-name=\"").append(name).append("\" class=\"recipe-checkbox\" onchange=\"toggleDeleteButton()\">");
                sb.append("</td></tr>");
            }
        } else {
             sb.append("<tr><td colspan=\"2\" class=\"text-center\">料理が登録されていません。</td></tr>");
        }
        sb.append("</tbody></table></div></form>");
        return sb.toString();
    }

    // ==========================================
    // Body 2: 右カラム（入力フォーム + 削除確認）
    // ==========================================
    private String createBody2Content(List<String> categories, String message, String error) {
        StringBuilder sb = new StringBuilder();

        // --- 通知メッセージエリア ---
        if (error != null && !error.isEmpty()) {
            sb.append("<div class=\"alert alert-danger alert-dismissible fade show mb-4 custom-alert\" role=\"alert\">");
            sb.append("<i class=\"bi bi-exclamation-triangle-fill me-2\"></i>").append(error);
            sb.append("<button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button></div>");
        }
        if (message != null && !message.isEmpty()) {
            sb.append("<div class=\"alert alert-success alert-dismissible fade show mb-4 custom-alert\" role=\"alert\">");
            sb.append("<i class=\"bi bi-check-circle-fill me-2\"></i>").append(message);
            sb.append("<button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button></div>");
        }

        // --- 編集モード ---
        sb.append("<div id=\"editModeContainer\">");
        sb.append("<h4 class=\"mb-4 text-dark\">料理編集・追加</h4>");

        sb.append("<form id=\"RecipeActionForm\" action=\"RecipeServlet\" method=\"post\" enctype=\"multipart/form-data\" onsubmit=\"return validateForm()\">");
        sb.append("<input type=\"hidden\" id=\"editId\" name=\"recipeId\">");
        sb.append("<input type=\"hidden\" name=\"action\" value=\"save\">");

        sb.append("<div class=\"row\">");

        // --- 左カラム (基本情報・食材) ---
        sb.append("<div class=\"col-md-7\">");
        sb.append("<div class=\"mb-3\"><label class=\"form-label fw-bold\">料理名</label>");
        sb.append("<input type=\"text\" id=\"editName\" name=\"recipeName\" class=\"form-control form-control-line\" required></div>");

        // ジャンル選択
        sb.append("<div class=\"mb-3 position-relative\"><label class=\"form-label fw-bold\">ジャンル</label>");
        sb.append("<select id=\"editCategory\" name=\"category\" class=\"form-select form-control-line\" onchange=\"clearGenreError()\">");
        sb.append("<option value=\"\" disabled selected>選択してください</option>");
        if(categories != null) {
            for (String cat : categories) {
                sb.append("<option value=\"").append(cat).append("\">").append(cat).append("</option>");
            }
        }
        sb.append("</select>");
        sb.append("<div id=\"genreError\" class=\"text-danger small mt-1\" style=\"display: none;\"><i class=\"bi bi-exclamation-circle\"></i> ジャンル選択してください</div>");
        sb.append("</div>");

        // 使用商品 (Product) 入力 & オートコンプリート
        sb.append("<div class=\"mb-3 position-relative\"><label class=\"form-label fw-bold\">使用商品 (Product)</label>");
        sb.append("<div class=\"input-group mb-2\">");
        sb.append("<input type=\"text\" id=\"productSearchInput\" class=\"form-control\" placeholder=\"商品名を入力...\" autocomplete=\"off\" oninput=\"handleProductInput(this)\">");
        sb.append("<button class=\"btn btn-outline-secondary\" type=\"button\" onclick=\"addProductTag()\">追加</button>");
        sb.append("</div>");

        // 候補リスト
        sb.append("<ul id=\"suggestionList\" class=\"list-group position-absolute w-100 shadow\" style=\"z-index: 1000; display: none; max-height: 200px; overflow-y: auto;\"></ul>");

        // エラーメッセージ（重複 & 見つからない）
        sb.append("<div id=\"productDuplicateError\" class=\"text-danger small mb-2\" style=\"display: none;\"><i class=\"bi bi-exclamation-circle\"></i> この商品は既に追加されました。</div>");
        sb.append("<div id=\"productNotFoundError\" class=\"text-danger small mb-2\" style=\"display: none;\"><i class=\"bi bi-x-circle\"></i> 商品のデータ見つかりません。</div>");

        // 追加されたタグを表示するエリア
        sb.append("<div id=\"productTagsContainer\" class=\"border rounded p-2 bg-white\" style=\"min-height: 60px;\">");
        sb.append("<small class=\"text-muted fst-italic ms-1\">追加された商品はここに表示されます</small></div>");

        // 送信用の Hidden Input コンテナ
        sb.append("<div id=\"hiddenProductInputs\"></div></div>");
        sb.append("</div>");

        // --- 右カラム (画像・時間) ---
        sb.append("<div class=\"col-md-5\">");

        // 写真アップロード
        sb.append("<div class=\"mb-3\">");
        sb.append("<label class=\"form-label fw-bold\">写真</label>");
        sb.append("<div id=\"imagePreviewContainer\" class=\"mb-2 p-1 border rounded text-center\" style=\"display:none; background-color: #f8f9fa;\">");
        sb.append("<img id=\"imagePreview\" src=\"\" alt=\"Current Image\" style=\"max-width: 100%; max-height: 200px; height: auto; display: block; margin: 0 auto;\">");
        sb.append("<div class=\"small text-muted mt-1\">現在の写真</div>");
        sb.append("</div>");
        sb.append("<input type=\"file\" id=\"recipeImageInput\" name=\"recipeImage\" class=\"form-control\" accept=\"image/*\" onchange=\"clearImageError()\">");
        sb.append("<div id=\"imageError\" class=\"text-danger small mt-1\" style=\"display: none;\"><i class=\"bi bi-exclamation-circle\"></i> ファイルが選択されていません</div>");
        sb.append("</div>");

        // 料理時間 (バリデーション付き)
        sb.append("<div class=\"mb-3\"><label class=\"form-label fw-bold\">料理時間 (分)</label>");
        sb.append("<input type=\"number\" id=\"editTime\" name=\"cookTime\" class=\"form-control form-control-line\" min=\"1\" placeholder=\"例: 30\" oninput=\"clearTimeError()\">");
        // 時間エラー表示
        sb.append("<div id=\"timeError\" class=\"text-danger small mt-1\" style=\"display: none;\"><i class=\"bi bi-exclamation-circle\"></i> 値は1以上にする必要があります。</div>");
        sb.append("</div>");

        sb.append("</div></div>"); // End col-md-5 & row

        // 説明文
        sb.append("<div class=\"row mt-2\"><div class=\"col-12\"><label class=\"form-label fw-bold\">料理説明</label>");
        sb.append("<textarea id=\"editDesc\" name=\"recipeDescription\" class=\"form-control\" rows=\"4\" required></textarea></div></div>");

        // ボタン
        sb.append("<div class=\"row mt-4\"><div class=\"col-12 d-flex justify-content-end gap-3\">");
        sb.append("<button type=\"button\" onclick=\"resetForm()\" class=\"btn btn-outline-dark btn-large-stacked\">クリア</button>");
        sb.append("<button type=\"submit\" class=\"btn btn-dark btn-large-stacked\">追加/更新</button>");
        sb.append("</div></div></form></div>");

        // --- 削除確認画面 ---
        sb.append("<div id=\"deleteConfirmContainer\" style=\"display: none;\">");
        sb.append("<h4 class=\"mb-4 text-danger\">削除の確認</h4>");
        sb.append("<div class=\"alert alert-light border border-danger mb-4\"><p class=\"fw-bold\">以下の料理が削除されます。よろしいですか？</p><ul id=\"selectedItemsList\" class=\"list-group list-group-flush\"></ul></div>");
        sb.append("<div class=\"d-flex justify-content-end gap-3\"><button type=\"button\" onclick=\"cancelDelete()\" class=\"btn btn-outline-dark btn-large-stacked\">戻る</button><button type=\"button\" onclick=\"confirmBulkDelete()\" class=\"btn btn-danger btn-large-stacked\">確認</button></div></div>");

        return sb.toString();
    }
%>

<%
    request.setAttribute("pageTitle", "料理管理");

    // Controllerから渡されたデータ取得
    List<String[]> recipeList = (List<String[]>) request.getAttribute("recipes");
    List<CookMenu> fullRecipes = (List<CookMenu>) request.getAttribute("recipeObjects");
    List<String> categories = (List<String>) request.getAttribute("categories");
    String jsonAllProductNames = (String) request.getAttribute("jsonAllProductNames");
    if(jsonAllProductNames == null) jsonAllProductNames = "[]";
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");

    String body1Content = createBody1Content(recipeList, fullRecipes, request.getContextPath());
    String body2Content = createBody2Content(categories, message, error);

    request.setAttribute("pageContentBody1", body1Content);
    request.setAttribute("pageContentBody2", body2Content);
%>

<c:import url="../../admin/Ad_base.jsp" />

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
    .btn-large-stacked { width: 150px; height: 60px; font-weight: bold; }
    .product-tag { display: inline-flex; align-items: center; background: #e9ecef; padding: 5px 10px; border-radius: 20px; margin: 2px; border: 1px solid #ced4da; }
    .product-tag .remove-tag-btn { margin-left: 8px; cursor: pointer; color: #888; font-weight: bold; }
    .product-tag .remove-tag-btn:hover { color: #dc3545; }
    #suggestionList .list-group-item { cursor: pointer; }
    #suggestionList .list-group-item:hover { background-color: #f8f9fa; }
</style>

<script>
    // サーバーから渡された全商品リスト
    const dbProductList = <%= jsonAllProductNames %>;
    // 現在選択されている商品リスト
    let selectedProducts = [];
    const contextPath = "${pageContext.request.contextPath}";

    // ドキュメント全体のクリックイベント（閉じる処理など）
    document.addEventListener('click', function(event) {
        const alerts = document.querySelectorAll('.custom-alert');
        if (alerts.length > 0) {
            alerts.forEach(alert => { alert.style.display = 'none'; });
        }
        if (event.target !== document.getElementById('productSearchInput')) {
            document.getElementById('suggestionList').style.display = 'none';
        }
    });

    // --- フォームバリデーション ---
    function validateForm() {
        let isValid = true;

        // 1. ジャンルチェック
        const genreSelect = document.getElementById('editCategory');
        if (genreSelect.value === "") {
            document.getElementById('genreError').style.display = 'block';
            if(isValid) genreSelect.focus();
            isValid = false;
        }

        // 2. 料理時間チェック
        const timeInput = document.getElementById('editTime');
        const timeError = document.getElementById('timeError');
        const timeVal = timeInput.value;
        timeError.style.display = 'none';

        // 空文字 または 1未満の場合
        if (timeVal === "" || parseInt(timeVal) < 1) {
            timeError.style.display = 'block';
            if(isValid) timeInput.focus();
            isValid = false;
        }

        // 3. 画像チェック（新規登録時のみ必須）
        const imageInput = document.getElementById('recipeImageInput');
        const editId = document.getElementById('editId').value;
        const hasOldImage = (document.getElementById('imagePreviewContainer').style.display !== 'none');

        if (imageInput.files.length === 0) {
            if (editId === "" || !hasOldImage) {
                document.getElementById('imageError').style.display = 'block';
                if(isValid) imageInput.focus();
                isValid = false;
            }
        }
        return isValid;
    }

    // エラーリセット関数
    function clearGenreError() { document.getElementById('genreError').style.display = 'none'; }
    function clearImageError() { document.getElementById('imageError').style.display = 'none'; }
    function clearTimeError() { document.getElementById('timeError').style.display = 'none'; }

    // --- 商品検索＆タグ追加ロジック ---

    function handleProductInput(input) {
        const val = input.value.trim().toUpperCase();
        const suggestionList = document.getElementById('suggestionList');
        const errorDiv = document.getElementById('productNotFoundError');
        const dupErrorDiv = document.getElementById('productDuplicateError');

        // 入力中はエラーを一旦消す
        errorDiv.style.display = 'none';
        dupErrorDiv.style.display = 'none';

        suggestionList.innerHTML = '';
        if (!val) {
            suggestionList.style.display = 'none'; return;
        }

        // 部分一致検索
        const matches = dbProductList.filter(p => p.toUpperCase().indexOf(val) > -1);

        if (matches.length > 0) {
            matches.forEach(productName => {
                const li = document.createElement('li');
                li.className = 'list-group-item list-group-item-action';
                li.textContent = productName;
                li.onclick = function() {
                    addTagToUI(productName);
                    input.value = '';
                    suggestionList.style.display = 'none';
                    errorDiv.style.display = 'none';
                    dupErrorDiv.style.display = 'none';
                };
                suggestionList.appendChild(li);
            });
            suggestionList.style.display = 'block';
        } else {
            suggestionList.style.display = 'none';
            errorDiv.style.display = 'block';
        }
    }

    function addProductTag() {
        const input = document.getElementById('productSearchInput');
        const productName = input.value.trim();
        const errorDiv = document.getElementById('productNotFoundError');
        const dupErrorDiv = document.getElementById('productDuplicateError');

        errorDiv.style.display = 'none';
        dupErrorDiv.style.display = 'none';

        if (productName === "") return;

        // DBに存在するかチェック
        const existsInDB = dbProductList.find(p => p.toUpperCase() === productName.toUpperCase());

        if (existsInDB) {
            // 重複チェック
            if (selectedProducts.includes(existsInDB)) {
                dupErrorDiv.style.display = 'block';
            } else {
                addTagToUI(existsInDB);
                input.value = "";
                document.getElementById('suggestionList').style.display = 'none';
            }
        } else {
            errorDiv.style.display = 'block';
            document.getElementById('suggestionList').style.display = 'none';
        }
        input.focus();
    }

    function addTagToUI(productName) {
        if (selectedProducts.includes(productName)) {
            document.getElementById('productDuplicateError').style.display = 'block';
            return;
        }

        selectedProducts.push(productName);
        const container = document.getElementById('productTagsContainer');
        const hiddenInputsContainer = document.getElementById('hiddenProductInputs');

        // プレースホルダー削除
        const placeholder = container.querySelector('.text-muted');
        if (placeholder) placeholder.remove();

        const tagSpan = document.createElement('span');
        tagSpan.className = 'product-tag';
        // 削除ボタンにエスケープ処理を入れてイベント設定
        tagSpan.innerHTML = productName + ` <span class="remove-tag-btn" onclick="removeProductTag(this, '` + productName.replace(/'/g, "\\'") + `')">&times;</span>`;
        container.appendChild(tagSpan);

        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'productNames';
        hiddenInput.value = productName;
        hiddenInputsContainer.appendChild(hiddenInput);
    }

    // 【重要】 商品タグ削除関数
    // ループを使って確実に hidden input を削除するように修正
    function removeProductTag(element, productName) {
        // 1. 画面上のタグ削除
        element.parentElement.remove();

        // 2. 配列から削除
        selectedProducts = selectedProducts.filter(item => item !== productName);

        // 3. Hidden Input を削除
        const container = document.getElementById('hiddenProductInputs');
        const inputs = container.getElementsByTagName('input');
        for (let i = 0; i < inputs.length; i++) {
            if (inputs[i].value === productName) {
                container.removeChild(inputs[i]);
                break;
            }
        }

        // 4. 空になったらプレースホルダーを表示
        if (selectedProducts.length === 0) {
            document.getElementById('productTagsContainer').innerHTML = '<small class="text-muted fst-italic ms-1">追加された商品はここに表示されます</small>';
        }
    }

    // --- フォームへの値セット（編集ボタン） ---
    function fillForm(id, name, genre, time, desc, tagsArray, imageName) {
        if(document.getElementById('deleteConfirmContainer').style.display === 'block') return;
        resetForm();
        document.getElementById('editId').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editTime').value = time;
        document.getElementById('editDesc').value = desc;
        const select = document.getElementById('editCategory');
        for (let i = 0; i < select.options.length; i++) {
            if (select.options[i].value === genre) { select.selectedIndex = i; break; }
        }
        if(tagsArray && tagsArray.length > 0) {
            tagsArray.forEach(prodName => { addTagToUI(prodName); });
        }
        if (imageName && imageName.trim() !== "") {
            const imgPath = contextPath + "/pic/" + imageName;
            document.getElementById('imagePreview').src = imgPath;
            document.getElementById('imagePreviewContainer').style.display = "block";
        }
    }

    // --- リセット処理 ---
    function resetForm() {
        document.getElementById('RecipeActionForm').reset();
        document.getElementById('editId').value = "";
        selectedProducts = [];
        document.getElementById('productTagsContainer').innerHTML = '<small class="text-muted fst-italic ms-1">追加された商品はここに表示されます</small>';
        document.getElementById('hiddenProductInputs').innerHTML = '';

        document.getElementById('imagePreview').src = "";
        document.getElementById('imagePreviewContainer').style.display = "none";

        clearGenreError(); clearImageError(); clearTimeError();

        document.getElementById('productNotFoundError').style.display = 'none';
        document.getElementById('productDuplicateError').style.display = 'none';
        document.getElementById('suggestionList').style.display = 'none';
    }

    // エンターキーでのsubmit防止（タグ追加にする）
    document.getElementById('productSearchInput').addEventListener("keypress", function(e) {
        if (e.key === "Enter") { e.preventDefault(); addProductTag(); }
    });

    // --- 一括削除関連 ---
    function toggleDeleteButton() {
        const checkboxes = document.querySelectorAll('.recipe-checkbox:checked');
        document.getElementById('deleteBtnContainer').style.display = checkboxes.length > 0 ? 'block' : 'none';
    }
    function showDeleteConfirmation() {
        const checkboxes = document.querySelectorAll('.recipe-checkbox:checked');
        const list = document.getElementById('selectedItemsList');
        list.innerHTML = '';
        checkboxes.forEach(cb => {
            list.innerHTML += '<li class="list-group-item bg-transparent">・ ' + cb.getAttribute('data-name') + '</li>';
        });
        document.getElementById('editModeContainer').style.display = 'none';
        document.getElementById('deleteConfirmContainer').style.display = 'block';
    }
    function cancelDelete() {
        document.getElementById('editModeContainer').style.display = 'block';
        document.getElementById('deleteConfirmContainer').style.display = 'none';
    }
    function confirmBulkDelete() {
        document.getElementById('BulkDeleteForm').submit();
    }
</script>