<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- サーブレットから受け取った料理データを変数にセット --%>
<c:set var="menu" value="${cookMenu}" />
<c:set var="pageTitle" value="レシピ詳細" scope="request" />

<c:set var="pageBody" scope="request">
    <style>
        /* --- 全体のデザイン設定 --- */
        body { background: rgb(238, 237, 234) !important; }
        .page-header { background-color: #ead1dc !important; }

        /* 固定ヘッダー（戻るボタン） */
        .header-bar {
            display: flex; align-items: center; padding: 10px;
            background: #fff; border-bottom: 1px solid #ddd;
            position: sticky; top: 0; z-index: 1020;
        }
        .back-btn { font-size: 1.5rem; color: #333; text-decoration: none; margin-right: 15px; }

        /* 料理画像エリア */
        .recipe-img-box { height: 220px; background: #ddd; overflow: hidden; border-bottom: 1px solid #000; text-align: center; }
        .recipe-img-box img { width: 100%; height: 100%; object-fit: cover; }

        /* お気に入りボタン */
        .fav-btn {
            display: inline-block; border: 1px solid #333; background: #fff;
            padding: 8px 15px; font-size: 0.9rem; text-decoration: none !important;
            color: #333 !important; border-radius: 5px; cursor: pointer;
        }

        /* 装飾：点線と枠 */
        .dashed-line { border-top: 2px dashed #999; margin: 20px 0; }
        .ingredient-box { background: #fff; border: 1px solid #ccc; border-radius: 8px; padding: 15px; margin-bottom: 20px; }

        /* クーポンボタン（黄色） */
        .coupon-btn { background: #ffff00; border: 2px solid #333; color: #333; font-weight: bold; padding: 15px; width: 100%; display: block; text-align: center; text-decoration: none; cursor: pointer; }

        /* 店舗検索ボタン（白） */
        .store-search-btn { background: #fff; border: 2px solid #333; color: #333; font-weight: bold; padding: 12px; width: 100%; display: block; text-align: center; text-decoration: none; }

        /* バーコード表示エリア（最初は隠しておく） */
        #barcodeArea {
            display: none; background: #fff; border: 2px solid #333;
            padding: 20px; text-align: center; border-radius: 10px;
        }
    </style>

    <%-- 1. 画面上部：戻るボタンと料理名 --%>
    <div class="header-bar">
        <a href="javascript:history.back();" class="back-btn"><i class="fas fa-chevron-left"></i></a>
        <h5 class="mb-0 fw-bold">${menu.dishName}</h5>
    </div>

    <div class="container py-0 px-0" style="max-width: 500px;">

        <%-- 2. 料理画像 --%>
        <div class="recipe-img-box">
            <c:choose>
                <c:when test="${not empty menu.image}">
                    <img src="${pageContext.request.contextPath}/pic/${menu.image}" alt="${menu.dishName}">
                </c:when>
                <c:otherwise>
                    <div class="h-100 d-flex flex-column align-items-center justify-content-center text-muted">
                        <i class="fas fa-utensils fa-4x mb-2"></i><br>料理画像（準備中）
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="container px-4 py-3">

            <%-- 3. 調理時間とお気に入りボタン --%>
            <div class="row align-items-end mb-3">
                <div class="col-6">
                    <div class="fw-bold"><i class="far fa-clock"></i> 調理時間</div>
                    <div class="ps-3 fs-5">${menu.cookTime}分</div>
                </div>
                <div class="col-6 text-end">
                    <a href="${pageContext.request.contextPath}/user/User_FavoriteToggle?id=${menu.menuItemId}" class="fav-btn shadow-sm">
                        <i class="${menu.favoriteId == 2 ? 'fas' : 'far'} fa-star" style="${menu.favoriteId == 2 ? 'color: #f1c40f;' : ''}"></i>
                        ${menu.favoriteId == 2 ? '登録済み' : 'お気に入り'}
                    </a>
                </div>
            </div>

            <div class="dashed-line"></div>

            <%-- 4. 材料一覧 --%>
            <div class="fw-bold mb-2">材料一覧</div>
            <div class="ingredient-box">
                <ul class="mb-0">
                    <c:forEach var="item" items="${ingredientsList}">
                        <li>${item.productName}</li>
                    </c:forEach>
                    <c:if test="${empty ingredientsList}">
                        <li>材料データが登録されていません</li>
                    </c:if>
                </ul>
            </div>

            <%-- 5. 作り方・紹介文 --%>
            <div class="fw-bold text-center mt-4 mb-2">作り方・紹介</div>
            <p class="text-muted text-center">${menu.description}</p>

            <div class="dashed-line"></div>

            <%-- 6. クーポンと店舗検索 --%>
            <div class="mt-4">
                <%-- ★クーポンボタン：店舗画面から来た場合（fromStore == 'true'）のみ表示 --%>
                <c:if test="${fromStore == 'true'}">
                    <div class="text-center text-danger small fw-bold mb-2">
                        ※材料を全て購入するとクーポンが有効になります
                    </div>
                    <a id="couponBtn" class="coupon-btn shadow-sm mb-3" onclick="showBarcode()">
                        クーポンを表示する
                    </a>

                    <%-- バーコード表示エリア（ボタンを押すとJSで表示される） --%>
                    <div id="barcodeArea" class="shadow-sm mb-3">
                        <p class="fw-bold mb-2">レジで提示してください</p>
                        <%-- ★ 画像ファイル名を baakoodo.png に修正しました --%>
                        <img src="${pageContext.request.contextPath}/pic/baakoodo.png" alt="バーコード" style="max-width: 100%; height: auto;">
                    </div>
                </c:if>

                <%-- 取扱店舗検索ボタン --%>
                <a href="${pageContext.request.contextPath}/user/StoreList?menuId=${menu.menuItemId}" class="store-search-btn shadow-sm mb-5">
                    <i class="fas fa-map-marker-alt"></i> このクーポンが使えるお店を探す
                </a>
            </div>

            <div style="height: 80px;"></div>
        </div>
    </div>

    <%-- クーポン表示用スクリプト --%>
    <script>
        function showBarcode() {
            // バーコードエリアを表示し、ボタンを隠す
            document.getElementById('barcodeArea').style.display = 'block';
            document.getElementById('couponBtn').style.display = 'none';
        }
    </script>

    <%-- 下部固定ナビゲーション --%>
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>
        <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
    </nav>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />