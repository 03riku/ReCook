<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="料理検索" scope="request" />

<c:set var="pageBody" scope="request">
    <style>
        .page-header { background-color: #c9daf8 !important; }
        .search-input-group { border: 2px solid #28a745; border-radius: 10px; overflow: hidden; background-color: #fff; }
        .search-input { border: none !important; height: 55px; font-size: 1.2rem; box-shadow: none !important; }
        .search-btn { background-color: transparent; border: none; padding: 0 15px; color: #28a745; font-size: 1.3rem; }
        .logo-container { padding: 40px 0; margin-bottom: 20px; }
    </style>

    <div class="container text-center py-4" style="max-width: 500px; padding-bottom: 100px !important;">
        <div class="logo-container">
            <img src="${pageContext.request.contextPath}/pic/recook_logo.png" alt="Re.Cook Logo" class="img-fluid" style="max-height: 120px; width: auto;">
        </div>

        <div class="row justify-content-center px-3">
            <div class="col-12">
                <form action="${pageContext.request.contextPath}/user/Search" method="get">
                    <div class="input-group search-input-group shadow-sm">
                        <button class="search-btn" type="submit"><i class="fas fa-search"></i></button>
                        <input type="text" name="keyword" class="form-control search-input" placeholder="料理名や食材を入力">
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- 下部固定ナビゲーション --%>
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
            <div class="fw-bold">検索</div>
            <div class="mt-1 mx-auto" style="background-color: #c9daf8; height: 5px; width: 80%;"></div>
        </a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>

        <%-- ★修正：店舗リンク (Servletを通す) --%>
        <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>

        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
    </nav>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />