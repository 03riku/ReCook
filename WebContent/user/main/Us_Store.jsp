<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 1. ページタイトルの準備 --%>
<c:set var="displayTitle" value="${not empty pageTitle ? pageTitle : '店舗一覧'}" scope="request" />
<c:set var="pageTitle" value="${displayTitle}" scope="request" />

<%-- 2. ページの中身（pageBody）の開始 --%>
<c:set var="pageBody" scope="request">

    <style>
        /* --- 全体の見た目設定 --- */
        body { background: rgb(238, 237, 234) !important; }
        .page-header { background-color: #fff2cc !important; }

        .header-bar {
            display: flex; align-items: center; padding: 10px;
            background: #fff; border-bottom: 1px solid #ddd;
            position: sticky; top: 0; z-index: 1020;
        }
        .back-btn { font-size: 1.5rem; color: #333; text-decoration: none; margin-right: 15px; }

        .search-area { display: flex; gap: 10px; margin: 15px; }
        .pref-select {
            border: 2px solid #333; border-radius: 10px;
            padding: 0 10px; height: 45px; background: #fff; min-width: 110px;
        }
        .store-search-group {
            border: 2px solid #333; border-radius: 10px;
            flex-grow: 1; display: flex; background: #fff; overflow: hidden;
        }
        .store-search-input { border: none !important; flex-grow: 1; padding-left: 10px; outline: none; }

        .store-box {
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            height: 150px; width: 100%;
            border: 1px solid #000; color: #333 !important; text-decoration: none !important;
            padding: 10px; transition: opacity 0.2s;
            margin-bottom: -1px; margin-right: -1px;
        }
        .store-box:hover { opacity: 0.8; }
        .bg-blue { background-color: #9fc5e8 !important; }
        .bg-white { background-color: #ffffff !important; }

        .bottom-nav a{ position: relative; padding-bottom: 10px; }
        .bottom-nav a::after{
            content: ""; position: absolute; left: 50%; bottom: 2px;
            width: 70%; height: 5px; background-color: var(--bar-color, #c9daf8);
            transform: translateX(-50%) scaleX(0); transform-origin: center;
            border-radius: 2px; transition: transform 0.15s ease;
        }
        .bottom-nav a:hover::after,
        .bottom-nav a.active::after{ transform: translateX(-50%) scaleX(1) !important; }

        .bottom-nav a.bar-home    { --bar-color:#ffe5d9; }
        .bottom-nav a.bar-search  { --bar-color:#c9daf8; }
        .bottom-nav a.bar-recipe  { --bar-color:#d9ead3; }
        .bottom-nav a.bar-store   { --bar-color:#fff2cc; }
        .bottom-nav a.bar-account { --bar-color:#ead1dc; }

        .page-safe-bottom{ padding-bottom: 90px; }
    </style>

    <%-- 3. 上部ヘッダー --%>
    <div class="header-bar">
        <a href="javascript:history.back();" class="back-btn"><i class="fas fa-chevron-left"></i></a>
        <h5 class="mb-0 fw-bold">${pageTitle}</h5>
    </div>

    <div class="container py-3 page-safe-bottom" style="max-width: 500px;">

        <%-- 4. 検索エリア --%>
        <c:if test="${empty param.menuId}">
            <form action="${pageContext.request.contextPath}/user/StoreList" method="get">
                <div class="search-area">
                    <select name="pref" class="pref-select">
                        <option value="">全ての県</option>
                        <c:forEach var="p" items="${prefList}">
                            <option value="${p}" ${param.pref == p ? 'selected' : ''}>${p}</option>
                        </c:forEach>
                    </select>
                    <div class="store-search-group shadow-sm">
                        <input type="text" name="keyword" class="store-search-input"
                               placeholder="店名で検索" value="${param.keyword}">
                        <button class="btn btn-white border-0 text-secondary" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </form>
        </c:if>

        <%-- 5. 店舗リストの表示 --%>
        <div class="row g-0">
            <c:forEach var="s" items="${storeList}" varStatus="status">
                <div class="col-6">
                    <a href="${pageContext.request.contextPath}/user/StoreMenu?id=${s.storeId}"
                       class="store-box ${status.index % 4 == 0 || status.index % 4 == 3 ? 'bg-white' : 'bg-blue'}">
                        <div style="font-size: 0.75rem; color: #666; margin-bottom: 5px;">${s.storeAddress}</div>
                        <div style="font-weight: bold;">${s.storeName}</div>
                    </a>
                </div>
            </c:forEach>
        </div>

        <%-- 6. 見つからなかった時の表示 --%>
        <c:if test="${empty storeList}">
            <div class="text-center py-5">
                <i class="fas fa-store-slash fa-3x mb-3 text-muted"></i>
                <p class="text-muted">該当するお店が見つかりませんでした。</p>
                <%-- ↓ ここを「ホーム画面に戻る」に変更しました --%>
                <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="btn btn-outline-secondary btn-sm">ホーム画面に戻る</a>
            </div>
        </c:if>
    </div>

    <!-- 下部固定ナビゲーション -->
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center bar-home" style="min-width: 60px;">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center bar-search" style="min-width: 60px;">検索</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center bar-recipe" style="min-width: 60px;">料理提案</a>
        <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center bar-store" style="min-width: 60px;">店舗</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center bar-account" style="min-width: 60px;">アカウント</a>
    </nav>
</c:set>

<%-- 8. 土台となる base.jsp を読み込む --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />