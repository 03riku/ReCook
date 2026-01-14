<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="新規登録" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<%-- スタイル設定 --%>
	<style>
		.page-header {
			background-color: #ffe5d9 !important; /* 薄いオレンジ */
		}
		.form-label {
			font-weight: normal;
			margin-bottom: 5px;
			display: block;
			text-align: left;
		}
		.form-control {
			border-radius: 0;
		}
	</style>

	<div class="container py-5" style="max-width: 400px;">

		<div class="text-center mb-4">
			<h3 class="fw-bold">アカウント作成</h3>
			<p class="text-muted small">必要な情報を入力してください</p>
		</div>

		<%-- エラーメッセージ --%>
		<c:if test="${not empty param.error}">
			<div class="alert alert-danger text-center p-2 mb-4" role="alert">
				登録に失敗しました。<br>入力内容を確認してください。
			</div>
		</c:if>

		<%-- ■ 新規登録フォーム --%>
		<%-- 入力されたデータを SignupServlet へ送信します --%>
		<form action="${pageContext.request.contextPath}/SignupServlet" method="post">

			<div class="row g-4">
				<%-- メールアドレス --%>
				<div class="col-12">
					<label for="email" class="form-label">メールアドレス</label>
					<input type="email" class="form-control" id="email" name="email" placeholder="example@email.com" required>
				</div>

				<%-- パスワード --%>
				<div class="col-12">
					<label for="password" class="form-label">パスワード</label>
					<input type="password" class="form-control" id="password" name="password" placeholder="パスワードを設定" required>
				</div>

				<%-- アカウント名 --%>
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

		<%-- ログイン画面へ戻る --%>
		<div class="text-center mt-4">
			<a href="${pageContext.request.contextPath}/user/main/Us_Login.jsp" class="text-decoration-none text-muted small">
				すでにアカウントをお持ちの方はこちら
			</a>
		</div>

	</div>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />