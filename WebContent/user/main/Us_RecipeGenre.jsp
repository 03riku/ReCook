<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="料理提案" scope="request" />

<c:set var="pageBody" scope="request">
	<style> .page-header { background-color: #d9ead3 !important; } </style>

	<div class="container text-center py-5" style="max-width: 500px;">
		<div class="py-5 mb-5 border rounded" style="background-color: #f7f7f7;">
			<img src="${pageContext.request.contextPath}/pic/recook_logo.png" alt="Re.Cook Logo" class="img-fluid" style="max-height: 100px; max-width: 90%;">
		</div>

		<div class="row g-3">
			<%-- 和食 (GENRE_ID: 1) --%>
			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=1&genreName=和食" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center border border-dark" style="background-color: #cccccc;">
						<h3 class="mb-0 text-dark">和食</h3>
					</div>
				</a>
			</div>

			<%-- 洋食 (GENRE_ID: 2) --%>
			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=2&genreName=洋食" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center border border-dark" style="background-color: #9fc5e8;">
						<h3 class="mb-0 text-dark">洋食</h3>
					</div>
				</a>
			</div>

			<%-- 漢メシ (GENRE_ID: 3) --%>
			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=3&genreName=漢メシ" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center border border-dark" style="background-color: #ea9999;">
						<h3 class="mb-0 text-dark">漢メシ</h3>
					</div>
				</a>
			</div>

			<%-- 節約飯 (GENRE_ID: 4) --%>
			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/GenreRecipes?genreId=4&genreName=節約飯" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center border border-dark" style="background-color: #b6d7a8;">
						<h3 class="mb-0 text-dark">節約飯</h3>
					</div>
				</a>
			</div>
		</div>
	</div>

	<%-- 下部固定ナビゲーション --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>
		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
		<div>料理提案</div>
			<div class="mt-1 mx-auto" style="background-color: #d9ead3; height: 5px; width: 70%;"></div>
			</a>
		<%-- ★修正：店舗リンク (Servletを通す) --%>
		<a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
	</nav>
</c:set>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />