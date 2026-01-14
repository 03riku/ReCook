<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- ■設定エリア：タイトルと画面の中身をrequestスコープに保存 --%>
<c:set var="pageTitle" value="ホーム" scope="request" />

<c:set var="pageBody" scope="request">
	<div class="container text-center py-5" style="max-width: 500px;">

		<%-- ロゴ画像エリア --%>
		<div class="py-5 mb-5 border rounded" style="background-color: #f7f7f7;">
			<%-- 画像パス：WebContent/pic/recook_logo.png を参照 --%>
			<img src="${pageContext.request.contextPath}/pic/recook_logo.png"
				 alt="Re.Cook Logo"
				 class="img-fluid"
				 style="max-height: 100px; max-width: 90%;">
		</div>

		<%-- 4つのメニューボタン --%>
		<div class="row g-3">
			<%-- 検索 --%>
			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center" style="background-color: #c9daf8;">
						<h3 class="mb-0 text-dark">検索</h3>
					</div>
				</a>
			</div>

			<%-- 料理提案 --%>
			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center" style="background-color: #d9ead3;">
						<h3 class="mb-0 text-dark">料理提案</h3>
					</div>
				</a>
			</div>

			<%-- 店舗 (Us_Store.jsp) --%>
			<div class="col-6">
				<a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="d-block text-decoration-none">
					<div class="p-4 rounded shadow-sm h-100 d-flex align-items-center justify-content-center" style="background-color: #fff2cc;">
						<h3 class="mb-0 text-dark">店舗</h3>
					</div>
				</a>
			</div>

			<%-- アカウント (Us_Account.jsp) --%>
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
		<%-- ホーム（現在地） --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
			<div>ホーム</div>
			<div class="mt-1 mx-auto" style="background-color: #c9daf8; height: 5px; width: 70%;"></div>
		</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
	</nav>
</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />