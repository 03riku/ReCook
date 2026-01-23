<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="料理検索" scope="request" />

<c:set var="pageBody" scope="request">
  <style>
    /* 横スクロールバー対策 */
    html, body {
      overflow-x: hidden !important;
    }

    /* ページ背景 */
    body {
      background: rgb(238, 237, 234) !important;
    }

    .page-header { background-color: #c9daf8 !important; }

    /* ロゴ枠 */
    .logo-box{
      border: 2px solid #000;
      background: #fff;
      padding: 18px 22px;
      display: inline-block;
      border-radius: 8px;
    }
    .logo-img{
      max-height: 140px;
      width: auto;
    }

    /* 検索バーのデザイン */
    .search-input-group {
      border: 2px solid #28a745;
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

    /* 下部固定ナビのデザイン */
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
  </style>

  <div class="container py-4" style="max-width: 500px;">

    <%-- ロゴセクション --%>
    <div class="text-center mb-4">
      <div class="logo-box">
        <img src="${pageContext.request.contextPath}/pic/recook_logo.png"
             alt="Re.Cook" class="img-fluid logo-img">
      </div>
    </div>

    <%-- 検索フォームセクション --%>
    <div class="row justify-content-center px-3 mx-0">
      <div class="col-12 px-0">
        <%-- ★ actionの中身をサーブレットのURLパターン(/user/Search)に合わせる --%>
        <form action="${pageContext.request.contextPath}/user/Search" method="get">
          <div class="input-group search-input-group shadow-sm">
            <button class="search-btn" type="submit"><i class="fas fa-search"></i></button>
            <%-- name属性はサーブレットのgetParameterと一致させる --%>
            <input type="text" name="keyword" class="form-control search-input" placeholder="料理名や食材を入力">
          </div>
        </form>
      </div>
    </div>

    <div style="height: 90px;"></div>
  </div>

  <%-- 下部固定ナビゲーション --%>
  <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
    <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp"
       class="text-dark text-decoration-none text-center bar-home"
       style="min-width: 60px;">ホーム</a>

    <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp"
       class="text-dark text-decoration-none text-center bar-search active"
       style="min-width: 60px;">検索</a>

    <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp"
       class="text-dark text-decoration-none text-center bar-recipe"
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