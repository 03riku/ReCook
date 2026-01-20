<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="ホーム" scope="request" />

<c:set var="pageBody" scope="request">
<style>
  html, body{
    background: rgb(238, 237, 234) !important;
    min-height: 100%;
  }

  /* =========================
     ロゴ枠（白い枠）を小さく / ロゴを大きく
     ========================= */
  .logo-wrap{
    max-width: 520px;
    margin: 0 auto 28px;
    background: #ffffff;
    border: 1px solid rgba(0,0,0,.08);
    border-radius: 12px;
    padding: 18px 14px; /* ← 白枠を小さめに */
    box-shadow: 0 6px 16px rgba(0,0,0,.06);
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .logo-wrap img{
    max-height: 180px; /* ← ロゴを大きめに */
    width: auto;
    max-width: 100%;
    object-fit: contain;
  }

  /* =========================
     メニューボタン（完成形）
     ========================= */
  .menu-wrap{ max-width: 520px; margin: 0 auto; }
  .menu-btn{
    border-radius: 14px;
    min-height: 110px;
    box-shadow: 0 10px 22px rgba(0,0,0,.08);
    transition: transform .12s ease, box-shadow .12s ease;
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

  <%-- ロゴエリア（白枠小さめ & ロゴ大きめ） --%>
  <div class="logo-wrap">
    <img src="${pageContext.request.contextPath}/pic/recook_logo.png" alt="Re.Cook Logo">
  </div>

  <%-- メニューボタン --%>
  <div class="menu-wrap">
    <div class="row g-3">
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center" style="background-color:#c9daf8;">
            <h3 class="mb-0 text-dark">検索</h3>
          </div>
        </a>
      </div>

      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center" style="background-color:#d9ead3;">
            <h3 class="mb-0 text-dark">料理提案</h3>
          </div>
        </a>
      </div>

      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/StoreList" class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center" style="background-color:#fff2cc;">
            <h3 class="mb-0 text-dark">店舗</h3>
          </div>
        </a>
      </div>

      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center" style="background-color:#ead1dc;">
            <h3 class="mb-0 text-dark">アカウント</h3>
          </div>
        </a>
      </div>
    </div>
  </div>
</div>

<%-- 下部固定ナビゲーション --%>
<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
  <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp"
     class="text-dark text-decoration-none text-center bar-home active"
     style="min-width:60px;">ホーム</a>

  <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp"
     class="text-dark text-decoration-none text-center bar-search"
     style="min-width:60px;">検索</a>

  <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp"
     class="text-dark text-decoration-none text-center bar-recipe"
     style="min-width:60px;">料理提案</a>

  <a href="${pageContext.request.contextPath}/user/StoreList"
     class="text-dark text-decoration-none text-center bar-store"
     style="min-width:60px;">店舗</a>

  <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp"
     class="text-dark text-decoration-none text-center bar-account"
     style="min-width:60px;">アカウント</a>
</nav>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />
