<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="料理提案" scope="request" />

<c:set var="pageBody" scope="request">
<style>
  .page-header { background-color: #d9ead3 !important; }

  html, body{
    background: rgb(238, 237, 234) !important;
    min-height: 100%;
  }

  /* =========================
     ロゴ枠（白い枠）を小さく / ロゴを大きく（ホームと同じ）
     ========================= */
  .logo-wrap{
    max-width: 520px;
    margin: 0 auto 28px;
    background: #ffffff;
    border: 1px solid rgba(0,0,0,.08);
    border-radius: 12px;
    padding: 18px 14px;
    box-shadow: 0 6px 16px rgba(0,0,0,.06);
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .logo-wrap img{
    max-height: 180px;
    width: auto;
    max-width: 100%;
    object-fit: contain;
  }

  /* =========================
     メニューボタン（ホームと統一）
     ========================= */
  .menu-wrap{ max-width: 520px; margin: 0 auto; }
  .menu-btn{
    border-radius: 14px;
    min-height: 110px;
    box-shadow: 0 10px 22px rgba(0,0,0,.08);
    transition: transform .12s ease, box-shadow .12s ease;
    border: 1px solid rgba(0,0,0,.28);
  }
  .menu-btn:hover{
    transform: translateY(-2px);
    box-shadow: 0 14px 26px rgba(0,0,0,.12);
  }
  .menu-btn h3{
    font-size: 1.7rem;
    letter-spacing: .04em;
  }

  /* =========================
     下部固定ナビ：ホバーで下に色バー（色分け対応）
     ========================= */
  .bottom-nav a{
    position: relative;
    padding-bottom: 10px;
  }
  .bottom-nav a::after{
    content: "";
    position: absolute;
    left: 50%;
    bottom: 2px;
    width: 70%;
    height: 5px;
    background-color: var(--bar-color, #c9daf8);
    transform: translateX(-50%) scaleX(0);
    transform-origin: center;
    border-radius: 2px;
    transition: transform 0.15s ease;
  }
  .bottom-nav a:hover::after{
    transform: translateX(-50%) scaleX(1);
  }
  .bottom-nav a.active::after{
    transform: translateX(-50%) scaleX(1) !important;
  }

  .bottom-nav a.bar-home    { --bar-color:#ffe5d9; }
  .bottom-nav a.bar-search  { --bar-color:#c9daf8; }
  .bottom-nav a.bar-recipe  { --bar-color:#d9ead3; }
  .bottom-nav a.bar-store   { --bar-color:#fff2cc; }
  .bottom-nav a.bar-account { --bar-color:#ead1dc; }

  /* 下部ナビと被らないように余白確保 */
  .page-safe-bottom{ padding-bottom: 90px; }
</style>

<div class="container text-center pt-4 page-safe-bottom">

  <%-- ロゴ（ホームと同じ） --%>
  <div class="logo-wrap">
    <img src="${pageContext.request.contextPath}/pic/recook_logo.png" alt="Re.Cook Logo">
  </div>

  <%-- ジャンルボタン（ホームと同じ統一デザイン） --%>
  <div class="menu-wrap">
    <div class="row g-3">

      <%-- 和食 (GENRE_ID: 1) --%>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=1&genreName=和食"
           class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center"
               style="background-color:#cccccc;">
            <h3 class="mb-0 text-dark">和食</h3>
          </div>
        </a>
      </div>

      <%-- 洋食 (GENRE_ID: 2) --%>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=2&genreName=洋食"
           class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center"
               style="background-color:#9fc5e8;">
            <h3 class="mb-0 text-dark">洋食</h3>
          </div>
        </a>
      </div>

      <%-- 漢メシ (GENRE_ID: 3) --%>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=3&genreName=漢メシ"
           class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center"
               style="background-color:#ea9999;">
            <h3 class="mb-0 text-dark">漢メシ</h3>
          </div>
        </a>
      </div>

      <%-- 節約飯 (GENRE_ID: 4) --%>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=4&genreName=節約飯"
           class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center"
               style="background-color:#b6d7a8;">
            <h3 class="mb-0 text-dark">節約飯</h3>
          </div>
        </a>
      </div>

    </div>
  </div>
</div>

<%-- 下部固定ナビゲーション --%>
<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
  <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp"
     class="text-dark text-decoration-none text-center bar-home"
     style="min-width: 60px;">ホーム</a>

  <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp"
     class="text-dark text-decoration-none text-center bar-search"
     style="min-width: 60px;">検索</a>

  <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp"
     class="text-dark text-decoration-none text-center bar-recipe active"
     style="min-width: 60px;">料理提案</a>

  <a href="${pageContext.request.contextPath}/user/StoreList"
     class="text-dark text-decoration-none text-center bar-store"
     style="min-width: 60px;">店舗</a>

  <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp"
     class="text-dark text-decoration-none text-center bar-account"
     style="min-width: 60px;">アカウント</a>
</nav>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />
