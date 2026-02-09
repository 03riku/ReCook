<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 1. ページの設定：ブラウザのタブ名や、共通ヘッダーに表示される名前を設定 --%>
<c:set var="pageTitle" value="料理検索" scope="request" />

<%-- 2. ページの中身（pageBody）の開始 --%>
<c:set var="pageBody" scope="request">
  <style>
    /* --- 全体のレイアウト設定 --- */

    /* 横スクロールが出て画面がガタつくのを防ぐ設定 */
    html, body {
      overflow-x: hidden !important;
    }

    /* 画面全体の背景を薄いグレーに設定 */
    body {
      background: rgb(238, 237, 234) !important;
    }

    /* ヘッダー（base.jspにある共通見出し）の色：検索画面のテーマカラーは青 */
    .page-header { background-color: #c9daf8 !important; }

    /* ロゴを囲む白い枠のデザイン */
    .logo-box{
      border: 2px solid #000;     /* 黒い枠線 */
      background: #fff;           /* 枠の中を白くする */
      padding: 18px 22px;         /* ロゴの周りに余白を作る */
      display: inline-block;      /* ロゴの大きさに合わせて枠を縮める */
      border-radius: 8px;         /* カドを少し丸くする */
    }

    /* ロゴ画像自体の大きさ調整 */
    .logo-img{
      max-height: 140px;
      width: auto;
    }

    /* --- 検索バーのデザイン --- */
    .search-input-group {
      border: 2px solid #28a745;  /* 緑色の枠線 */
      border-radius: 10px;        /* カドを丸く */
      overflow: hidden;
      background-color: #fff;
    }

    /* 入力する場所の設定 */
    .search-input {
      border: none !important;
      height: 55px;
      font-size: 1.2rem;
      box-shadow: none !important;
    }

    /* 虫眼鏡ボタンの設定 */
    .search-btn {
      background-color: transparent;
      border: none;
      padding: 0 15px;
      color: #28a745;
      font-size: 1.3rem;
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
  </style>

  <%-- 3. メインコンテンツ：中央に配置するための枠組み --%>
  <div class="container py-4" style="max-width: 500px;">

    <%-- ロゴ部分 --%>
    <div class="text-center mb-4">
      <div class="logo-box">
        <img src="${pageContext.request.contextPath}/pic/recook_logo.png"
             alt="Re.Cook" class="img-fluid logo-img">
      </div>
    </div>

    <%-- 4. 検索フォーム：入力されたキーワードを User_SearchServlet へ送る --%>
    <div class="row justify-content-center px-3 mx-0">
      <div class="col-12 px-0">
        <%-- action: データの送り先（サーブレットのURL）
             method="get": キーワード検索なのでURLに検索ワードをのせる「GET」方式を使用 --%>
        <form action="${pageContext.request.contextPath}/user/Search" method="get">
          <div class="input-group search-input-group shadow-sm">
            <%-- 検索実行ボタン（虫眼鏡） --%>
            <button class="search-btn" type="submit"><i class="fas fa-search"></i></button>

            <%-- キーワード入力欄
                 name="keyword": サーブレットがこの名前を頼りに中身を読み取ります --%>
            <input type="text" name="keyword" class="form-control search-input" placeholder="料理名や食材を入力">
          </div>
        </form>
      </div>
    </div>

    <%-- 下部メニューに隠れないように余白を作る --%>
    <div style="height: 90px;"></div>
  </div>
  
  <!-- 下部固定ナビゲーション -->
<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
  
  <!-- ホーム -->
  <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp"
     class="text-dark text-decoration-none text-center bar-home"
     style="min-width: 60px;">ホーム</a>

  <!-- 検索 -->
  <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp"
     class="text-dark text-decoration-none text-center bar-search"
     style="min-width: 60px;">検索</a>

  <!-- 料理提案 -->
  <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp"
     class="text-dark text-decoration-none text-center bar-recipe"
     style="min-width: 60px;">料理提案</a>

  <!-- 店舗（★必ずサーブレットのURLを指定します） -->
  <a href="${pageContext.request.contextPath}/user/StoreList"
     class="text-dark text-decoration-none text-center bar-store"
     style="min-width: 60px;">店舗</a>

  <!-- アカウント -->
  <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp"
     class="text-dark text-decoration-none text-center bar-account"
     style="min-width: 60px;">アカウント</a>
     
     </nav>

</c:set>

<%-- 6. 最後に土台となる base.jsp を読み込んで、上記の中身をはめ込む --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />