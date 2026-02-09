<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- サーブレットから受け取った料理データを変数にセット --%>
<c:set var="menu" value="${cookMenu}" />
<c:set var="pageTitle" value="レシピ詳細" scope="request" />

<c:set var="pageBody" scope="request">
    <style>
        /* --- 全体のデザイン設定 --- */
        body { background: rgb(238, 237, 234) !important; }
        .page-header { background-color: #ead1dc !important; }

        /* 固定ヘッダー */
        .header-bar {
            display: flex; align-items: center; padding: 10px;
            background: #fff; border-bottom: 1px solid #ddd;
            position: sticky; top: 0; z-index: 1020;
        }
        .back-btn { font-size: 1.5rem; color: #333; text-decoration: none; margin-right: 15px; }

        /* 料理画像エリア */
        .recipe-img-box { height: 220px; background: #ddd; overflow: hidden; border-bottom: 1px solid #000; text-align: center; }
        .recipe-img-box img { width: 100%; height: 100%; object-fit: cover; }

        /* お気に入りボタン（JavaScriptで制御するために調整） */
        .fav-btn {
            display: inline-block; border: 1px solid #333; background: #fff;
            padding: 8px 15px; font-size: 0.9rem;
            color: #333; border-radius: 5px; cursor: pointer;
            transition: all 0.2s;
        }
        .fav-btn:active { background-color: #eee; }

        /* 装飾 */
        .dashed-line { border-top: 2px dashed #999; margin: 20px 0; }
        .ingredient-box { background: #fff; border: 1px solid #ccc; border-radius: 8px; padding: 15px; margin-bottom: 20px; }
        .coupon-btn { background: #ffff00; border: 2px solid #333; color: #333; font-weight: bold; padding: 15px; width: 100%; display: block; text-align: center; text-decoration: none; cursor: pointer; }
        #barcodeArea { display: none; background: #fff; border: 2px solid #333; padding: 20px; text-align: center; border-radius: 10px; }
    </style>

    <%-- 1. 画面上部：戻るボタン --%>
    <div class="header-bar">
        <%-- 一覧画面に戻るための戻るボタン --%>
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
                        <i class="fas fa-utensils fa-4x mb-2"></i>料理画像（準備中）
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
                    <%-- ★ 修正：onclickでJavaScriptを呼び出す。URLは変えない。 --%>
                    <button type="button" id="favBtn" class="fav-btn shadow-sm" onclick="toggleFavorite(${menu.menuItemId})">
                        <span id="favIcon">
                            <i class="${menu.favoriteId == 2 ? 'fas' : 'far'} fa-star"
                               style="${menu.favoriteId == 2 ? 'color: #f1c40f;' : ''}"></i>
                        </span>
                        <span id="favText">${menu.favoriteId == 2 ? '登録済み' : 'お気に入り'}</span>
                    </button>
                </div>
            </div>

            <div class="dashed-line"></div>

            <%-- 4. 材料一覧とクーポン価格（ここを書き換え） --%>
            <div class="row">
                <%-- 左側：材料一覧 --%>
                <%-- 店舗から(fromStore=true)で、かつ値段(couponPrice)がある場合は幅を狭くする --%>
                <div class="${(fromStore == 'true' && not empty couponPrice) ? 'col-7' : 'col-12'}">
                    <div class="fw-bold mb-2">材料一覧</div>
                    <div class="ingredient-box">
                        <ul class="mb-0 ps-3">
                            <c:forEach var="item" items="${ingredientsList}">
                                <li>${item.productName}</li>
                            </c:forEach>
                            <c:if test="${empty ingredientsList}">
                                <li>材料データが登録されていません</li>
                            </c:if>
                        </ul>
                    </div>
                </div>

                <%-- 右側：クーポン価格（店舗からアクセス && 値段がある時のみ表示） --%>
                <c:if test="${fromStore == 'true' && not empty couponPrice}">
                    <div class="col-5">
                        <div class="fw-bold mb-2 text-center text-danger">
                            <i class="fas fa-tag"></i> クーポン価格
                        </div>
                        <%-- 値段表示枠 --%>
                        <div class="shadow-sm d-flex flex-column justify-content-center align-items-center p-2"
                             style="height: auto; min-height: 100px; background-color: #fff0f0; border: 2px dashed #dc3545; border-radius: 10px;">

                            <span class="small text-muted fw-bold">セット購入で</span>

                            <span class="text-danger fw-bold lh-1 mt-1">
                                <span class="fs-4">¥</span>
                                <span class="fs-2">
                                    <fmt:formatNumber value="${couponPrice}" pattern="#,###" />
                                </span>
                            </span>

                            <span class="badge bg-danger mt-2">お得なクーポン</span>
                        </div>
                    </div>
                </c:if>
            </div>


            <%-- 5. 作り方・紹介文 --%>
            <div class="fw-bold text-center mt-4 mb-2">作り方・紹介</div>
            <p class="text-muted text-center">${menu.description}</p>

            <div class="dashed-line"></div>

            <%-- 6. クーポン表示 --%>
            <div class="mt-4 mb-5">
                <c:if test="${fromStore == 'true'}">
                    <div class="text-center text-danger small fw-bold mb-2">※材料を全て購入するとクーポンが有効になります</div>
                    <a id="couponBtn" class="coupon-btn shadow-sm mb-3" onclick="showBarcode()">クーポンを表示する</a>
                    <div id="barcodeArea" class="shadow-sm mb-3">
                        <p class="fw-bold mb-2">レジで提示してください</p>
                        <img src="${pageContext.request.contextPath}/pic/baakoodo.png" alt="バーコード" style="max-width: 100%; height: auto;">
                    </div>
                </c:if>
            </div>
            <div style="height: 50px;"></div>
        </div>
    </div>

    <%-- ★ 非同期通信（AJAX）用スクリプト --%>
    <script>
        async function toggleFavorite(menuItemId) {
            const btn = document.getElementById('favBtn');
            const iconWrap = document.getElementById('favIcon');
            const textWrap = document.getElementById('favText');

            // 二重クリック防止
            btn.disabled = true;

            try {
                const response = await fetch('${pageContext.request.contextPath}/user/User_FavoriteToggle', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'id=' + menuItemId + '&ajax=true'
                });

                if (response.ok) {
                    // 現在の状態を反転させて見た目を更新
                    if (textWrap.innerText === '登録済み') {
                        iconWrap.innerHTML = '<i class="far fa-star"></i>';
                        textWrap.innerText = 'お気に入り';
                    } else {
                        iconWrap.innerHTML = '<i class="fas fa-star" style="color: #f1c40f;"></i>';
                        textWrap.innerText = '登録済み';
                    }
                }
            } catch (error) {
                console.error('通信失敗:', error);
            } finally {
                btn.disabled = false;
            }
        }

        function showBarcode() {
            document.getElementById('barcodeArea').style.display = 'block';
            document.getElementById('couponBtn').style.display = 'none';
        }
    </script>

    <%-- 下部ナビゲーション --%>
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>
        <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
    </nav>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />