<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="検索" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

    <%-- この画面専用のスタイル --%>
    <style>
        .page-header { background-color: #c9daf8 !important; }
    </style>

    <div class="container text-center py-5" style="max-width: 500px;">

        <%-- ロゴ画像エリア --%>
        <div class="py-5 mb-5 border rounded" style="background-color: #f7f7f7;">
            <img src="${pageContext.request.contextPath}/pic/recook_logo.png"
                 alt="Re.Cook Logo"
                 class="img-fluid"
                 style="max-height: 100px; max-width: 90%;">
        </div>

        <%-- 検索フォームエリア --%>
        <div class="row justify-content-center mt-4">
            <div class="col-10">
                <%-- サーブレット(SearchServlet)へキーワードを送信 --%>
                <form action="${pageContext.request.contextPath}/user/Search" method="get">
                    <div class="input-group mb-3">
                        <span class="input-group-text bg-white border-end-0" style="border: 2px solid #28a745; border-right: none;">
                            <i class="fas fa-search text-primary"></i>
                        </span>
                        <input type="text" name="keyword" class="form-control border-start-0"
                               placeholder="検索" aria-label="検索"
                               style="border: 2px solid #28a745; border-left: none; height: 50px; font-size: 1.2rem;">
                    </div>
                </form>
            </div>
        </div>

    </div>

    <%-- 下部固定ナビゲーション --%>
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
            <div>検索</div>
            <div class="mt-1 mx-auto" style="background-color: #c9daf8; height: 5px; width: 80%;"></div>
        </a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
    </nav>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />