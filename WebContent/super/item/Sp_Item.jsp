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
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); height: calc(100vh - 40px); /* 高さを固定 */
    position: fixed; left: 270px; right: 20px; top: 20px;
    display: flex; flex-direction: column; /* 中身を縦に並べる */
}
.logo { font-size: 32px; font-weight: bold; text-align: center; margin-bottom: 40px; }
.menu-btn { width: 100%; margin-bottom: 15px; }

/* 左右のリストの長さを揃えるための設定 */
.table-header-area {
    height: 40px; /* タイトル部分の高さを固定して左右で揃える */
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 10px;
}

.table-scroll-container {
    flex-grow: 1; /* カードの残りの高さを埋める */
    height: calc(100vh - 300px); /* 画面サイズに合わせて自動調整 */
    overflow-y: auto;
    border: 1px solid #dee2e6;
    border-radius: 5px;
    background-color: #fff;
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
        <img src="<%= request.getContextPath() %>/pic/recook_logo.png" alt="Re.Cook Logo" style="width: 200px;">
    </div>
    <button class="btn btn-outline-dark menu-btn">商品</button>
    <button class="btn btn-outline-dark menu-btn">値引き商品</button>
    <button class="btn btn-outline-dark menu-btn">クーポン</button>
    <!-- サイドバー内のログアウト部分 -->
	<a href="<%= request.getContextPath() %>/super/account/Sp_LogoutConfirm.jsp"
	   class="btn btn-outline-dark menu-btn">
	   ログアウト
	</a>
</div>

<div class="container-fluid">
    <div class="main-card">
        <h4 class="text-center mb-2">商品ページ</h4>
        <hr class="mb-3">

        <!-- 重複エラーメッセージ表示 -->
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert" style="font-size: 0.9rem; padding: 0.5rem 1rem;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" style="padding: 0.75rem;"></button>
            </div>
            <c:remove var="errorMsg" scope="session" />
        </c:if>

        <div class="row flex-grow-1" style="min-height: 0;"> <!-- min-height: 0 はスクロールのために必要 -->

            <!-- 左：商品マスタ一覧 -->
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
                                    <th style="width: 60px;">ID</th>
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
                                        <td>${p.productId}</td>
                                        <td>${p.productName}</td>
                                        <td>${p.category}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </form>
            </div>

            <!-- 右：自店舗商品一覧 -->
            <div class="col-md-7 d-flex flex-column">
                <div class="table-header-area">
                    <h5 class="mb-0">自店舗商品一覧</h5>
                    <!-- 右側にはボタンがないが、高さを揃えるためのダミー領域 -->
                    <div></div>
                </div>
                <div class="table-scroll-container">
                    <table class="table table-bordered table-hover mb-0 align-middle">
                        <thead>
                            <tr>
                                <th>商品名</th>
                                <th>カテゴリ</th>
                                <th style="width: 100px;">価格(円)</th>
                                <th style="width: 130px;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="sp" items="${storeProductList}">
                                <tr>
                                    <form action="<%= request.getContextPath() %>/super/storeAction" method="post" style="display: contents;">
                                        <input type="hidden" name="storeProductId" value="${sp.storeProductId}">
                                        <td>${sp.productName}</td>
                                        <td>${sp.category}</td>
                                        <td>
                                            <input type="number" name="price" value="${sp.price}"
                                                   class="form-control form-control-sm text-end" min="0">
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group">
                                                <button type="submit" name="action" value="update" class="btn btn-sm btn-success">更新</button>
                                                <button type="submit" name="action" value="delete" class="btn btn-sm btn-danger"
                                                        onclick="return confirm('削除しますか？')">削除</button>
                                            </div>
                                        </td>
                                    </form>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div> <!-- row -->
    </div> <!-- main-card -->
</div> <!-- container -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>