<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 1. ページの設定：ブラウザのタブ名や、画面上部の見出しになる名前を設定 --%>
<c:set var="pageTitle" value="新規登録" scope="request" />

<%-- 2. ページの中身（pageBody）の開始 --%>
<c:set var="pageBody" scope="request">

	<style>
		/* --- 見た目の設定（CSS） --- */

	    /* 画面全体の背景を薄いグレーに設定 */
    	body {
      		background: rgb(238, 237, 234) !important;
    	}

		/* ヘッダー部分（base.jspにある共通見出し）の色設定：新規登録は薄いオレンジ */
		.page-header {
			background-color: #ffe5d9 !important;
		}

		/* 入力欄（メール・パスワードなど）のラベルの設定 */
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

	<%-- 3. メインコンテンツ：中央に配置するための枠組み --%>
	<div class="container py-5" style="max-width: 400px;">

		<div class="text-center mb-4">
			<h3 class="fw-bold">アカウント作成</h3>
			<p class="text-muted small">必要な情報を入力してください</p>
		</div>

		<%-- 4. エラーメッセージ表示：サーブレットからの「失敗の合図」を読み取って表示 --%>
		<c:choose>
			<%-- メールアドレスが既にDBに存在する場合（サーブレットで判定された結果） --%>
			<c:when test="${param.error == 'email_exists'}">
				<div class="alert alert-danger text-center p-2 mb-4" role="alert">
					このメールアドレスは登録されています。
				</div>
			</c:when>
			<%-- その他の理由（入力不備やシステムエラーなど）で失敗した場合 --%>
			<c:when test="${not empty param.error}">
				<div class="alert alert-danger text-center p-2 mb-4" role="alert">
					登録に失敗しました。<br>入力内容を確認してください。
				</div>
			</c:when>
		</c:choose>

		<%-- 5. 新規登録フォーム：入力されたデータを User_SignupServlet（登録処理担当）へ送る --%>
		<form action="${pageContext.request.contextPath}/User_SignupServlet" method="post">

			<div class="row g-4">
				<%-- メールアドレス入力欄 --%>
				<div class="col-12">
					<label for="email" class="form-label">メールアドレス</label>
					<input type="email" class="form-control" id="email" name="email" placeholder="example@email.com" required>
				</div>

				<%-- パスワード入力欄 --%>
				<div class="col-12">
					<label for="password" class="form-label">パスワード</label>
					<input type="password" class="form-control" id="password" name="password" placeholder="パスワードを設定" required>
				</div>

				<%-- アカウント名（ユーザー名）入力欄 --%>
				<div class="col-12">
					<label for="username" class="form-label">お名前（アカウント名）</label>
					<input type="text" class="form-control" id="username" name="username" placeholder="例：山田 太郎" required>
				</div>

				<%-- 登録ボタン --%>
				<div class="col-12 text-center mt-5">
					<button type="submit" class="btn btn-dark px-5 py-2" style="min-width: 200px;">
						登録する
					</button>
				</div>
			</div>
		</form>

		<%-- 6. ログイン画面への案内リンク：すでにアカウントがある人向け --%>
		<div class="text-center mt-4">
			<a href="${pageContext.request.contextPath}/user/main/Us_Login.jsp" class="text-decoration-none text-muted small">
				すでにアカウントをお持ちの方はこちら
			</a>
		</div>

	</div>

</c:set>

<%-- 7. 最後に土台となる base.jsp を読み込んで、上記の中身をはめ込む --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />