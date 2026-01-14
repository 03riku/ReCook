<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="アカウント" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<%-- ★この画面専用のスタイル --%>
	<style>
		/* ヘッダー色をピンクに上書き（設計図の色：#ead1dc） */
		.page-header {
			background-color: #ead1dc !important;
		}

		/* 大きなボタンのスタイル */
		.account-link-box {
			display: flex;
			align-items: center;
			justify-content: center;
			height: 150px; /* 高さを指定して四角くする */
			background-color: #ffffff;
			border: 1px solid #333; /* 黒い枠線 */
			color: #333;
			font-size: 1.5rem; /* 文字を大きく */
			text-decoration: none;
			transition: background-color 0.2s;
		}
		.account-link-box:hover {
			background-color: #f0f0f0; /* ホバー時に少しグレーに */
			color: #333;
		}
	</style>

	<div class="container py-5" style="max-width: 500px;">

		<div class="row g-4">
			<%-- お気に入りメニューボタン --%>
			<div class="col-12">
				<%-- ★リンク修正：Us_Recipes.jsp へ遷移 --%>
				<a href="${pageContext.request.contextPath}/user/main/Us_Recipes.jsp" class="account-link-box shadow-sm rounded">
					お気に入りメニュー
				</a>
			</div>

			<%-- ログアウトボタン --%>
			<div class="col-12">
				<a href="${pageContext.request.contextPath}/user/main/Us_Logout.jsp" class="account-link-box shadow-sm rounded">
					ログアウト
				</a>
			</div>
		</div>

	</div>

	<%-- 下部固定ナビゲーション --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
		<%-- ホーム --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
			ホーム
		</a>

		<%-- 検索 --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>

		<%-- 料理提案 --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>

		<%-- 店舗 --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>

		<%-- ★現在地：アカウント --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
			<div>アカウント</div>
			<%-- 下線（ピンク） --%>
			<div class="mt-1 mx-auto" style="background-color: #ead1dc; height: 5px; width: 80%;"></div>
		</a>
	</nav>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />