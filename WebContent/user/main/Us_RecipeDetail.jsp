<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- サーブレットから渡された cookMenu オブジェクトを変数 menu に代入 --%>
<c:set var="menu" value="${cookMenu}" />

<%-- タイトル設定（DBの料理名を使用） --%>
<c:set var="pageTitle" value="${menu.dishName}" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

    <style>
        /* ヘッダー色をピンクに設定 */
        .page-header { background-color: #ead1dc !important; }

        /* お気に入りボタンのスタイル */
        .fav-btn {
            border: 1px solid #333; background-color: #fff; padding: 5px 10px;
            font-size: 0.9rem; text-decoration: none; color: #333;
            display: inline-block; white-space: nowrap; transition: background-color 0.2s; cursor: pointer;
        }
        .fav-btn:hover { background-color: #f0f0f0; color: #333; }

        /* 区切り線（破線） */
        .dashed-line { border-top: 2px dashed #999; margin: 20px 0; }

        /* 商品説明の見出しスタイル */
        .desc-header {
            border-top: 1px solid #333; border-bottom: 1px solid #333;
            padding: 5px; text-align: center; font-weight: bold; margin-bottom: 15px;
        }

        /* クーポンボタンのスタイル */
        .coupon-btn {
            background-color: #ffff00; border: 2px solid #333; color: #333;
            font-weight: bold; padding: 15px; width: 100%; font-size: 1.1rem; transition: opacity 0.2s;
        }
        .coupon-btn:hover { opacity: 0.8; }
    </style>

    <div class="container py-0 px-0" style="max-width: 500px;">
        <%-- 料理画像エリア（プレースホルダー） --%>
        <div class="bg-light d-flex align-items-center justify-content-center border-bottom border-dark" style="height: 220px; width: 100%;">
            <div class="text-center text-muted">
                <i class="fas fa-utensils fa-4x mb-2"></i><br>
                料理画像
            </div>
        </div>

        <div class="container px-4 py-3">
            <%-- 料理名（DBから取得） --%>
            <h4 class="fw-bold mb-3">${menu.dishName}</h4>

            <div class="row align-items-end mb-3">
                <div class="col-6">
                    <div class="fw-bold"><i class="far fa-clock"></i> 調理時間</div>
                    <%-- ★ DBの COOK_TIME を表示 --%>
                    <div class="ps-3 fs-5">${menu.cookTime}分</div>
                </div>
                <div class="col-6 text-end">
                    <%-- ★ お気に入りボタンの切り替え判定（1:未登録, 2:登録済） --%>
                    <c:choose>
                        <c:when test="${menu.favoriteId == 2}">
                            <%-- 登録済みの場合（解除ボタン） --%>
                            <a href="${pageContext.request.contextPath}/user/User_FavoriteToggle?id=${menu.menuItemId}"
                               class="fav-btn shadow-sm" style="background-color: #fff9c4; border-color: #fbc02d;">
                                <i class="fas fa-star" style="color: #fbc02d;"></i> お気に入り解除
                            </a>
                        </c:when>
                        <c:otherwise>
                            <%-- 未登録の場合（登録ボタン） --%>
                            <a href="${pageContext.request.contextPath}/user/User_FavoriteToggle?id=${menu.menuItemId}"
                               class="fav-btn shadow-sm">
                                <i class="far fa-star"></i> お気に入り登録
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="dashed-line"></div>

            <%-- ★ 紹介文セクションは削除されました --%>

            <div class="desc-header mt-5">商品説明</div>

            <%-- 商品説明本文（DBの DESCRIPTION を表示） --%>
            <div class="text-center mb-4 text-muted">
                <p>${menu.description}</p>
            </div>

            <div class="dashed-line"></div>

            <div class="row justify-content-center mb-5">
                <div class="col-10">
                    <%-- ★ 修正：店舗経由（showCouponフラグがtrue）の場合のみ表示 --%>
                    <c:if test="${showCoupon}">
                        <a href="${pageContext.request.contextPath}/user/main/Us_Discount.jsp"
                           class="btn coupon-btn shadow-sm text-center text-decoration-none d-block">
                            クーポンを表示する
                        </a>
                    </c:if>
                </div>
            </div>
            <div style="height: 50px;"></div>
        </div>
    </div>

    <%-- 下部固定ナビゲーション --%>
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center">検索</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center">料理提案</a>
        <%-- ★ 修正：直接JSPではなくサーブレットを通す --%>
        <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center">店舗</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center">アカウント</a>
    </nav>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />