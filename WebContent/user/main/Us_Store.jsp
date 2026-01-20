<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="${pageTitle}" scope="request" />

<c:set var="pageBody" scope="request">

    <style>
        body { background: rgb(238, 237, 234) !important; }
        .page-header { background-color: #fff2cc !important; }

        /* 検索バーと県選択を横に並べる */
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

        /* 店舗カード：中央揃えの縦並び */
        .store-box {
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            height: 150px; width: 100%;
            border: 1px solid #000; color: #333; text-decoration: none;
            padding: 10px; transition: opacity 0.2s;
            margin-bottom: -1px; margin-right: -1px;
        }
        .store-box:hover { opacity: 0.8; color: #333; }
        .bg-blue { background-color: #9fc5e8 !important; }
        .bg-white { background-color: #ffffff !important; }
    </style>

    <div class="container py-3" style="max-width: 500px;">
        <form action="${pageContext.request.contextPath}/user/StoreList" method="get">
            <div class="search-area">
                <!-- 県選択 -->
                <select name="pref" class="pref-select">
                    <option value="">全ての県</option>
                    <c:forEach var="p" items="${prefList}">
                        <option value="${p}" ${param.pref == p ? 'selected' : ''}>${p}</option>
                    </c:forEach>
                </select>
                <!-- キーワード検索 -->
                <div class="store-search-group shadow-sm">
                    <input type="text" name="keyword" class="store-search-input"
                           placeholder="店名で検索" value="${param.keyword}">
                    <button class="btn btn-white border-0 text-secondary" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
        </form>

        <div class="row g-0">
            <c:forEach var="s" items="${storeList}" varStatus="status">
                <div class="col-6">
                    <a href="${pageContext.request.contextPath}/user/StoreMenu?id=${s.storeId}"
                       class="store-box ${status.index % 4 == 0 || status.index % 4 == 3 ? 'bg-white' : 'bg-blue'}">
                        <!-- 住所を店名の上に小さく表示 -->
                        <div style="font-size: 0.75rem; color: #666; margin-bottom: 5px;">${s.storeAddress}</div>
                        <!-- 店舗名を太字で表示 -->
                        <div style="font-weight: bold;">${s.storeName}</div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />