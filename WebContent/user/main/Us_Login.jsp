<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 1. ページの設定：ブラウザのタブ名や画面の見出しになる名前を設定 --%>
<c:set var="pageTitle" value="ログイン" scope="request" />

<%-- 2. ページの中身（pageBody）の開始 --%>
<c:set var="pageBody" scope="request">

	<style>
		/* --- 見た目の設定（CSS） --- */

	    /* 画面全体の背景を薄いグレーにする */
    	body {
      		background: rgb(238, 237, 234) !important;
    	}

    	/* ロゴを囲む白い枠のデザイン */
		.logo-box {
			border: 2px solid #000;     /* 黒い枠線 */
			background: #fff;           /* 枠の中を白くする */
			padding: 18px 22px;         /* ロゴの周りに余白を作る */
			display: inline-block;      /* ロゴの大きさに合わせて枠を縮める */
			border-radius: 8px;         /* 角を少し丸くする */
		}

		/* ロゴ画像自体の大きさ調整 */
		.logo-img {
			max-height: 140px;
			width: auto;
		}

		/* ヘッダー部分（base.jspにある共通見出し）の色設定 */
		.page-header {
			background-color: #ffe5d9 !important; /* 薄いオレンジ系 */
		}

		/* 入力欄（メール・パスワード）のラベルの設定 */
		.form-label {
			font-weight: normal;
			margin-bottom: 5px;
			display: block;
			text-align: left;
		}

		/* 入力ボックスのカドを四角くする設定 */
		.form-control {
			border-radius: 0;
		}
	</style>

	<%-- 3. メインコンテンツ：中央に配置するためのコンテナ --%>
	<div class="container py-5" style="max-width: 400px;">

		<%-- ロゴ部分 --%>
		<div class="text-center mb-5">
			<div class="logo-box">
				<img src="${pageContext.request.contextPath}/pic/recook_logo.png"
					 alt="Re.Cook" class="img-fluid logo-img">
			</div>
		</div>

		<%-- 4. エラー表示：サーブレットから「login_failed」という合図が届いたら表示する --%>
		<c:if test="${param.error == 'login_failed'}">
			<div class="alert alert-danger text-center p-2 mb-4" role="alert">
				メールアドレスまたは<br>パスワードが間違っています。
			</div>
		</c:if>

		<%-- 5. ログインフォーム：入力されたデータを User_LoginServlet へ送る --%>
		<form action="${pageContext.request.contextPath}/User_LoginServlet" method="post">

			<div class="row g-4">
				<%-- メールアドレス入力欄 --%>
				<div class="col-12">
					<label for="email" class="form-label">メールアドレス</label>
					<input type="email" class="form-control" id="email" name="email" placeholder="example@email.com" required>
				</div>

				<%-- パスワード入力欄 --%>
				<div class="col-12">
					<label for="password" class="form-label">パスワード</label>
					<input type="password" class="form-control" id="password" name="password" placeholder="パスワードを入力" required>
				</div>

				<%-- ログインボタン --%>
				<div class="col-12 text-center mt-5">
					<button type="submit" class="btn btn-outline-dark px-5 py-2" style="background-color: #fff; min-width: 200px;">
						ログイン
					</button>
				</div>
			</div>
		</form>

		<%-- 6. 新規登録画面への案内リンク --%>
		<div class="text-center mt-4">
			<a href="${pageContext.request.contextPath}/user/main/Us_NewAccount.jsp" class="text-muted small text-decoration-none">
				アカウントをお持ちでない方はこちら
			</a>
		</div>

	</div>

</c:set>

<%-- 7. 最後に土台となる base.jsp を読み込んで、上記の中身をはめ込む --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />