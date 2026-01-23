<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="新規登録" scope="request" />

<c:set var="pageBody" scope="request">
	<style>
		/* --- 1画面に固定する設定 --- */
	    html, body {
      		background: rgb(238, 237, 234) !important;
			height: 100vh;
			overflow: hidden; /* スクロール禁止 */
			margin: 0; padding: 0;
    	}

		.page-header { background-color: #ffe5d9 !important; }

		/* 見出しエリアのサイズを抑制 */
		.header-area { margin-bottom: 10px; }
		.header-area h3 { font-size: 1.4rem; margin-bottom: 0; }
		.header-area p { font-size: 0.8rem; margin-bottom: 5px; }

		/* 入力ラベルとボックスをコンパクトに */
		.form-label {
			font-size: 0.85rem;
			margin-bottom: 2px;
			display: block;
			text-align: left;
		}
		.form-control {
			border-radius: 0;
			height: 38px; /* 入力欄の高さを少し低く */
			font-size: 0.95rem;
		}

		/* エラーメッセージの余白を削る */
		.alert-compact {
			padding: 5px 10px;
			margin-bottom: 10px;
			font-size: 0.85rem;
		}
	</style>

	<%-- コンテナの上の余白を pt-5 から pt-3 に削減 --%>
	<div class="container pt-3" style="max-width: 400px;">

		<div class="header-area text-center">
			<h3 class="fw-bold">アカウント作成</h3>
			<p class="text-muted">必要な情報を入力してください</p>
		</div>

		<c:choose>
			<c:when test="${param.error == 'email_exists'}">
				<div class="alert alert-danger text-center alert-compact">このメールアドレスは登録されています。</div>
			</c:when>
			<c:when test="${not empty param.error}">
				<div class="alert alert-danger text-center alert-compact">登録に失敗しました。</div>
			</c:when>
		</c:choose>

		<%-- 入力項目間の隙間を g-4 から g-2 に大幅削減 --%>
		<form action="${pageContext.request.contextPath}/User_SignupServlet" method="post">
			<div class="row g-2">
				<div class="col-12">
					<label for="email" class="form-label">メールアドレス</label>
					<input type="email" class="form-control" id="email" name="email" placeholder="example@email.com" required>
				</div>

				<div class="col-12">
					<label for="password" class="form-label">パスワード</label>
					<input type="password" class="form-control" id="password" name="password" required>
				</div>

				<div class="col-12">
					<label for="username" class="form-label">お名前（アカウント名）</label>
					<input type="text" class="form-control" id="username" name="username" placeholder="例：山田 太郎" required>
				</div>

				<%-- 登録ボタンの上の余白を mt-5 から mt-3 に削減 --%>
				<div class="col-12 text-center mt-3">
					<button type="submit" class="btn btn-dark px-5" style="min-width: 180px; height: 45px;">
						登録する
					</button>
				</div>
			</div>
		</form>

		<div class="text-center mt-3">
			<a href="${pageContext.request.contextPath}/user/main/Us_Login.jsp" class="text-decoration-none text-muted small">
				すでにアカウントをお持ちの方はこちら
			</a>
		</div>
	</div>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />