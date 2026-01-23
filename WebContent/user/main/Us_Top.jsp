<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="ホーム" scope="request" />

<c:set var="pageBody" scope="request">
<style>
  /* --- 全体のレイアウト設定：1画面に収める --- */
  html, body {
    background: rgb(238, 237, 234) !important;
    height: 100vh;            /* 画面の高さを100%に固定 */
    overflow: hidden;         /* はみ出してもスクロールさせない */
    margin: 0;
    padding: 0;
  }

  /* ロゴエリア（白い枠）：高さを抑える */
  .logo-wrap {
    max-width: 420px;
    margin: 5px auto 15px;    /* 上の余白を最小限に */
    background: #ffffff;
    border: 1px solid rgba(0,0,0,.08);
    border-radius: 12px;
    padding: 10px;            /* 内側の余白を削る */
    box-shadow: 0 4px 12px rgba(0,0,0,.06);
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .logo-wrap img {
    max-height: 120px;        /* ロゴを少し小さく */
    width: auto;
    object-fit: contain;
  }

  /* メインメニューのボタン設定 */
  .menu-wrap { max-width: 480px; margin: 0 auto; }
  .menu-btn {
    border-radius: 14px;
    min-height: 95px;         /* 高さを少し低く調整 */
    box-shadow: 0 6px 15px rgba(0,0,0,.08);
    transition: transform .12s ease;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .menu-btn:hover { transform: translateY(-2px); }
  .menu-btn h3 {
    font-size: 1.5rem;        /* 文字サイズを微調整 */
    margin-bottom: 0;
  }

  /* 下部ナビゲーションの設定 */
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

<%-- 上の余白を pt-4 から pt-2 に削減 --%>
<div class="container text-center pt-2">

  <div class="logo-wrap">
    <img src="${pageContext.request.contextPath}/pic/recook_logo.png" alt="Re.Cook Logo">
  </div>

  <div class="menu-wrap">
    <div class="row g-3">
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-decoration-none">
          <div class="menu-btn" style="background-color:#c9daf8;">
            <h3 class="text-dark">検索</h3>
          </div>
        </a>
      </div>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-decoration-none">
          <div class="menu-btn" style="background-color:#d9ead3;">
            <h3 class="text-dark">料理提案</h3>
          </div>
        </a>
      </div>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/StoreList" class="text-decoration-none">
          <div class="menu-btn" style="background-color:#fff2cc;">
            <h3 class="text-dark">店舗</h3>
          </div>
        </a>
      </div>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-decoration-none">
          <div class="menu-btn" style="background-color:#ead1dc;">
            <h3 class="text-dark">アカウント</h3>
          </div>
        </a>
      </div>
    </div>
  </div>
</div>

<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
  <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center bar-home active" style="min-width:60px;">ホーム</a>
  <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center bar-search" style="min-width:60px;">検索</a>
  <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center bar-recipe" style="min-width:60px;">料理提案</a>
  <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center bar-store" style="min-width:60px;">店舗</a>
  <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center bar-account" style="min-width:60px;">アカウント</a>
</nav>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />