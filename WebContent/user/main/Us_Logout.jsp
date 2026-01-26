
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 1. ページの設定：ブラウザのタブ名や、見出しになる名前を設定 --%>
<c:set var="pageTitle" value="ログアウト" scope="request" />

<%-- 2. ページの中身（pageBody）の開始 --%>
<c:set var="pageBody" scope="request">

	<style>
		/* --- 見た目の設定（CSS） --- */

		/* 画面全体の背景を薄いグレーに設定 */
    	body {
      		background: rgb(238, 237, 234) !important;
    	}

		/* ヘッダー（base.jspにある共通見出し）の色設定：アカウント関連なのでピンク */
		.page-header {
			background-color: #ead1dc !important;
		}

		/* 「Yes」「No」ボタンのデザイン設定 */
		.confirm-btn {
			display: block;
			width: 100%;
			padding: 10px;
			background-color: #ffffff;
			border: 1px solid #333;
			color: #333;
			text-decoration: none;
			font-size: 1.2rem;
			text-align: center;
			transition: background-color 0.2s; /* ホバー時の色の変化を滑らかにする */
		}
		/* ボタンにマウスを乗せた（タップした）時の色 */
		.confirm-btn:hover {
			background-color: #f0f0f0;
			color: #333;
		}

		/* --- 下部固定メニューの「動く線」の設定 --- */
        .bottom-nav a {
            position: relative;
            padding-bottom: 10px;
        }

        /* 線の初期状態（透明・幅ゼロ） */
        .bottom-nav a::after {
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
        .bottom-nav a.active::after {
            transform: translateX(-50%) scaleX(1);
        }

        /* --- 各メニューごとのテーマカラー設定 --- */
        .bottom-nav a.bar-home    { --bar-color:#ffe5d9; } /* ホーム：薄ピンク */
        .bottom-nav a.bar-search  { --bar-color:#c9daf8; } /* 検索：青 */
        .bottom-nav a.bar-recipe  { --bar-color:#d9ead3; } /* 料理提案：緑 */
        .bottom-nav a.bar-store   { --bar-color:#fff2cc; } /* 店舗：黄 */
        .bottom-nav a.bar-account { --bar-color:#ead1dc; } /* アカウント：濃いピンク */

	</style>

	<%-- 3. メインコンテンツ：確認メッセージとボタン --%>
	<div class="container text-center py-5" style="max-width: 500px;">

		<div class="py-5 mt-4">
			<h3 class="mb-5 fw-bold">ログアウトしますか？</h3>

			<div class="row justify-content-center g-3">
				<%-- Yesボタン：User_LogoutServletを呼び出し、サーバー上のログイン情報を消去してログイン画面へ戻る --%>
				<div class="col-5">
					<a href="${pageContext.request.contextPath}/User_LogoutServlet" class="confirm-btn">
						Yes
					</a>
				</div>

				<%-- Noボタン：何もせず、前のアカウント管理画面に戻る --%>
				<div class="col-5">
					<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="confirm-btn">
						No
					</a>
				</div>
			</div>
		</div>

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

<%-- 5. 最後に土台となる base.jsp を読み込んで、上記の中身をはめ込む --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />