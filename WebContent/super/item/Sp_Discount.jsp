<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>値引き商品管理 - Re.Cook</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<style>
body { background-color: #F5F5F0; }
/* サイドバー設定 */
.sidebar {
    width: 240px; background: #ffffff; padding: 30px 20px; border-radius: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); height: calc(100vh - 40px);
    position: fixed; left: 20px; top: 20px;
}
/* メインコンテンツ設定 */
.main-card {
    background: #ffffff; padding: 30px; border-radius: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); height: calc(100vh - 40px);
    position: fixed; left: 270px; right: 20px; top: 20px;
    display: flex; flex-direction: column;
}
.logo { font-size: 32px; font-weight: bold; text-align: center; margin-bottom: 40px; }
.menu-btn { width: 100%; margin-bottom: 15px; }

/* 左右のヘッダーの高さを揃える */
.table-header-area {
    height: 45px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 10px;
}

/* 左右のスクロールコンテナの長さを揃える */
.table-scroll-container {
    flex-grow: 1;
    height: calc(100vh - 300px);
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

<!-- 各JSPのサイドバー部分 -->
<div class="sidebar">
    <div class="logo">
        <img src="<%= request.getContextPath() %>/pic/recook_logo.png" alt="Logo" style="width: 200px;">
    </div>

    <!-- 商品ページへ -->
    <a href="<%= request.getContextPath() %>/super/storeProductPage" class="btn btn-outline-dark menu-btn">商品</a>

    <!-- 値引き商品ページへ -->
    <a href="<%= request.getContextPath() %>/super/discountPage" class="btn btn-outline-dark menu-btn">値引き商品</a>

    <!-- クーポンページへ（サーブレットのパスを指定） -->
    <a href="<%= request.getContextPath() %>/super/couponPage" class="btn btn-outline-dark menu-btn">クーポン</a>

    <!-- ログアウト確認へ -->
    <a href="<%= request.getContextPath() %>/super/account/Sp_LogoutConfirm.jsp" class="btn btn-outline-dark menu-btn">ログアウト</a>
</div>

<!-- メイン画面 -->
<div class="container-fluid">
    <div class="main-card">
        <h4 class="text-center mb-2">値引き商品管理</h4>
        <hr class="mb-3">

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert" style="padding: 0.5rem 1rem;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" style="padding: 0.75rem;"></button>
            </div>
            <c:remove var="errorMsg" scope="session" />
        </c:if>

        <div class="row flex-grow-1" style="min-height: 0;">

            <!-- 左：自店舗商品一覧 -->
            <div class="col-md-5 d-flex flex-column">
                <form action="<%= request.getContextPath() %>/super/addDiscount" method="post" class="d-flex flex-column h-100">
                    <div class="table-header-area">
                        <h5 class="mb-0">自店舗商品一覧</h5>
                        <div class="d-flex align-items-center">
                            <input type="number" name="defaultRate" value="10" class="form-control form-control-sm me-1" style="width: 55px;" min="1" max="99">
                            <span class="me-2" style="font-size: 0.85rem;">%引で</span>
                            <button type="submit" class="btn btn-sm btn-primary px-3">追加</button>
                        </div>
                    </div>
                    <div class="table-scroll-container">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th class="text-center" style="width: 50px;">選択</th>
                                    <th>商品名</th>
                                    <th class="text-end">定価</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sp" items="${storeProductList}">
                                    <tr>
                                        <td class="text-center">
                                            <input type="checkbox" name="productIds" value="${sp.productId}">
                                        </td>
                                        <td>${sp.productName}</td>
                                        <td class="text-end">${sp.price}円</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </form>
            </div>

            <!-- 右：値引き中商品一覧 -->
            <div class="col-md-7 d-flex flex-column">
                <div class="table-header-area">
                    <h5 class="mb-0">値引き中商品一覧</h5>
                    <div></div>
                </div>
                <div class="table-scroll-container">
                    <table class="table table-bordered table-hover mb-0 align-middle">
                        <thead>
                            <tr>
                                <th>商品名</th>
                                <th style="width: 90px;">値引率</th>
                                <th style="width: 100px;">値引後価格</th>
                                <th style="width: 130px;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="dp" items="${discountList}">
                                <tr>
                                    <form action="<%= request.getContextPath() %>/super/discountAction" method="post" style="display: contents;">
                                        <input type="hidden" name="discountedProductId" value="${dp.discountedProductId}">
                                        <td>
                                            ${dp.productName}
                                            <div class="text-muted" style="font-size: 0.75rem;">(定価: ${dp.originalPrice}円)</div>
                                        </td>
                                        <td>
                                            <div class="input-group input-group-sm">
                                                <input type="number" name="rate" value="${dp.discountRate}" class="form-control text-end" min="1" max="99">
                                                <span class="input-group-text">%</span>
                                            </div>
                                        </td>
                                        <td class="text-end text-danger fw-bold">
                                            <c:out value="${Math.floor(dp.originalPrice * (100 - dp.discountRate) / 100)}" />円

                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group">
                                                <button type="submit" name="action" value="update" class="btn btn-sm btn-success">更新</button>
                                                <button type="submit" name="action" value="delete" class="btn btn-sm btn-danger"
                                                        onclick="return confirm('値引きを削除しますか？')">削除</button>
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