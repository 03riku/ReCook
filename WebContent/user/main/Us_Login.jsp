<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="ログイン" scope="request" />

<c:set var="pageBody" scope="request">
	<style>
		/* --- 1画面に固定する設定 --- */
	    html, body {
      		background: rgb(238, 237, 234) !important;
			height: 100vh;
			overflow: hidden; /* スクロール禁止 */
			margin: 0; padding: 0;
    	}

    	/* ロゴボックスをコンパクトに調整 */
		.logo-box {
			border: 2px solid #000;
			background: #fff;
			padding: 10px 15px;      /* 余白を縮小 */
			display: inline-block;
			border-radius: 8px;
			margin-bottom: 15px;    /* 下の余白を削減 */
		}
		.logo-img {
			max-height: 90px;       /* ロゴの高さを抑える */
			width: auto;
		}

		.page-header { background-color: #ffe5d9 !important; }

		.form-label {
			font-size: 0.9rem;
			margin-bottom: 3px;
			display: block;
			text-align: left;
		}
		.form-control {
			border-radius: 0;
			height: 42px;
		}

		.alert-compact {
			padding: 6px;
			margin-bottom: 12px;
			font-size: 0.85rem;
		}
	</style>

	<%-- コンテナの上の余白を pt-5 から pt-3 に削減 --%>
	<div class="container pt-3" style="max-width: 400px;">

		<div class="text-center">
			<div class="logo-box">
				<img src="${pageContext.request.contextPath}/pic/recook_logo.png"
					 alt="Re.Cook" class="img-fluid logo-img">
			</div>
		</div>

		<c:if test="${param.error == 'login_failed'}">
			<div class="alert alert-danger text-center alert-compact" role="alert">
				メールアドレスまたは<br>パスワードが間違っています。
			</div>
		</c:if>

		<%-- 項目の隙間を g-4 から g-3 に変更 --%>
		<form action="${pageContext.request.contextPath}/User_LoginServlet" method="post">
			<div class="row g-3">
				<div class="col-12">
					<label for="email" class="form-label">メールアドレス</label>
					<input type="email" class="form-control" id="email" name="email" placeholder="example@email.com" required>
				</div>

				<div class="col-12">
					<label for="password" class="form-label">パスワード</label>
					<input type="password" class="form-control" id="password" name="password" required>
				</div>

				<div class="col-12 text-center mt-4">
					<button type="submit" class="btn btn-outline-dark px-5" style="background-color: #fff; min-width: 180px; height: 45px;">
						ログイン
					</button>
				</div>
			</div>
		</form>

		<div class="text-center mt-3">
			<a href="${pageContext.request.contextPath}/user/main/Us_NewAccount.jsp" class="text-muted small text-decoration-none">
				アカウントをお持ちでない方はこちら
			</a>
		</div>
	</div>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />