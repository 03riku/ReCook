<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="ログアウト" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<%-- ★この画面専用のスタイル --%>
	<style>
		/* ヘッダー色をピンクに */
		.page-header {
			background-color: #ead1dc !important;
		}

		/* Yes/Noボタンのスタイル */
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
			transition: background-color 0.2s;
		}
		.confirm-btn:hover {
			background-color: #f0f0f0;
			color: #333;
		}
	</style>

	<div class="container text-center py-5" style="max-width: 500px;">

		<%-- メッセージエリア --%>
		<div class="py-5 mt-4">
			<h3 class="mb-5 fw-bold">ログアウトしますか？</h3>

			<div class="row justify-content-center g-3">
				<%-- Yesボタン --%>
				<div class="col-5">
					<%-- ★リンク修正：直接ログイン画面へ戻るように変更 --%>
					<a href="${pageContext.request.contextPath}/user/main/Us_Login.jsp" class="confirm-btn">
						Yes
					</a>
				</div>

				<%-- Noボタン --%>
				<div class="col-5">
					<%-- アカウント画面に戻る --%>
					<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="confirm-btn">
						No
					</a>
				</div>
			</div>
		</div>

	</div>

	<%-- 下部固定ナビゲーション --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>

		<%-- 現在地：アカウント --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
			<div>アカウント</div>
			<div class="mt-1 mx-auto" style="background-color: #ead1dc; height: 5px; width: 80%;"></div>
		</a>
	</nav>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />