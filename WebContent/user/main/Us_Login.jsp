<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="ログイン" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<%-- ★この画面専用のスタイル --%>
	<style>
		/* ヘッダー色をピンク/オレンジ系に（設計図のイメージ） */
		.page-header {
			background-color: #ffe5d9 !important;
		}
		/* フォームのスタイル */
		.form-label {
			font-weight: normal;
			margin-bottom: 5px;
			display: block;
			text-align: left;
		}
		.form-control {
			border-radius: 0; /* 角丸なし */
		}
	</style>

	<div class="container py-5" style="max-width: 400px;">

		<%-- ロゴ表示 --%>
		<div class="text-center mb-5">
			<img src="${pageContext.request.contextPath}/pic/recook_logo.png"
				 alt="Re.Cook" class="img-fluid" style="max-height: 80px;">
		</div>

		<%-- エラーメッセージ表示エリア --%>
		<c:if test="${param.error == 'login_failed'}">
			<div class="alert alert-danger text-center p-2 mb-4" role="alert">
				メールアドレスまたは<br>パスワードが間違っています。
			</div>
		</c:if>

		<%-- ■ログインフォーム --%>
		<form action="${pageContext.request.contextPath}/LoginServlet" method="post">

			<div class="row g-4">
				<%-- メールアドレス --%>
				<div class="col-12">
					<label for="email" class="form-label">メールアドレス</label>
					<input type="email" class="form-control" id="email" name="email" placeholder="example@email.com" required>
				</div>

				<%-- パスワード --%>
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

		<%-- 新規登録リンク --%>
		<div class="text-center mt-4">
			<a href="${pageContext.request.contextPath}/user/main/Us_NewAccount.jsp" class="text-muted small text-decoration-none">
				アカウントをお持ちでない方はこちら
			</a>
		</div>

	</div>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />