<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 店舗名を受け取る（パラメータがない場合はデフォルトでOO店） --%>
<c:set var="storeName" value="${param.storeName}" />
<c:if test="${empty storeName}">
	<c:set var="storeName" value="OO店" />
</c:if>

<%-- タイトル設定（ヘッダーに表示される文字） --%>
<c:set var="pageTitle" value="${storeName}" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<%-- ★この画面専用のスタイル --%>
	<style>
		/* ヘッダー色を水色に上書き（設計図の色） */
		.page-header {
			background-color: #9fc5e8 !important;
		}

		/* レシピリストの枠線スタイル */
		.recipe-row {
			border: 1px solid #333;
			border-top: none; /* 上の線は前の行と重なるので消す */
			transition: background-color 0.2s;
		}
		/* 最初の行だけ上線をつける */
		.recipe-link:first-of-type .recipe-row {
			border-top: 1px solid #333;
		}

		/* ホバー時の挙動 */
		.recipe-link:hover .recipe-row {
			background-color: #f8f9fa !important; /* 薄いグレー */
		}

		/* 画像プレースホルダー */
		.recipe-img-placeholder {
			width: 100%;
			height: 90px;
			background-color: #eee;
			display: flex;
			align-items: center;
			justify-content: center;
			color: #aaa;
			font-size: 0.8rem;
			object-fit: cover;
		}

		/* 設計図にある「値引き商品は赤色」のスタイル */
		.discount-text {
			color: #ff0000; /* 赤色 */
			font-weight: bold;
		}
	</style>

	<div class="container py-0" style="max-width: 500px;">

		<%-- サブヘッダー --%>
		<div class="text-center py-2 border border-dark border-bottom-0 bg-white mt-3">
			<h6 class="mb-0">値引き商品を使ったレシピ</h6>
		</div>

		<%-- ■■■ レシピリスト ■■■ --%>
		<%-- 各レシピを <a> タグで囲んでクリック可能にしています --%>

		<%-- 1. ビーフシチュー --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Coupon.jsp?recipeName=簡単！ビーフシチュー" class="text-decoration-none text-dark recipe-link">
			<div class="row g-0 recipe-row bg-white p-2 align-items-center">
				<%-- 画像エリア --%>
				<div class="col-4">
					<div class="recipe-img-placeholder border">
						<i class="fas fa-utensils fa-2x"></i>
					</div>
				</div>
				<%-- 詳細エリア --%>
				<div class="col-8 ps-3 text-start">
					<div class="fw-bold">ビーフシチュー <span class="small fw-normal ms-1"><i class="far fa-clock"></i> 所要時間40分</span></div>
					<div class="small mt-1">
						<%-- 牛肉が赤字 --%>
						・<span class="discount-text">牛肉</span>　・にんじん　・玉ねぎ<br>
						・じゃがいも　・ブロッコリー
					</div>
				</div>
			</div>
		</a>

		<%-- 2. えび炒飯 --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Coupon.jsp?recipeName=えび炒飯" class="text-decoration-none text-dark recipe-link">
			<div class="row g-0 recipe-row bg-white p-2 align-items-center">
				<div class="col-4">
					<div class="recipe-img-placeholder border">
						<i class="fas fa-utensils fa-2x"></i>
					</div>
				</div>
				<div class="col-8 ps-3 text-start">
					<div class="fw-bold">えび炒飯 <span class="small fw-normal ms-1"><i class="far fa-clock"></i> 所要時間20分</span></div>
					<div class="small mt-1">
						・えび　・卵　・米<br>
						<%-- ニンニクが赤字 --%>
						・白ネギ　・<span class="discount-text">ニンニク</span>
					</div>
				</div>
			</div>
		</a>

		<%-- 3. エビチリ --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Coupon.jsp?recipeName=エビチリ" class="text-decoration-none text-dark recipe-link">
			<div class="row g-0 recipe-row bg-white p-2 align-items-center">
				<div class="col-4">
					<div class="recipe-img-placeholder border">
						<i class="fas fa-utensils fa-2x"></i>
					</div>
				</div>
				<div class="col-8 ps-3 text-start">
					<div class="fw-bold">エビチリ <span class="small fw-normal ms-1"><i class="far fa-clock"></i> 所要時間50分</span></div>
					<div class="small mt-1">
						<%-- えびが赤字 --%>
						・<span class="discount-text">えび</span>　・ぱせり・チリソース<br>
						・鳥そぼろ
					</div>
				</div>
			</div>
		</a>

		<%-- 下部の注釈 --%>
		<div class="border border-dark border-top-0 p-2 bg-white text-center">
			<p class="small mb-1 text-muted" style="font-size: 0.75rem;">
				※値引き商品が売り切れた場合でもクーポンはご利用できます
			</p>
			<p class="small mb-0 fw-bold" style="font-size: 0.8rem;">
				値引きされている商品は赤色で表示されています
			</p>
		</div>

	</div>

	<%-- 下部固定ナビゲーション --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>

		<%-- ★現在地：店舗（黄色ハイライト） --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
			<div>店舗</div>
			<div class="mt-1 mx-auto" style="background-color: #ffff00; height: 5px; width: 80%;"></div>
		</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
	</nav>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />