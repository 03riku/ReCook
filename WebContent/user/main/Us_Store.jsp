<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="${pageTitle}" scope="request" />

<c:set var="pageBody" scope="request">

    <style>
        body { background: rgb(238, 237, 234) !important; }
        .page-header { background-color: #fff2cc !important; }

        /* 検索エリアのレイアウト */
        .search-container {
            display: flex;
            gap: 10px;
            padding: 0 15px;
            margin-bottom: 20px;
        }

        /* プルダウンのスタイル */
        .pref-select {
            border: 2px solid #333;
            border-radius: 10px;
            padding: 0 10px;
            height: 45px;
            background-color: #fff;
            min-width: 100px;
        }

        .store-search-group {
            border: 2px solid #333;
            border-radius: 10px;
            overflow: hidden;
            background-color: #fff;
            flex-grow: 1; /* 残りの幅を埋める */
        }
        .store-search-input {
            border: none !important;
            box-shadow: none !important;
            height: 41px; /* 枠線分調整 */
        }

        .store-box {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 150px; width: 100%;
            border: 1px solid #000;
            color: #333; text-decoration: none;
            padding: 10px;
            transition: opacity 0.2s;
            margin-bottom: -1px;
            margin-right: -1px;
        }
        .store-box:hover { opacity: 0.8; color: #333; }
        .bg-blue { background-color: #9fc5e8 !important; }
        .bg-white { background-color: #ffffff !important; }

        .bottom-nav a{ position: relative; padding-bottom: 10px; }
        .bottom-nav a::after{
            content: ""; position: absolute; left: 50%; bottom: 2px; width: 70%; height: 5px;
            background-color: var(--bar-color, #c9daf8); transform: translateX(-50%) scaleX(0);
            transform-origin: center; border-radius: 2px; transition: transform 0.15s ease;
        }
        .bottom-nav a:hover::after, .bottom-nav a.active::after{ transform: translateX(-50%) scaleX(1); }
        .bottom-nav a.bar-home { --bar-color:#ffe5d9; }
        .bottom-nav a.bar-search { --bar-color:#c9daf8; }
        .bottom-nav a.bar-recipe { --bar-color:#d9ead3; }
        .bottom-nav a.bar-store { --bar-color:#fff2cc; }
        .bottom-nav a.bar-account { --bar-color:#ead1dc; }
    </style>

    <div class="container py-3" style="max-width: 500px;">

        <!-- 店舗検索・絞り込みフォーム -->
        <form action="${pageContext.request.contextPath}/user/StoreList" method="get">
            <div class="search-container">
                <!-- 県選択プルダウン -->
                <select name="pref" class="pref-select">
                    <option value="">全ての県</option>
                    <c:forEach var="p" items="${prefList}">
                        <option value="${p}" ${param.pref == p ? 'selected' : ''}>${p}</option>
                    </c:forEach>
                </select>

                <!-- キーワード検索バー -->
                <div class="input-group store-search-group shadow-sm">
                    <input type="text" name="keyword" class="form-control store-search-input"
                           placeholder="店舗名で検索" value="${param.keyword}">
                    <button class="btn btn-white border-0 text-secondary" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
        </form>

        <!-- 店舗一覧表示 -->
        <div class="row g-0">
            <c:forEach var="s" items="${storeList}" varStatus="status">
                <div class="col-6">
                    <a href="${pageContext.request.contextPath}/user/StoreMenu?id=${s.storeId}"
                       class="store-box ${status.index % 4 == 0 || status.index % 4 == 3 ? 'bg-white' : 'bg-blue'}">
                        <div style="font-size: 0.75rem; color: #666; margin-bottom: 5px; text-align: center;">
                            ${s.storeAddress}
                        </div>
                        <div style="font-weight: bold; text-align: center;">
                            ${s.storeName}
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty storeList}">
            <div class="text-center mt-5 text-muted">
                <p>該当する店舗が見つかりませんでした。</p>
                <a href="${pageContext.request.contextPath}/user/StoreList" class="btn btn-sm btn-outline-secondary">一覧に戻る</a>
            </div>
        </c:if>

        <div style="height: 80px;"></div>
    </div>

    <!-- 下部ナビ（変更なし） -->
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center bar-home" style="min-width: 60px;">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center bar-search" style="min-width: 60px;">検索</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center bar-recipe" style="min-width: 60px;">料理提案</a>
        <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center bar-store active" style="min-width: 60px;">店舗</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center bar-account" style="min-width: 60px;">アカウント</a>
    </nav>

</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />