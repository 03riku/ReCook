<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>商品ページ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
    background-color: #F5F5F0;
}

/* 左メニュー */
.sidebar {
    width: 240px;
    background: #ffffff;
    padding: 30px 20px;
    border-radius: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    height: calc(100vh - 40px);
    position: fixed;
    left: 20px;
    top: 20px;
}

.main-card {
    background: #ffffff;
    padding: 30px;
    border-radius: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    min-height: calc(100vh - 40px);
    position: fixed;
    left: 270px;
    right: 20px;
    top: 20px;
}

.logo {
    font-size: 32px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 40px;
}

.menu-btn {
    width: 100%;
    margin-bottom: 15px;
}
</style>
</head>

<body>

<!-- 左サイドメニュー -->
<div class="sidebar">
    <div class="logo">
        <img src="<%= request.getContextPath() %>/pic/recook_logo.png"
             alt="Re.Cook Logo" style="width: 200px;">
    </div>

    <button class="btn btn-outline-dark menu-btn">商品</button>
    <button class="btn btn-outline-dark menu-btn">値引き商品</button>
    <button class="btn btn-outline-dark menu-btn">クーポン</button>
    <button class="btn btn-outline-dark menu-btn">ログアウト</button>
</div>

<!-- メイン画面 -->
<div class="container">
    <div class="main-card">

        <!-- タイトル＋区切り線 -->
        <h4 class="text-center mb-2">商品ページ</h4>
        <hr class="mb-4">

        <div class="row">

            <!-- 左：商品一覧（チェックして追加） -->
            <div class="col-md-6">
                <form action="<%= request.getContextPath() %>/super/addStoreProduct" method="post">

                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h5 class="mb-0">商品一覧</h5>
                        <button type="submit" class="btn btn-sm btn-primary">追加</button>
                    </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>選択</th>
                                <th>商品名</th>
                                <th>カテゴリ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${productList}">
                                <tr>
                                    <td>
                                        <input type="checkbox" name="productIds" value="${p.productId}">
                                    </td>
                                    <td>${p.productName}</td>
                                    <td>${p.category}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </form>
            </div>

            <!-- 右：自店舗商品一覧 -->
            <div class="col-md-6">
                <h5>自店舗商品一覧</h5>

                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>商品名</th>
                            <th>カテゴリ</th>
                            <th>価格</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sp" items="${storeProductList}">
                            <tr>
                                <td>${sp.productName}</td>
                                <td>${sp.category}</td>
                                <td>${sp.price}円</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

            </div> <!-- col-md-6 -->
        </div> <!-- row -->

    </div> <!-- main-card -->
</div> <!-- container -->

</body>
</html>
