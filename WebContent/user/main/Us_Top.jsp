<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 1. ページの設定 --%>
<c:set var="pageTitle" value="ホーム" scope="request" />

<%-- 2. ページの中身（pageBody）の開始 --%>
<c:set var="pageBody" scope="request">
<style>
  /* --- 全体のレイアウト設定：1画面に固定し、スクロールを無効化 --- */
  html, body {
    background: rgb(238, 237, 234) !important;
    height: 100vh;            /* 画面の高さを100%に固定 */
    overflow: hidden;         /* スクロールを禁止 */
    margin: 0; padding: 0;
  }

  /* ロゴエリア（白い枠）：中央に配置し高さを調整 */
  .logo-wrap {
    max-width: 420px;
    margin: 20px auto 30px;   /* 上下の余白を調整 */
    background: #ffffff;
    border: 1px solid rgba(0,0,0,.08);
    border-radius: 12px;
    padding: 15px;
    box-shadow: 0 4px 12px rgba(0,0,0,.06);
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .logo-wrap img {
    max-height: 140px;        /* ロゴのサイズ */
    width: auto;
    object-fit: contain;
  }

  /* メインメニューのボタン設定 */
  .menu-wrap { max-width: 480px; margin: 0 auto; }
  .menu-btn {
    border-radius: 14px;
    min-height: 110px;        /* ナビバーがなくなった分、少し高さを出してもOK */
    box-shadow: 0 6px 15px rgba(0,0,0,.08);
    transition: transform .12s ease;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .menu-btn:hover { transform: translateY(-3px); }
  .menu-btn h3 {
    font-size: 1.6rem;
    margin-bottom: 0;
    font-weight: bold;
  }

  /* ナビゲーションバーを消したため、下の余白設定（page-safe-bottom）も不要 */
</style>

<div class="container text-center pt-3">

  <%-- A. ロゴ表示 --%>
  <div class="logo-wrap">
    <img src="${pageContext.request.contextPath}/pic/recook_logo.png" alt="Re.Cook Logo">
  </div>

  <%-- B. メインメニュー（4つの大きなボタン） --%>
  <div class="menu-wrap">
    <div class="row g-4">
      <%-- 1. 検索 --%>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-decoration-none">
          <div class="menu-btn" style="background-color:#c9daf8;">
            <h3 class="text-dark">検索</h3>
          </div>
        </a>
      </div>
      <%-- 2. 料理提案 --%>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-decoration-none">
          <div class="menu-btn" style="background-color:#d9ead3;">
            <h3 class="text-dark">料理提案</h3>
          </div>
        </a>
      </div>

      <%-- 3. 店舗 --%>
      <div class="col-6">
      <%-- もしサーブレットが /user/StoreList で登録されているなら、これで正解です --%>
      <a href="${pageContext.request.contextPath}/user/StoreList" class="text-decoration-none">
      <div class="menu-btn" style="background-color:#fff2cc;">
      <h3 class="text-dark">店舗</h3>
      </div>
      </a>
      </div>
      <%-- 4. アカウント --%>
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

<%-- ★ 下部固定ナビゲーション（fixed-bottom）のコードを削除しました --%>

</c:set>

<%-- 3. 最後に土台となる base.jsp を読み込む --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />