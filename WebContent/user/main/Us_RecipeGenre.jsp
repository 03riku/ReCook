<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="料理提案" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<%-- ヘッダーを緑色にする設定 --%>
	<style>
		.page-header {
			background-color: #d9ead3 !important;
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

		<%-- 4つのカテゴリーボタンエリア --%>
		<div class="row g-3">
			<div class="col-6">
				<%-- ★リンク修正：Us_Recipes.jspへ遷移 (?genre=japanese) --%>
				<a href="${pageContext.request.contextPath}/user/main/Us_Recipes.jsp?genre=japanese" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center border border-dark" style="background-color: #cccccc;">
						<h3 class="mb-0 text-dark">和食</h3>
					</div>
				</a>
			</div>

			<div class="col-6">
				<%-- ★リンク修正：Us_Recipes.jspへ遷移 (?genre=western) --%>
				<a href="${pageContext.request.contextPath}/user/main/Us_Recipes.jsp?genre=western" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center border border-dark" style="background-color: #9fc5e8;">
						<h3 class="mb-0 text-dark">洋食</h3>
					</div>
				</a>
			</div>

			<div class="col-6">
				<%-- ★リンク修正：Us_Recipes.jspへ遷移 (?genre=budget) --%>
				<a href="${pageContext.request.contextPath}/user/main/Us_Recipes.jsp?genre=budget" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center border border-dark" style="background-color: #b6d7a8;">
						<h3 class="mb-0 text-dark">節約飯</h3>
					</div>
				</a>
			</div>

			<div class="col-6">
				<%-- ★リンク修正：Us_Recipes.jspへ遷移 (?genre=manmeshi) --%>
				<a href="${pageContext.request.contextPath}/user/main/Us_Recipes.jsp?genre=manmeshi" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center border border-dark" style="background-color: #ea9999;">
						<h3 class="mb-0 text-dark">漢メシ</h3>
					</div>
				</a>
			</div>
		</div>
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