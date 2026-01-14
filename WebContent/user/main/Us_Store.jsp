<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="店舗一覧" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<%-- ★この画面専用のスタイル --%>
	<style>
		/* ヘッダー色を黄色に上書き */
		.page-header {
			background-color: #ffff00 !important;
		}

		/* 店舗ボタンのスタイル */
		.store-box {
			display: flex;
			align-items: flex-end; /* 文字を下寄りに配置 */
			justify-content: center;
			height: 150px;
			width: 100%;
			border: 1px solid #000; /* 黒い枠線 */
			color: #333;
			font-size: 1.2rem;
			text-decoration: none;
			padding-bottom: 20px;
			transition: opacity 0.2s;
		}
		.store-box:hover {
			opacity: 0.8;
			color: #333;
		}
		/* 背景色の指定 */
		.bg-blue { background-color: #9fc5e8; }
		.bg-white { background-color: #ffffff; }
	</style>

	<div class="container py-3" style="max-width: 500px;">

		<%-- 上部の検索リンク --%>
		<div class="text-center mb-3">
			<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-decoration-none text-secondary">
				<i class="fas fa-search me-1"></i> 店舗内検索
			</a>
		</div>

		<%-- 店舗グリッドエリア --%>
		<div class="row g-0 border border-dark"> <%-- g-0で隙間をなくす --%>

			<%-- OO店（水色） --%>
			<div class="col-6">
				<%-- ★リンク修正：Us_Discount.jspへ遷移（店舗名をパラメータで渡す） --%>
				<a href="${pageContext.request.contextPath}/user/main/Us_Discount.jsp?storeName=OO店" class="store-box bg-blue">
					OO店
				</a>
			</div>

			<%-- II店（白） --%>
			<div class="col-6">
				<%-- ★リンク修正 --%>
				<a href="${pageContext.request.contextPath}/user/main/Us_Discount.jsp?storeName=II店" class="store-box bg-white" style="border-left: 1px solid #000;">
					II店
				</a>
			</div>

			<%-- KK店（白） --%>
			<div class="col-6">
				<%-- ★リンク修正 --%>
				<a href="${pageContext.request.contextPath}/user/main/Us_Discount.jsp?storeName=KK店" class="store-box bg-white" style="border-top: 1px solid #000;">
					KK店
				</a>
			</div>

			<%-- BB店（白） --%>
			<div class="col-6">
				<%-- ★リンク修正 --%>
				<a href="${pageContext.request.contextPath}/user/main/Us_Discount.jsp?storeName=BB店" class="store-box bg-white" style="border-top: 1px solid #000; border-left: 1px solid #000;">
					BB店
				</a>
			</div>
		</div>

	</div>

	<%-- 下部固定ナビゲーション --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
		<a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">検索</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>

		<%-- ★現在地：店舗 --%>
		<a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
			<div>店舗</div>
			<div class="mt-1 mx-auto" style="background-color: #ffff00; height: 5px; width: 80%;"></div>
		</a>

		<a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
	</nav>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />