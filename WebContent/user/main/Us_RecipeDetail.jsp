<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- サーブレットから渡された cookMenu オブジェクトを変数 menu に代入 --%>
<c:set var="menu" value="${cookMenu}" />

<%-- タイトル設定（DBの料理名を使用） --%>
<c:set var="pageTitle" value="${menu.dishName}" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<style>
		.page-header { background-color: #ead1dc !important; }
		.fav-btn {
			border: 1px solid #333; background-color: #fff; padding: 5px 10px;
			font-size: 0.9rem; text-decoration: none; color: #333;
			display: inline-block; white-space: nowrap; transition: background-color 0.2s; cursor: pointer;
		}
		.fav-btn:hover { background-color: #f0f0f0; color: #333; }
		.dashed-line { border-top: 2px dashed #999; margin: 20px 0; }
		.desc-header {
			border-top: 1px solid #333; border-bottom: 1px solid #333;
			padding: 5px; text-align: center; font-weight: bold; margin-bottom: 15px;
		}
		.coupon-btn {
			background-color: #ffff00; border: 2px solid #333; color: #333;
			font-weight: bold; padding: 15px; width: 100%; font-size: 1.1rem; transition: opacity 0.2s;
		}
		.coupon-btn:hover { opacity: 0.8; }
	</style>

	<div class="container py-0 px-0" style="max-width: 500px;">
		<%-- 料理画像エリア --%>
		<div class="bg-light d-flex align-items-center justify-content-center border-bottom border-dark" style="height: 220px; width: 100%;">
			<div class="text-center text-muted">
				<i class="fas fa-utensils fa-4x mb-2"></i><br>
				料理画像
			</div>
		</div>

		<div class="container px-4 py-3">
			<%-- 料理名 --%>
			<h4 class="fw-bold mb-3">${menu.dishName}</h4>

			<div class="row align-items-end mb-3">
				<div class="col-6">
					<div class="fw-bold"><i class="far fa-clock"></i> 調理時間</div>
					<div class="ps-3 fs-5">60分</div>
				</div>
				<div class="col-6 text-end">
					<a href="#" class="fav-btn shadow-sm">
						<i class="far fa-star"></i> お気に入り登録
					</a>
				</div>
			</div>

			<div class="dashed-line"></div>

			<%-- 紹介文 --%>
			<div class="mb-4 text-center">
				<p>
					「${menu.dishName}」のレシピと<br>
					作り方をご紹介！
				</p>
			</div>

			<div class="desc-header mt-5">商品説明</div>

			<%-- 商品説明本文（DBのDESCRIPTIONを表示） --%>
			<div class="text-center mb-4 text-muted">
				<p>${menu.description}</p>
			</div>

			<div class="dashed-line"></div>

			<div class="row justify-content-center mb-5">
				<div class="col-10">
					<%-- クーポン画面へ遷移する想定 --%>
					<a href="${pageContext.request.contextPath}/user/main/Us_Discount.jsp" class="btn coupon-btn shadow-sm text-center text-decoration-none d-block">
						クーポンを表示する
					</a>
				</div>
			</div>
			<div style="height: 50px;"></div>
		</div>
	</div>

	<%-- 下部固定ナビゲーション --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center">ホーム</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center">検索</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center">料理提案</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center">
			<div>店舗</div>
			<div class="mt-1 mx-auto" style="background-color: #ffff00; height: 5px; width: 80%;"></div>
		</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center">アカウント</a>
	</nav>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />