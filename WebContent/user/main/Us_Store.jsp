<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="店舗一覧" scope="request" />

<c:set var="pageBody" scope="request">

    <style>
        .page-header { background-color: #ffff00 !important; }
        .store-box {
            display: flex; align-items: flex-end; justify-content: center;
            height: 150px; width: 100%; border: 0.5px solid #000;
            color: #333; font-size: 1.2rem; text-decoration: none;
            padding-bottom: 20px; transition: opacity 0.2s;
        }
        .store-box:hover { opacity: 0.8; color: #333; }
        .bg-blue { background-color: #9fc5e8; }
        .bg-white { background-color: #ffffff; }
    </style>

    <div class="container py-3" style="max-width: 500px;">
        <div class="text-center mb-3">
            <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-decoration-none text-secondary">
                <i class="fas fa-search me-1"></i> 店舗内検索
            </a>
        </div>

        <div class="row g-0 border border-dark">
            <%-- サーブレット(StoreList)から渡された storeList をループ --%>
            <c:forEach var="s" items="${storeList}" varStatus="status">
                <div class="col-6">
                    <%-- ★修正：リンク先を /user/StoreMenu に変更し、id=${s.storeId} を付与 --%>
                    <a href="${pageContext.request.contextPath}/user/StoreMenu?id=${s.storeId}"
                       class="store-box ${status.index == 0 ? 'bg-blue' : 'bg-white'}">
                        ${s.storeName}
                    </a>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty storeList}">
            <p class="text-center mt-5">店舗情報が見つかりませんでした。</p>
        </c:if>
    </div>

    <%-- 下部固定ナビゲーション --%>
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center">検索</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center">料理提案</a>

        <%-- 現在地 --%>
        <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center">
            <div>店舗</div>
            <div class="mt-1 mx-auto" style="background-color: #ffff00; height: 5px; width: 80%;"></div>
        </a>

        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center">アカウント</a>
    </nav>

</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />