<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="ホーム" scope="request" />

<c:set var="pageBody" scope="request">
	<style>
		/* ★ページの余白（白い部分）をこの背景色にする */
		html, body {
			background: rgb(238, 237, 234) !important;
			min-height: 100%;
		}
	</style>
	<div class="container text-center py-5" style="max-width: 500px;">

		<%-- ロゴ画像エリア --%>
		<div class="py-5 mb-5 border rounded" style="background-color: #f7f7f7;">
			<img src="${pageContext.request.contextPath}/pic/recook_logo.png"
				 alt="Re.Cook Logo"
				 class="img-fluid"
				 style="max-height: 100px; max-width: 90%;">
		</div>

		<%-- 4つのメニューボタン --%>
		<div class="row g-3">
			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center" style="background-color: #c9daf8;">
						<h3 class="mb-0 text-dark">検索</h3>
					</div>
				</a>
			</div>

			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center" style="background-color: #d9ead3;">
						<h3 class="mb-0 text-dark">料理提案</h3>
					</div>
				</a>
			</div>

			<%-- ★修正：店舗ボタン (Servletを通す) --%>
			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/StoreList" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center" style="background-color: #fff2cc;">
						<h3 class="mb-0 text-dark">店舗</h3>
					</div>
				</a>
			</div>

			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center" style="background-color: #ead1dc;">
						<h3 class="mb-0 text-dark">アカウント</h3>
					</div>
				</a>
			</div>
		</div>
	</div>

	<%-- 下部固定ナビゲーション --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
			<div>ホーム</div>
			<div class="mt-1 mx-auto" style="background-color: #ffe5d9; height: 5px; width: 70%;"></div>
		</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>

		<%-- ★修正：店舗リンク (Servletを通す) --%>
		<a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
	</nav>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />