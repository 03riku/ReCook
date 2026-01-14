<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- パラメータ受け取り --%>
<c:set var="recipeName" value="${param.recipeName}" />
<c:if test="${empty recipeName}">
	<c:set var="recipeName" value="簡単！ビーフシチュー" />
</c:if>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="料理メニュー" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<%-- ★この画面専用のスタイル --%>
	<style>
		/* ヘッダー色 */
		.page-header {
			background-color: #ead1dc !important;
		}

		/* お気に入り登録ボタン */
		.fav-btn {
			border: 1px solid #333;
			background-color: #fff;
			padding: 5px 10px;
			font-size: 0.9rem;
			text-decoration: none;
			color: #333;
			display: inline-block;
			white-space: nowrap;
			transition: background-color 0.2s;
			cursor: pointer;
		}
		.fav-btn:hover {
			background-color: #f0f0f0;
			color: #333;
		}

		/* 点線区切り線 */
		.dashed-line {
			border-top: 2px dashed #999;
			margin: 20px 0;
		}

		/* 商品説明の見出し枠 */
		.desc-header {
			border-top: 1px solid #333;
			border-bottom: 1px solid #333;
			padding: 5px;
			text-align: center;
			font-weight: bold;
			margin-bottom: 15px;
		}

		/* クーポンボタン */
		.coupon-btn {
			background-color: #ffff00; /* 黄色 */
			border: 2px solid #333;
			color: #333;
			font-weight: bold;
			padding: 15px;
			width: 100%;
			font-size: 1.1rem;
			transition: opacity 0.2s;
		}
		.coupon-btn:hover {
			opacity: 0.8;
		}
	</style>

	<%-- お気に入り機能用JavaScript --%>
	<script>
		function toggleFavorite(element) {
			const icon = element.querySelector('i');

			// アイコンが白抜き(far)か塗りつぶし(fas)かで判定
			if (icon.classList.contains('far')) {
				// 登録処理
				icon.classList.remove('far');
				icon.classList.add('fas'); // 塗りつぶし星にする
				icon.style.color = '#ffc107'; // 金色にする
				alert('「' + '${recipeName}' + '」をお気に入りに登録しました！\n（アカウント画面のお気に入りメニューから確認できます）');
				// テキスト変更（アイコンは維持）
				element.innerHTML = '<i class="fas fa-star" style="color: #ffc107;"></i> 登録済み';
			} else {
				// 解除処理
				icon.classList.remove('fas');
				icon.classList.add('far');
				icon.style.color = ''; // 色を戻す
				alert('お気に入りを解除しました。');
				element.innerHTML = '<i class="far fa-star"></i> お気に入り登録';
			}
		}
	</script>

	<div class="container py-0 px-0" style="max-width: 500px;">

		<%-- ■■■ 上部：料理情報 ■■■ --%>

		<%-- 料理画像エリア --%>
		<div class="bg-light d-flex align-items-center justify-content-center border-bottom border-dark" style="height: 220px; width: 100%;">
			<div class="text-center text-muted">
				<i class="fas fa-utensils fa-4x mb-2"></i><br>
				料理画像
			</div>
		</div>

		<div class="container px-4 py-3">
			<%-- 料理名 --%>
			<h4 class="fw-bold mb-3">${recipeName}</h4>

			<div class="row align-items-end mb-3">
				<%-- 調理時間 --%>
				<div class="col-6">
					<div class="fw-bold"><i class="far fa-clock"></i> 調理時間</div>
					<div class="ps-3 fs-5">60分</div>
				</div>
				<%-- お気に入り登録ボタン（JS実行） --%>
				<div class="col-6 text-end">
					<a href="javascript:void(0);" onclick="toggleFavorite(this)" class="fav-btn shadow-sm" id="favButton">
						<i class="far fa-star"></i> お気に入り登録
					</a>
				</div>
			</div>

			<%-- 点線 --%>
			<div class="dashed-line"></div>

			<%-- 紹介文 --%>
			<div class="mb-4 text-center">
				<p>
					「${recipeName}」のレシピと<br>
					作り方をご紹介！牛肉のほろほろ感と<br>
					甘じょっぱいソースのコクが幸せを運ぶ！<br>
					暑い日にも寒い日にもオススメの一品
				</p>
			</div>

			<%-- ■■■ 下部：商品説明とクーポン ■■■ --%>

			<%-- 商品説明見出し --%>
			<div class="desc-header mt-5">
				商品説明
			</div>

			<%-- 商品説明本文 --%>
			<div class="text-center mb-4 text-muted">
				<p>～～～～～～～～～～～～～～～～</p>
				<p>～～～～～～～～～～～～～～～～</p>
				<p>～～～～～～～～～～～～～～～～</p>
				<p>～～～～～～～～～～～～～～～～</p>
				<p>～～～～～～～～～～～～～～～～</p>
			</div>

			<%-- 点線 --%>
			<div class="dashed-line"></div>

			<%-- クーポン注意事項（赤字） --%>
			<div class="text-center text-danger fw-bold mb-4">
				※クーポンの利用はレシピに使う商品<br>
				全ての購入が確認できないと使用できません
			</div>

			<%-- クーポンを表示するボタン --%>
			<div class="row justify-content-center mb-5">
				<div class="col-10">
					<button type="button" class="btn coupon-btn shadow-sm" onclick="alert('クーポンが表示されました（仮）')">
						クーポンを表示する
					</button>
				</div>
			</div>

			<%-- フッターに被らないよう余白 --%>
			<div style="height: 50px;"></div>

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