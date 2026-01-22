<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 文字エンコーディングを強制 --%>
<% request.setCharacterEncoding("UTF-8"); %>

<c:set var="menu" value="${cookMenu}" />
<c:set var="pageTitle" value="レシピ詳細" scope="request" />

<c:set var="pageBody" scope="request">
    <style>
        body { background: rgb(238, 237, 234) !important; }
        .page-header { background-color: #ead1dc !important; }

        .header-bar {
            display: flex; align-items: center; padding: 10px;
            background: #fff; border-bottom: 1px solid #ddd;
            position: sticky; top: 0; z-index: 1020;
        }
        .back-btn { font-size: 1.5rem; color: #333; text-decoration: none; margin-right: 15px; }

        .recipe-img-box { height: 220px; background: #ddd; overflow: hidden; border-bottom: 1px solid #000; text-align: center; }
        .recipe-img-box img { width: 100%; height: 100%; object-fit: cover; }

        .fav-btn {
            display: inline-block; border: 1px solid #333; background: #fff;
            padding: 8px 15px; font-size: 0.9rem; text-decoration: none !important;
            color: #333 !important; border-radius: 5px; cursor: pointer;
        }

        .dashed-line { border-top: 2px dashed #999; margin: 20px 0; }
        .ingredient-box { background: #fff; border: 1px solid #ccc; border-radius: 8px; padding: 15px; margin-bottom: 20px; }

        .coupon-btn { background: #ffff00; border: 2px solid #333; color: #333; font-weight: bold; padding: 15px; width: 100%; display: block; text-align: center; text-decoration: none; cursor: pointer; }
        .store-search-btn { background: #fff; border: 2px solid #333; color: #333; font-weight: bold; padding: 12px; width: 100%; display: block; text-align: center; text-decoration: none; }

        #barcodeArea {
            display: none; background: #fff; border: 2px solid #333;
            padding: 20px; text-align: center; border-radius: 10px;
        }
    </style>

    <%-- ヘッダー --%>
    <div class="header-bar">
        <a href="javascript:history.back();" class="back-btn"><i class="fas fa-chevron-left"></i></a>
        <h5 class="mb-0 fw-bold">${menu.dishName}</h5>
    </div>

    <div class="container py-0 px-0" style="max-width: 500px;">
        <%-- 料理画像：DBに画像名があればそれを表示、なければIDで判定 --%>
        <div class="recipe-img-box">
            <c:choose>
                <c:when test="${not empty menu.image}">
                    <img src="${pageContext.request.contextPath}/pic/${menu.image}" alt="${menu.dishName}">
                </c:when>
                <c:when test="${menu.menuItemId == 1}"><img src="${pageContext.request.contextPath}/pic/omuraisu.png" alt="オムライス"></c:when>
                <c:when test="${menu.menuItemId == 2}"><img src="${pageContext.request.contextPath}/pic/hanbaagu.png" alt="ハンバーグ"></c:when>
                <c:when test="${menu.menuItemId == 3}"><img src="${pageContext.request.contextPath}/pic/sake teishoku.jpg" alt="鮭の塩焼き定食"></c:when>
                <c:when test="${menu.menuItemId == 4}"><img src="${pageContext.request.contextPath}/pic/moyashi itame.jpg" alt="もやし炒め"></c:when>
                <c:otherwise>
                    <div class="h-100 d-flex flex-column align-items-center justify-content-center text-muted">
                        <i class="fas fa-utensils fa-4x mb-2"></i><br>料理画像（準備中）
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="container px-4 py-3">
            <div class="row align-items-end mb-3">
                <div class="col-6">
                    <div class="fw-bold"><i class="far fa-clock"></i> 調理時間</div>
                    <div class="ps-3 fs-5">${menu.cookTime}分</div>
                </div>
                <div class="col-6 text-end">
                    <a href="${pageContext.request.contextPath}/user/User_FavoriteToggle?id=${menu.menuItemId}" class="fav-btn shadow-sm">
                        <%-- favoriteIdが2なら星を塗りつぶす --%>
                        <i class="${menu.favoriteId == 2 ? 'fas' : 'far'} fa-star" style="${menu.favoriteId == 2 ? 'color: #f1c40f;' : ''}"></i>
                        ${menu.favoriteId == 2 ? '登録済み' : 'お気に入り'}
                    </a>
                </div>
            </div>

            <div class="dashed-line"></div>

            <div class="fw-bold mb-2">材料一覧</div>
            <div class="ingredient-box">
                <ul class="mb-0">
                    <%-- ★修正：igはProductオブジェクトなので .productName を指定 --%>
                    <c:forEach var="ig" items="${ingredientsList}">
                        <li>${ig.productName}</li>
                    </c:forEach>
                    <c:if test="${empty ingredientsList}"><li>材料データが未登録です</li></c:if>
                </ul>
            </div>

            <div class="fw-bold text-center mt-4 mb-2">作り方・紹介</div>
            <p class="text-muted text-center">${menu.description}</p>

            <div class="mt-5">
                <%-- 店舗から来た（fromStore=true）時だけ表示 --%>
                <c:if test="${param.fromStore == 'true'}">
                    <a id="couponBtn" class="coupon-btn shadow-sm mb-3" onclick="showBarcode()">
                        クーポンを表示する
                    </a>

                    <div id="barcodeArea" class="shadow-sm mb-3">
                        <p class="fw-bold mb-2">会計時にご提示ください</p>
                        <img src="${pageContext.request.contextPath}/pic/baakoodo.png" alt="バーコード" style="max-width: 100%; height: auto;">
                    </div>
                </c:if>

                <%-- お店を探すボタン（常に表示） --%>
                <a href="${pageContext.request.contextPath}/user/StoreByMenu?menuId=${menu.menuItemId}&dishName=${menu.dishName}" class="store-search-btn shadow-sm">
                    <i class="fas fa-map-marker-alt"></i> このクーポンが使えるお店を探す
                </a>
            </div>
            <div style="height: 50px;"></div>
        </div>
    </div>

    <script>
        function showBarcode() {
            document.getElementById('barcodeArea').style.display = 'block';
            document.getElementById('couponBtn').style.display = 'none';
        }
    </script>
</c:set>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />