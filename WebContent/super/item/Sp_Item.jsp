<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>商品ページ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<style>
body { background-color: #F5F5F0; }
.sidebar {
    width: 240px; background: #ffffff; padding: 30px 20px; border-radius: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); height: calc(100vh - 40px);
    position: fixed; left: 20px; top: 20px;
}
.main-card {
    background: #ffffff; padding: 30px; border-radius: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); height: calc(100vh - 40px);
    position: fixed; left: 270px; right: 20px; top: 20px;
    display: flex; flex-direction: column;
}
.logo { font-size: 32px; font-weight: bold; text-align: center; margin-bottom: 40px; }
.menu-btn { width: 100%; margin-bottom: 15px; }

.table-header-area {
    height: 40px;
    display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;
}
.table-scroll-container {
    flex-grow: 1; height: calc(100vh - 300px); overflow-y: auto;
    border: 1px solid #dee2e6; border-radius: 5px; background-color: #fff;
}
.table-scroll-container thead th {
    position: sticky; top: 0; background-color: #f8f9fa; z-index: 1;
    border-bottom: 2px solid #dee2e6;
}
</style>
</head>

<body>

<div class="sidebar">
    <div class="logo">
        <img src="<%= request.getContextPath() %>/pic/recook_logo.png" alt="Logo" style="width: 200px;">
    </div>
    <a href="<%= request.getContextPath() %>/super/storeProductPage" class="btn btn-outline-dark menu-btn">商品</a>
    <a href="<%= request.getContextPath() %>/super/discountPage" class="btn btn-outline-dark menu-btn">値引き商品</a>
    <a href="<%= request.getContextPath() %>/super/couponPage" class="btn btn-outline-dark menu-btn">クーポン</a>
    <a href="<%= request.getContextPath() %>/super/account/Sp_LogoutConfirm.jsp" class="btn btn-outline-dark menu-btn">ログアウト</a>
</div>

<div class="container-fluid">
    <div class="main-card">
        <h4 class="text-center mb-2">商品ページ</h4>
        <hr class="mb-3">

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert" style="padding: 0.5rem 1rem;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMsg" scope="session" />
        </c:if>

        <div class="row flex-grow-1" style="min-height: 0;">
            <div class="col-md-5 d-flex flex-column">
                <form action="<%= request.getContextPath() %>/super/addStoreProduct" method="post" class="d-flex flex-column h-100">
                    <div class="table-header-area">
                        <h5 class="mb-0">商品一覧</h5>
                        <button type="submit" class="btn btn-sm btn-primary px-3">追加</button>
                    </div>
                    <div class="table-scroll-container">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th class="text-center" style="width: 50px;">選択</th>
                                    <th>商品名</th>
                                    <th>カテゴリ</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${productList}">
                                    <tr>
                                        <td class="text-center">
                                            <input type="checkbox" name="productIds" value="${p.productId}">
                                        </td>
                                        <td>${p.productName}</td>
                                        <td>${p.category}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </form>
            </div>

            <div class="col-md-7 d-flex flex-column">
                <form action="<%= request.getContextPath() %>/super/storeBulkUpdate" method="post" class="d-flex flex-column h-100">
                    <div class="table-header-area">
                        <h5 class="mb-0">自店舗商品一覧</h5>
                        <button type="submit" id="bulkUpdateBtn" class="btn btn-sm btn-success px-3">一括更新</button>
                    </div>

                    <div class="table-scroll-container">
                        <table class="table table-bordered table-hover mb-0 align-middle">
                            <thead>
                                <tr>
                                    <th>商品名</th>
                                    <th>カテゴリ</th>
                                    <th style="width: 100px;">価格(円)</th>
                                    <th style="width: 80px;">操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sp" items="${storeProductList}">
                                    <tr>
                                        <input type="hidden" name="storeProductIds" value="${sp.storeProductId}">

                                        <td>${sp.productName}</td>
                                        <td>${sp.category}</td>
                                        <td>
                                            <input type="number" name="prices" value="${sp.price}"
                                                   class="form-control form-control-sm text-end" min="0">
                                        </td>
                                        <td class="text-center">
                                            <button type="submit"
                                                    formaction="<%= request.getContextPath() %>/super/storeAction?action=delete"
                                                    name="storeProductId"
                                                    value="${sp.storeProductId}"
                                                    class="btn btn-sm btn-danger"
                                                    onclick="return confirm('本当に削除しますか？')">
                                                削除
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // 一括更新ボタンを取得
    const bulkUpdateBtn = document.getElementById("bulkUpdateBtn");

    if (bulkUpdateBtn) {
        bulkUpdateBtn.addEventListener("click", function(event) {
            // name="prices" の入力欄をすべて取得
            const priceInputs = document.querySelectorAll('input[name="prices"]');
            let hasError = false;

            priceInputs.forEach(function(input) {
                // 値が空かどうかチェック
                if (input.value.trim() === "") {
                    hasError = true;
                    // エラーの入力欄を赤枠にする (Bootstrapのクラス)
                    input.classList.add("is-invalid");
                } else {
                    // エラーがない場合は赤枠を外す
                    input.classList.remove("is-invalid");
                }
            });

            if (hasError) {
                // 送信をキャンセル
                event.preventDefault();
                // メッセージを表示
                alert("数字を入力してください。");
            }
        });
    }
});
</script>

</body>
</html>