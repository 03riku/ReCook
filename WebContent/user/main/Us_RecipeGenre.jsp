<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="料理提案" scope="request" />

<c:set var="pageBody" scope="request">
<style>
    /* --- 全体のレイアウト設定 --- */
    html, body {
      background: rgb(238, 237, 234) !important;
      height: 100vh;
      overflow: hidden;
      margin: 0; padding: 0;
    }
    .page-header { background-color: #d9ead3 !important; }

    /* ロゴが入っているトップの箱をスリム化 */
    .genre-top-box {
        padding: 15px 0 !important;   /* py-5 から大幅削減 */
        margin-bottom: 15px !important;/* mb-5 から大幅削減 */
        background-color: #f7f7f7;
        border-radius: 12px;
    }
    .genre-top-box img {
        max-height: 80px;             /* ロゴを小さく */
        width: auto;
    }

    /* ジャンルボタンのサイズ調整 */
    .genre-btn-box {
        height: 100px;                /* ボタンの高さを固定 */
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 12px;
        box-shadow: 0 4px 10px rgba(0,0,0,.08);
        border: 1px solid #333;
    }
    .genre-btn-box h3 {
        font-size: 1.5rem;
        margin: 0;
    }

    /* 下部ナビゲーションのアニメーション */
    .bottom-nav a { position: relative; padding-bottom: 10px; }
    .bottom-nav a::after {
        content: ""; position: absolute; left: 50%; bottom: 2px;
        width: 70%; height: 5px; background-color: var(--bar-color, #c9daf8);
        transform: translateX(-50%) scaleX(0); transform-origin: center;
        border-radius: 2px; transition: transform 0.15s ease;
    }
    .bottom-nav a:hover::after, .bottom-nav a.active::after {
        transform: translateX(-50%) scaleX(1) !important;
    }
    .bottom-nav a.bar-home    { --bar-color:#ffe5d9; }
    .bottom-nav a.bar-search  { --bar-color:#c9daf8; }
    .bottom-nav a.bar-recipe  { --bar-color:#d9ead3; }
    .bottom-nav a.bar-store   { --bar-color:#fff2cc; }
    .bottom-nav a.bar-account { --bar-color:#ead1dc; }
</style>

<div class="container text-center pt-3" style="max-width: 500px;">
    <%-- ロゴエリア --%>
    <div class="genre-top-box border">
        <img src="${pageContext.request.contextPath}/pic/recook_logo.png" alt="Re.Cook Logo" class="img-fluid">
    </div>

    <div class="row g-3">
        <%-- 和食 --%>
        <div class="col-6">
            <a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=1&genreName=和食" class="text-decoration-none">
                <div class="genre-btn-box" style="background-color: #cccccc;">
                    <h3 class="text-dark">和食</h3>
                </div>
            </a>
        </div>
        <%-- 洋食 --%>
        <div class="col-6">
            <a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=2&genreName=洋食" class="text-decoration-none">
                <div class="genre-btn-box" style="background-color: #9fc5e8;">
                    <h3 class="text-dark">洋食</h3>
                </div>
            </a>
        </div>
        <%-- 漢メシ --%>
        <div class="col-6">
            <a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=3&genreName=漢メシ" class="text-decoration-none">
                <div class="genre-btn-box" style="background-color: #ea9999;">
                    <h3 class="text-dark">漢メシ</h3>
                </div>
            </a>
        </div>
        <%-- 節約飯 --%>
        <div class="col-6">
            <a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=4&genreName=節約飯" class="text-decoration-none">
                <div class="genre-btn-box" style="background-color: #b6d7a8;">
                    <h3 class="text-dark">節約飯</h3>
                </div>
            </a>
        </div>
    </div>
</div>

<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
  <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center bar-home" style="min-width: 60px;">ホーム</a>
  <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center bar-search" style="min-width: 60px;">検索</a>
  <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center bar-recipe active" style="min-width: 60px;">料理提案</a>
  <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center bar-store" style="min-width: 60px;">店舗</a>
  <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center bar-account" style="min-width: 60px;">アカウント</a>
</nav>

</c:set>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />