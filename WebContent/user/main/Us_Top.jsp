<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 1. ページの設定：ブラウザのタブ名や、画面の見出しになる名前を「ホーム」に設定 --%>
<c:set var="pageTitle" value="ホーム" scope="request" />

<%-- 2. ページの中身（pageBody）の開始 --%>
<c:set var="pageBody" scope="request">
<style>
  /* --- 全体の見た目（CSS）の設定 --- */

  html, body{
    background: rgb(238, 237, 234) !important; /* 画面全体の背景を薄いグレーに設定 */
    min-height: 100%;
  }

  /* ロゴエリア（白い枠）の設定 */
  .logo-wrap{
    max-width: 520px;
    margin: 0 auto 28px;
    background: #ffffff;             /* ロゴの後ろを白くする */
    border: 1px solid rgba(0,0,0,.08);
    border-radius: 12px;             /* 枠のカドを丸くする */
    padding: 18px 14px;              /* 白い枠の余白（内側） */
    box-shadow: 0 6px 16px rgba(0,0,0,.06); /* ぼんやりした影をつけて浮かせる */
    display: flex;
    justify-content: center;
    align-items: center;
  }
  /* ロゴ画像自体の大きさ調整 */
  .logo-wrap img{
    max-height: 180px;               /* ロゴを大きく表示するための高さ */
    width: auto;
    max-width: 100%;
    object-fit: contain;
  }

  /* メインメニューの四角いボタンの設定 */
  .menu-wrap{ max-width: 520px; margin: 0 auto; }
  .menu-btn{
    border-radius: 14px;             /* ボタンのカドを丸くする */
    min-height: 110px;               /* ボタンの高さ */
    box-shadow: 0 10px 22px rgba(0,0,0,.08); /* 下側に少し強い影をつける */
    transition: transform .12s ease, box-shadow .12s ease; /* 動きをなめらかにする設定 */
  }
  /* ボタンにマウスを乗せた（タップした）時の動き */
  .menu-btn:hover{
    transform: translateY(-2px);     /* 少し上に浮き上がる */
    box-shadow: 0 14px 26px rgba(0,0,0,.12); /* 影を強くして浮いている感を出す */
  }
  /* ボタンの中の文字（検索・店舗など）の設定 */
  .menu-btn h3{
    font-size: 1.7rem;
    letter-spacing: .04em;
  }

  /* --- 下部固定メニューの「動く線」の設定 --- */
  .bottom-nav a{
    position: relative;
    padding-bottom: 10px;
  }
  /* 線の初期状態（透明・幅ゼロ） */
  .bottom-nav a::after{
    content: "";
    position: absolute;
    left: 50%;
    bottom: 2px;
    width: 70%;
    height: 5px;
    background-color: var(--bar-color, #c9daf8);
    transform: translateX(-50%) scaleX(0); /* 最初は幅を0にして隠しておく */
    transform-origin: center;
    border-radius: 2px;
    transition: transform 0.15s ease;
  }
  /* ホバー時や「active（現在地）」の時に線をシュッと表示させる */
  .bottom-nav a:hover::after,
  .bottom-nav a.active::after{
    transform: translateX(-50%) scaleX(1) !important;
  }

  /* 各メニューごとのテーマカラー設定 */
  .bottom-nav a.bar-home    { --bar-color:#ffe5d9; } /* ホーム：薄ピンク */
  .bottom-nav a.bar-search  { --bar-color:#c9daf8; } /* 検索：青 */
  .bottom-nav a.bar-recipe  { --bar-color:#d9ead3; } /* 料理提案：緑 */
  .bottom-nav a.bar-store   { --bar-color:#fff2cc; } /* 店舗：黄 */
  .bottom-nav a.bar-account { --bar-color:#ead1dc; } /* アカウント：ピンク */

  /* 一番下までスクロールした時に、ナビと中身が被らないようにする余白 */
  .page-safe-bottom{ padding-bottom: 90px; }
</style>

<%-- 3. メインコンテンツ：ロゴと4つのボタン --%>
<div class="container text-center pt-4 page-safe-bottom">

  <%-- ロゴエリア --%>
  <div class="logo-wrap">
    <img src="${pageContext.request.contextPath}/pic/recook_logo.png" alt="Re.Cook Logo">
  </div>

  <%-- 四角いメニューボタンが並ぶエリア --%>
  <div class="menu-wrap">
    <div class="row g-3">
      <%-- 検索ボタン --%>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center" style="background-color:#c9daf8;">
            <h3 class="mb-0 text-dark">検索</h3>
          </div>
        </a>
      </div>

      <%-- 料理提案ボタン --%>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center" style="background-color:#d9ead3;">
            <h3 class="mb-0 text-dark">料理提案</h3>
          </div>
        </a>
      </div>

      <%-- 店舗一覧ボタン --%>
      <div class="col-6">
        <a href="${pageContext.request.contextPath}/user/StoreList" class="d-block text-decoration-none">
          <div class="menu-btn p-4 d-flex align-items-center justify-content-center" style="background-color:#fff2cc;">
            <h3 class="mb-0 text-dark">店舗</h3>
          </div>
        </a>
      </div>

      <%-- アカウントボタン --%>
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

<%-- 4. 下部固定ナビゲーション：常に画面の下に表示されるメニュー --%>
<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
  <%-- 現在のページなので "active" クラスを付与して線を常に表示 --%>
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

<%-- 5. 最後に土台となる base.jsp を読み込んで、上記の中身をはめ込む --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />