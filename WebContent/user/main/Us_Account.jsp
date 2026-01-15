<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="アカウント" scope="request" />

<c:set var="pageBody" scope="request">
	<style>
		.page-header { background-color: #ead1dc !important; }
		.account-link-box { display: flex; align-items: center; justify-content: center; height: 150px; background-color: #ffffff; border: 1px solid #333; color: #333; font-size: 1.5rem; text-decoration: none; transition: background-color 0.2s; }
		.account-link-box:hover { background-color: #f0f0f0; color: #333; }
	</style>

	<div class="container py-5" style="max-width: 500px;">
		<div class="row g-4">
			<div class="col-12">
				<a href="${pageContext.request.contextPath}/user/User_FavoriteList" class="account-link-box shadow-sm rounded">お気に入りメニュー</a>
			</div>
			<div class="col-12">
				<a href="${pageContext.request.contextPath}/user/main/Us_Logout.jsp" class="account-link-box shadow-sm rounded">ログアウト</a>
			</div>
		</div>
	</div>

	<%-- 下部固定ナビゲーション --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>

		<%-- ★修正：店舗リンク (Servletを通す) --%>
		<a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
			<div>アカウント</div>
			<div class="mt-1 mx-auto" style="background-color: #ead1dc; height: 5px; width: 80%;"></div>
		</a>
	</nav>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />