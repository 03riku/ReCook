<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List" %>
<%@ page import="bean.CookMenu" %>
<%@ page import="bean.Product" %>

<%!
    // Body 1: Danh sách món ăn
    private String createBody1Content(List<String[]> recipes, List<CookMenu> fullRecipes, String contextPath) {
        // ... (Giữ nguyên code phần Body 1 như cũ) ...
        StringBuilder sb = new StringBuilder();
        sb.append("<h4 class=\"mb-4 text-dark\">料理一覧</h4>");
        sb.append("<form action=\"RecipeServlet\" method=\"get\" class=\"mb-4\">");
        sb.append("<div class=\"input-group\">");
        sb.append("<input type=\"text\" name=\"searchName\" class=\"form-control form-control-line\" placeholder=\"料理名で検索...\">");
        sb.append("<button class=\"btn btn-dark\" type=\"submit\">検索</button>");
        sb.append("</div></form>");

        sb.append("<form id=\"BulkDeleteForm\" action=\"RecipeServlet\" method=\"post\">");
        sb.append("<input type=\"hidden\" name=\"action\" value=\"bulkDelete\">");
        sb.append("<div class=\"table-responsive\">");
        sb.append("<table class=\"table table-hover recipe-list-table\">");
        sb.append("<thead><tr class=\"table-secondary\"><th>料理名</th><th style=\"width: 80px; text-align: center;\">");
        sb.append("<div id=\"deleteBtnContainer\" style=\"display: none;\">");
        sb.append("<button type=\"button\" onclick=\"showDeleteConfirmation()\" class=\"btn btn-danger btn-sm\">削除</button>");
        sb.append("</div></th></tr></thead><tbody>");

        if (recipes != null && !recipes.isEmpty()) {
            for (int i = 0; i < recipes.size(); i++) {
                String[] r = recipes.get(i);
                CookMenu detail = fullRecipes.get(i);
                String id = r[0];
                String name = r[1];
                String genre = r[2];
                String time = r[3];
                String descSafe = (detail.getDescription() != null) ? detail.getDescription().replace("\"", "&quot;").replace("\n", "\\n").replace("\r", "") : "";

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
                sb.append("<a href=\"#\" class=\"text-dark text-decoration-none\" onclick='fillForm(")
                  .append("\"").append(id).append("\", ")
                  .append("\"").append(name.replace("'", "\\'")).append("\", ")
                  .append("\"").append(genre).append("\", ")
                  .append("\"").append(time).append("\", ")
                  .append("\"").append(descSafe).append("\", ")
                  .append(tagsJson.toString())
                  .append("); return false;'>");
                sb.append(name);
                sb.append("</a></td>");
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

    private String createBody2Content(List<String> categories, String message, String error) {
        StringBuilder sb = new StringBuilder();

        // Hiển thị thông báo Lỗi/Thành công
        if (error != null && !error.isEmpty()) {
            sb.append("<div class=\"alert alert-danger alert-dismissible fade show mb-4\" role=\"alert\">");
            sb.append("<i class=\"bi bi-exclamation-triangle-fill me-2\"></i>").append(error);
            sb.append("<button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button></div>");
        }
        if (message != null && !message.isEmpty()) {
            sb.append("<div class=\"alert alert-success alert-dismissible fade show mb-4\" role=\"alert\">");
            sb.append("<i class=\"bi bi-check-circle-fill me-2\"></i>").append(message);
            sb.append("<button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button></div>");
        }

        sb.append("<div id=\"editModeContainer\">");
        sb.append("<h4 class=\"mb-4 text-dark\">料理編集・追加</h4>");

        // Form
        sb.append("<form id=\"RecipeActionForm\" action=\"RecipeServlet\" method=\"post\" enctype=\"multipart/form-data\" onsubmit=\"return validateForm()\">");
        sb.append("<input type=\"hidden\" id=\"editId\" name=\"recipeId\">");
        sb.append("<input type=\"hidden\" name=\"action\" value=\"save\">");

        sb.append("<div class=\"row\">");
        sb.append("<div class=\"col-md-7\">");

        // Name
        sb.append("<div class=\"mb-3\"><label class=\"form-label fw-bold\">料理名</label>");
        sb.append("<input type=\"text\" id=\"editName\" name=\"recipeName\" class=\"form-control form-control-line\" required></div>");

        // Genre (Có validation)
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

        // Tags
        sb.append("<div class=\"mb-3 position-relative\"><label class=\"form-label fw-bold\">使用商品 (Product)</label>");
        sb.append("<div class=\"input-group mb-2\">");
        sb.append("<input type=\"text\" id=\"productSearchInput\" class=\"form-control\" placeholder=\"商品名を入力...\" autocomplete=\"off\" oninput=\"handleProductInput(this)\">");
        sb.append("<button class=\"btn btn-outline-secondary\" type=\"button\" onclick=\"addProductTag()\">追加</button>");
        sb.append("</div>");
        sb.append("<ul id=\"suggestionList\" class=\"list-group position-absolute w-100 shadow\" style=\"z-index: 1000; display: none; max-height: 200px; overflow-y: auto;\"></ul>");
        sb.append("<div id=\"productNotFoundError\" class=\"text-danger small mb-2\" style=\"display: none;\"><i class=\"bi bi-x-circle\"></i> 商品のデータ見つかりません。</div>");
        sb.append("<div id=\"productTagsContainer\" class=\"border rounded p-2 bg-white\" style=\"min-height: 60px;\">");
        sb.append("<small class=\"text-muted fst-italic ms-1\">追加された商品はここに表示されます</small></div>");
        sb.append("<div id=\"hiddenProductInputs\"></div></div>");
        sb.append("</div>");

        // Col Right
        sb.append("<div class=\"col-md-5\">");

        // --- ẢNH (Có validation) ---
        sb.append("<div class=\"mb-3\">");
        sb.append("<label class=\"form-label fw-bold\">写真</label>");
        // Thêm onchange để ẩn lỗi
        sb.append("<input type=\"file\" id=\"recipeImageInput\" name=\"recipeImage\" class=\"form-control\" accept=\"image/*\" onchange=\"clearImageError()\">");
        // [MỚI] Thông báo lỗi Ảnh
        sb.append("<div id=\"imageError\" class=\"text-danger small mt-1\" style=\"display: none;\"><i class=\"bi bi-exclamation-circle\"></i> ファイルが選択されていません</div>");
        sb.append("</div>");

        sb.append("<div class=\"mb-3\"><label class=\"form-label fw-bold\">料理時間 (分)</label>");
        sb.append("<input type=\"number\" id=\"editTime\" name=\"cookTime\" class=\"form-control form-control-line\" min=\"1\" placeholder=\"例: 30\"></div>");
        sb.append("</div></div>");

        // Description
        sb.append("<div class=\"row mt-2\"><div class=\"col-12\"><label class=\"form-label fw-bold\">料理説明</label>");
        sb.append("<textarea id=\"editDesc\" name=\"recipeDescription\" class=\"form-control\" rows=\"4\" required></textarea></div></div>");

        // Buttons
        sb.append("<div class=\"row mt-4\"><div class=\"col-12 d-flex justify-content-end gap-3\">");
        sb.append("<button type=\"button\" onclick=\"resetForm()\" class=\"btn btn-outline-dark btn-large-stacked\">クリア</button>");
        sb.append("<button type=\"submit\" class=\"btn btn-dark btn-large-stacked\">追加/更新</button>");
        sb.append("</div></div></form></div>");

        // Confirm Delete
        sb.append("<div id=\"deleteConfirmContainer\" style=\"display: none;\">");
        // ... (Giữ nguyên)
        sb.append("<h4 class=\"mb-4 text-danger\">削除の確認</h4>");
        sb.append("<div class=\"alert alert-light border border-danger mb-4\"><p class=\"fw-bold\">以下の料理が削除されます。よろしいですか？</p><ul id=\"selectedItemsList\" class=\"list-group list-group-flush\"></ul></div>");
        sb.append("<div class=\"d-flex justify-content-end gap-3\"><button type=\"button\" onclick=\"cancelDelete()\" class=\"btn btn-outline-dark btn-large-stacked\">戻る</button><button type=\"button\" onclick=\"confirmBulkDelete()\" class=\"btn btn-danger btn-large-stacked\">確認</button></div></div>");

        return sb.toString();
    }
%>

<%
    request.setAttribute("pageTitle", "料理管理");
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
    .form-control-line { border: none; border-bottom: 1px solid #333; border-radius: 0; padding: 5px 0; background: transparent; }
    .form-control-line:focus { border-bottom-color: #007bff; box-shadow: none; }
    .btn-large-stacked { width: 150px; height: 60px; font-weight: bold; }
    .product-tag { display: inline-flex; align-items: center; background: #e9ecef; padding: 5px 10px; border-radius: 20px; margin: 2px; border: 1px solid #ced4da; }
    .product-tag .remove-tag-btn { margin-left: 8px; cursor: pointer; color: #888; font-weight: bold; }
    .product-tag .remove-tag-btn:hover { color: #dc3545; }
    #suggestionList .list-group-item { cursor: pointer; }
    #suggestionList .list-group-item:hover { background-color: #f8f9fa; }
</style>

<script>
    const dbProductList = <%= jsonAllProductNames %>;
    let selectedProducts = [];

    // --- 1. VALIDATION FORM ---
    function validateForm() {
        let isValid = true;

        // A. Validate Genre
        const genreSelect = document.getElementById('editCategory');
        if (genreSelect.value === "") {
            document.getElementById('genreError').style.display = 'block';
            if(isValid) genreSelect.focus(); // Focus vào lỗi đầu tiên
            isValid = false;
        }

        // B. Validate Image (File)
        // Logic: Nếu đang ở chế độ ADD (editId rỗng) -> Bắt buộc chọn ảnh
        // Nếu ở chế độ EDIT (editId có giá trị) -> Không bắt buộc (giữ ảnh cũ)
        // TUY NHIÊN: Theo yêu cầu của bạn "Nếu không chọn thì báo lỗi",
        // tôi sẽ để validate chặt chẽ. Nếu bạn muốn mềm dẻo hơn khi Edit thì sửa dòng dưới.
        const imageInput = document.getElementById('recipeImageInput');
        const editId = document.getElementById('editId').value;

        // Nếu muốn Edit không cần chọn lại ảnh, dùng điều kiện: if (editId === "" && imageInput.files.length === 0)
        // Dưới đây là logic theo yêu cầu "Hiện lỗi khi không chọn":
        if (imageInput.files.length === 0) {
            // Có thể bạn muốn cho phép Edit không cần up lại ảnh.
            // Nếu vậy bỏ comment dòng dưới và comment dòng 'isValid = false'
            if (editId === "") { // Chỉ bắt lỗi khi Thêm mới
               document.getElementById('imageError').style.display = 'block';
               if(isValid) imageInput.focus();
               isValid = false;
            }
        }

        return isValid;
    }

    function clearGenreError() {
        document.getElementById('genreError').style.display = 'none';
    }

    function clearImageError() {
        document.getElementById('imageError').style.display = 'none';
    }

    // --- 2. PRODUCT LOGIC ---
    function handleProductInput(input) {
        const val = input.value.trim().toUpperCase();
        const suggestionList = document.getElementById('suggestionList');
        const errorDiv = document.getElementById('productNotFoundError');

        suggestionList.innerHTML = '';
        if (!val) {
            suggestionList.style.display = 'none';
            errorDiv.style.display = 'none';
            return;
        }
        const matches = dbProductList.filter(p => p.toUpperCase().indexOf(val) > -1 && !selectedProducts.includes(p));
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
                };
                suggestionList.appendChild(li);
            });
            suggestionList.style.display = 'block';
            errorDiv.style.display = 'none';
        } else {
            suggestionList.style.display = 'none';
            errorDiv.style.display = 'block';
        }
    }

    function addProductTag() {
        const input = document.getElementById('productSearchInput');
        const productName = input.value.trim();
        if (productName === "") return;
        const existsInDB = dbProductList.find(p => p.toUpperCase() === productName.toUpperCase());
        if (existsInDB) {
            addTagToUI(existsInDB);
            input.value = "";
            document.getElementById('suggestionList').style.display = 'none';
            document.getElementById('productNotFoundError').style.display = 'none';
        } else {
            document.getElementById('productNotFoundError').style.display = 'block';
            document.getElementById('suggestionList').style.display = 'none';
        }
        input.focus();
    }

    function addTagToUI(productName) {
        if (selectedProducts.includes(productName)) return;
        selectedProducts.push(productName);
        const container = document.getElementById('productTagsContainer');
        const hiddenInputsContainer = document.getElementById('hiddenProductInputs');
        if (selectedProducts.length === 1) container.innerHTML = "";
        const tagSpan = document.createElement('span');
        tagSpan.className = 'product-tag';
        tagSpan.innerHTML = productName + ` <span class="remove-tag-btn" onclick="removeProductTag(this, '` + productName + `')">&times;</span>`;
        container.appendChild(tagSpan);
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'productNames';
        hiddenInput.value = productName;
        hiddenInput.setAttribute('data-tag-name', productName);
        hiddenInputsContainer.appendChild(hiddenInput);
    }

    function removeProductTag(element, productName) {
        element.parentElement.remove();
        selectedProducts = selectedProducts.filter(item => item !== productName);
        const hiddenInput = document.querySelector(`input[name='productNames'][value='${productName}']`);
        if(hiddenInput) hiddenInput.remove();
        if (selectedProducts.length === 0) {
            document.getElementById('productTagsContainer').innerHTML = '<small class="text-muted fst-italic ms-1">追加された商品はここに表示されます</small>';
        }
    }

    // --- 3. FILL & RESET ---
    function fillForm(id, name, genre, time, desc, tagsArray) {
        if(document.getElementById('deleteConfirmContainer').style.display === 'block') return;
        resetForm();

        document.getElementById('editId').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editTime').value = time;
        document.getElementById('editDesc').value = desc;

        const select = document.getElementById('editCategory');
        for (let i = 0; i < select.options.length; i++) {
            if (select.options[i].value === genre) {
                select.selectedIndex = i;
                break;
            }
        }
        if(tagsArray && tagsArray.length > 0) {
            document.getElementById('productTagsContainer').innerHTML = "";
            tagsArray.forEach(prodName => {
                addTagToUI(prodName);
            });
        }
    }

    function resetForm() {
        document.getElementById('RecipeActionForm').reset();
        document.getElementById('editId').value = "";
        selectedProducts = [];
        document.getElementById('productTagsContainer').innerHTML = '<small class="text-muted fst-italic ms-1">追加された商品はここに表示されます</small>';
        document.getElementById('hiddenProductInputs').innerHTML = '';

        clearGenreError();
        clearImageError(); // Xóa lỗi ảnh
        document.getElementById('productNotFoundError').style.display = 'none';
        document.getElementById('suggestionList').style.display = 'none';
    }

    document.addEventListener('click', function(e) {
        if (e.target !== document.getElementById('productSearchInput')) {
            document.getElementById('suggestionList').style.display = 'none';
        }
    });

    document.getElementById('productSearchInput').addEventListener("keypress", function(e) {
        if (e.key === "Enter") { e.preventDefault(); addProductTag(); }
    });

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