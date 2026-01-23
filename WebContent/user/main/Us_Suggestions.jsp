<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 1. ページの設定：ヘッダーに表示されるタイトルを「料理提案」に設定 --%>
<c:set var="pageTitle" value="料理提案" scope="request" />

<%-- 2. ページの中身（pageBody）の開始 --%>
<c:set var="pageBody" scope="request">

	<style>
		/* --- 見た目の設定（CSS） --- */

		/* ページ上部の見出し部分の色設定（緑色） */
		.page-header {
			background-color: #d9ead3 !important;
		}

		/* 料理リスト1件ごとの枠のデザイン（下の線と余白） */
		.recipe-item {
			border-bottom: 1px solid #000;
			padding: 15px 0;
			transition: background-color 0.2s; /* 色の変化を滑らかにする */
		}

		/* リンク（カード全体）の設定 */
		.recipe-link {
			text-decoration: none;
			color: #333;
			display: block;
		}

		/* 料理にマウスを乗せた（タップした）時に背景を少しグレーにする設定 */
		.recipe-link:hover .recipe-item {
			background-color: #f8f9fa;
		}

		/* 画像がない場合に表示するダミーのグレー枠の設定 */
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

	<%-- 3. ジャンル判定ロジック：前の画面から届いた「ジャンルコード」を名前に変換 --%>
	<c:set var="genreCode" value="${param.genre}" />
	<c:choose>
		<%-- japanese が届いたら「和食」と表示する、といった設定 --%>
		<c:when test="${genreCode == 'japanese'}"> <c:set var="genreName" value="和食" /> </c:when>
		<c:when test="${genreCode == 'western'}"> <c:set var="genreName" value="洋食" /> </c:when>
		<c:when test="${genreCode == 'budget'}"> <c:set var="genreName" value="節約飯" /> </c:when>
		<c:when test="${genreCode == 'manmeshi'}"> <c:set var="genreName" value="漢メシ" /> </c:when>
		<c:otherwise> <c:set var="genreName" value="選択なし" /> </c:otherwise>
	</c:choose>

	<div class="container py-0" style="max-width: 500px;">

		<%-- 現在選んでいるジャンル名を表示するエリア --%>
		<div class="text-center py-2 border-bottom border-dark mb-0">
			<h5 class="mb-0">ジャンル選択中 ： ${genreName}</h5>
		</div>

		<%-- 4. レシピ表示エリア：漢メシが選ばれた場合のみ、決まった3件の料理を表示（デモ用） --%>
		<c:if test="${genreCode == 'manmeshi'}">

			<%-- 料理1件目：クリックするとクーポン提示画面（Us_Coupon.jsp）へ移動 --%>
			<a href="${pageContext.request.contextPath}/user/main/Us_Coupon.jsp?recipeName=ニンニク効きすぎいTHE漢炒飯" class="recipe-link">
				<div class="row g-0 recipe-item">
					<%-- 左側：画像（アイコン） --%>
					<div class="col-4 px-2">
						<div class="recipe-img-placeholder border">
							<i class="fas fa-utensils fa-2x"></i>
						</div>
					</div>
					<%-- 右側：料理名と所要時間、主な材料 --%>
					<div class="col-8 px-1 text-start">
						<div class="fw-bold">ニンニク効きすぎいTHE漢炒飯</div>
						<div class="text-muted small"><i class="far fa-clock"></i> 所要時間 60分</div>
						<div class="small mt-1">・米 ・卵 ・鶏肉<br>・ネギ ・ニンニク</div>
					</div>
				</div>
			</a>

			<%-- 料理2件目 --%>
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

			<%-- 料理3件目 --%>
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


		<%-- 5. 準備中エリア：漢メシ以外のジャンルが選ばれた時に表示 --%>
		<c:if test="${genreCode != 'manmeshi'}">
			<div class="py-5 text-center">
				<h4 class="text-muted">「${genreName}」のレシピ</h4>
				<p>現在準備中です。</p>
			</div>
		</c:if>

	</div>

	<%-- 6. 下部固定ナビゲーション：画面下部に常に表示されるメニュー --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>

		<%-- 現在表示中のメニュー（料理提案）の下に、テーマカラー（緑）の線を引く --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
			<div>料理提案</div>
			<div class="mt-1 mx-auto" style="background-color: #b6d7a8; height: 5px; width: 80%;"></div>
		</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
	</nav>

</c:set>

<%-- 7. 最後に土台となる base.jsp を読み込んで、上記の中身をはめ込む --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />