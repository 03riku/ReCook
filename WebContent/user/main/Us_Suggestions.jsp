<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="料理提案" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<%-- ヘッダー色と、この画面専用のリストデザイン --%>
	<style>
		.page-header {
			background-color: #d9ead3 !important;
		}

		/* レシピリストのスタイル */
		.recipe-item {
			border-bottom: 1px solid #000;
			padding: 15px 0;
			transition: background-color 0.2s; /* ホバー時のアニメーション */
		}

		/* リンク全体のスタイル調整 */
		.recipe-link {
			text-decoration: none;
			color: #333;
			display: block;
		}

		/* ホバー時に背景を少しグレーにする */
		.recipe-link:hover .recipe-item {
			background-color: #f8f9fa;
		}

		/* 画像プレースホルダー */
		.recipe-img-placeholder {
			width: 100%;
			height: 100px;
			background-color: #eee;
			display: flex;
			align-items: center;
			justify-content: center;
			color: #aaa;
			font-size: 0.8rem;
		}
	</style>

	<%-- パラメータの受け取りと表示名の決定 --%>
	<c:set var="genreCode" value="${param.genre}" />
	<c:choose>
		<c:when test="${genreCode == 'japanese'}"> <c:set var="genreName" value="和食" /> </c:when>
		<c:when test="${genreCode == 'western'}"> <c:set var="genreName" value="洋食" /> </c:when>
		<c:when test="${genreCode == 'budget'}"> <c:set var="genreName" value="節約飯" /> </c:when>
		<c:when test="${genreCode == 'manmeshi'}"> <c:set var="genreName" value="漢メシ" /> </c:when>
		<c:otherwise> <c:set var="genreName" value="選択なし" /> </c:otherwise>
	</c:choose>

	<div class="container py-0" style="max-width: 500px;">

		<%-- サブヘッダー：ジャンル名 --%>
		<div class="text-center py-2 border-bottom border-dark mb-0">
			<h5 class="mb-0">ジャンル選択中 ： ${genreName}</h5>
		</div>

		<%-- ■■■ ここからレシピリスト ■■■ --%>

		<%-- パターン1：漢メシが選ばれた場合（設計図通りのデータを表示） --%>
		<c:if test="${genreCode == 'manmeshi'}">

			<%-- レシピ1：リンク追加 --%>
			<a href="${pageContext.request.contextPath}/user/main/Us_Coupon.jsp?recipeName=ニンニク効きすぎいTHE漢炒飯" class="recipe-link">
				<div class="row g-0 recipe-item">
					<div class="col-4 px-2">
						<div class="recipe-img-placeholder border">
							<i class="fas fa-utensils fa-2x"></i>
						</div>
					</div>
					<div class="col-8 px-1 text-start">
						<div class="fw-bold">ニンニク効きすぎいTHE漢炒飯</div>
						<div class="text-muted small"><i class="far fa-clock"></i> 所要時間 60分</div>
						<div class="small mt-1">・米 ・卵 ・鶏肉<br>・ネギ ・ニンニク</div>
					</div>
				</div>
			</a>

			<%-- レシピ2：リンク追加 --%>
			<a href="${pageContext.request.contextPath}/user/main/Us_Coupon.jsp?recipeName=ニンニクッ豚丼ン" class="recipe-link">
				<div class="row g-0 recipe-item">
					<div class="col-4 px-2">
						<div class="recipe-img-placeholder border">
							<i class="fas fa-utensils fa-2x"></i>
						</div>
					</div>
					<div class="col-8 px-1 text-start">
						<div class="fw-bold">ニンニクッ豚丼ン</div>
						<div class="text-muted small"><i class="far fa-clock"></i> 所要時間 20分</div>
						<div class="small mt-1">・米 ・豚肉 ・キャベツ<br>・ネギ ・ニンニク</div>
					</div>
				</div>
			</a>

			<%-- レシピ3：リンク追加 --%>
			<a href="${pageContext.request.contextPath}/user/main/Us_Coupon.jsp?recipeName=ジョニー発祥のニンニク漢メシ" class="recipe-link">
				<div class="row g-0 recipe-item">
					<div class="col-4 px-2">
						<div class="recipe-img-placeholder border">
							<i class="fas fa-utensils fa-2x"></i>
						</div>
					</div>
					<div class="col-8 px-1 text-start">
						<div class="fw-bold">ジョニー発祥のニンニク漢メシ</div>
						<div class="text-muted small"><i class="far fa-clock"></i> 所要時間 50分</div>
						<div class="small mt-1">・牛肉 ・豚肉 ・ニンニク<br>・もやし ・キャベツ</div>
					</div>
				</div>
			</a>
		</c:if>


		<%-- パターン2：その他のジャンルが選ばれた場合（ダミー表示） --%>
		<c:if test="${genreCode != 'manmeshi'}">
			<div class="py-5 text-center">
				<h4 class="text-muted">「${genreName}」のレシピ</h4>
				<p>現在準備中です。</p>
			</div>
		</c:if>

	</div>

	<%-- 下部固定ナビゲーション --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>

		<%-- 現在地 --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
			<div>料理提案</div>
			<div class="mt-1 mx-auto" style="background-color: #b6d7a8; height: 5px; width: 80%;"></div>
		</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
	</nav>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />