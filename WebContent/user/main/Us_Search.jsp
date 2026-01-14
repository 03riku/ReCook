<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="料理検索" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

    <%-- この画面専用のスタイル --%>
    <style>
        /* ヘッダーの色（検索画面用の淡いブルー） */
        .page-header {
            background-color: #c9daf8 !important;
        }

        /* 検索バーのカスタムスタイル */
        .search-input-group {
            border: 2px solid #28a745; /* Re.Cookのテーマカラー（緑） */
            border-radius: 10px;
            overflow: hidden;
            background-color: #fff;
        }

        .search-input {
            border: none !important;
            height: 55px;
            font-size: 1.2rem;
            box-shadow: none !important;
        }

        .search-btn {
            background-color: transparent;
            border: none;
            padding: 0 15px;
            color: #28a745;
            font-size: 1.3rem;
        }

        /* ロゴのコンテナ */
        .logo-container {
            padding: 40px 0;
            margin-bottom: 20px;
        }
    </style>

    <div class="container text-center py-4" style="max-width: 500px; padding-bottom: 100px !important;">

        <%-- ロゴ画像表示エリア --%>
        <div class="logo-container">
            <img src="${pageContext.request.contextPath}/pic/recook_logo.png"
                 alt="Re.Cook Logo"
                 class="img-fluid"
                 style="max-height: 120px; width: auto;">
            <p class="text-muted mt-3">今日の献立をDBから見つけよう</p>
        </div>

        <%-- 検索フォームエリア --%>
        <div class="row justify-content-center px-3">
            <div class="col-12">
                <%-- サーブレット(SearchServlet)へGETメソッドで送信 --%>
                <form action="${pageContext.request.contextPath}/user/Search" method="get">
                    <div class="input-group search-input-group shadow-sm">
                        <%-- 虫眼鏡アイコンをボタンとして配置 --%>
                        <button class="search-btn" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                        <%-- 入力フィールド (name="keyword" が重要) --%>
                        <input type="text" name="keyword" class="form-control search-input"
                               placeholder="料理名や食材を入力" aria-label="検索">
                    </div>
                </form>
            </div>
        </div>

        <%-- おすすめキーワード（おまけ） --%>
        <div class="mt-4 px-3 text-start">
            <small class="text-muted d-block mb-2">人気のキーワード：</small>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/user/Search?keyword=オムライス" class="badge rounded-pill bg-light text-dark border text-decoration-none py-2 px-3">オムライス</a>
                <a href="${pageContext.request.contextPath}/user/Search?keyword=ハンバーグ" class="badge rounded-pill bg-light text-dark border text-decoration-none py-2 px-3">ハンバーグ</a>
                <a href="${pageContext.request.contextPath}/user/Search?keyword=シチュー" class="badge rounded-pill bg-light text-dark border text-decoration-none py-2 px-3">シチュー</a>
            </div>
        </div>

    </div>

    <%-- 下部固定ナビゲーション --%>
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
            <div class="small">ホーム</div>
        </a>

        <%-- ★現在地：検索（ブルーのハイライト） --%>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
            <div class="small fw-bold">検索</div>
            <div class="mt-1 mx-auto" style="background-color: #c9daf8; height: 5px; width: 80%;"></div>
        </a>

        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
            <div class="small">料理提案</div>
        </a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
            <div class="small">店舗</div>
        </a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
            <div class="small">アカウント</div>
        </a>
    </nav>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />