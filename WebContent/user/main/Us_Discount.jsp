<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- タイトル設定 --%>
<c:set var="pageTitle" value="お得情報・クーポン" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

	<style>
		/* ★ページの余白（白い部分）をこの背景色にする */
    	body {
      		background: rgb(238, 237, 234) !important;
    	}

		/* ヘッダー色（お得情報なので少し明るい黄色系） */
		.page-header {
			background-color: #fff2cc !important;
		}

		/* クーポンカードのスタイル */
		.coupon-card {
			border: 2px dashed #f44336;
			background-color: #fff5f5;
			border-radius: 10px;
			position: relative;
			overflow: hidden;
		}
		.coupon-card::before, .coupon-card::after {
			content: "";
			position: absolute;
			top: 50%;
			width: 20px;
			height: 20px;
			background-color: #fff; /* 背景色と同じにして切り取り線風にする */
			border-radius: 50%;
			transform: translateY(-50%);
		}
		.coupon-card::before { left: -10px; }
		.coupon-card::after { right: -10px; }

		/* 商品セールのバッジ */
		.sale-badge {
			background-color: #f44336;
			color: white;
			padding: 2px 8px;
			border-radius: 5px;
			font-size: 0.8rem;
			font-weight: bold;
		}

		/* 商品画像ダミー */
		.product-img {
			width: 60px;
			height: 60px;
			background-color: #eee;
			display: flex;
			align-items: center;
			justify-content: center;
			border-radius: 5px;
		}

		/* =========================
           ★下部固定ナビ：ホバーで下に色バー（色分け対応）
           ========================= */
        .bottom-nav a{
            position: relative;
            padding-bottom: 10px; /* バー分 */
        }

        /* バー本体（色は --bar-color で決まる） */
        .bottom-nav a::after{
            content: "";
            position: absolute;
            left: 50%;
            bottom: 2px;
            width: 70%;
            height: 5px;
            background-color: var(--bar-color, #c9daf8); /* デフォルト */
            transform: translateX(-50%) scaleX(0);
            transform-origin: center;
            border-radius: 2px;
            transition: transform 0.15s ease;
        }

        /* ホバーで表示 */
        .bottom-nav a:hover::after{
            transform: translateX(-50%) scaleX(1);
        }

        /* 今いるページは常に表示（使うならactive付ける） */
        .bottom-nav a.active::after{
            transform: translateX(-50%) scaleX(1) !important;
        }

        /* ====== 色分け（好きに変更OK） ====== */
        .bottom-nav a.bar-home    { --bar-color:#ffe5d9; } /* ホーム：ピンク */
        .bottom-nav a.bar-search  { --bar-color:#c9daf8; } /* 検索：青 */
        .bottom-nav a.bar-recipe  { --bar-color:#d9ead3; } /* 料理提案：緑 */
        .bottom-nav a.bar-store   { --bar-color:#fff2cc; } /* 店舗：黄 */
        .bottom-nav a.bar-account { --bar-color:#ead1dc; } /* アカウント：ピンク */
        }

	</style>

	<div class="container py-4 px-3" style="max-width: 500px; padding-bottom: 100px !important;">

		<%-- ■ セクション1：利用可能なクーポン --%>
		<h6 class="fw-bold mb-3"><i class="fas fa-ticket-alt text-danger"></i> 利用可能なクーポン</h6>

		<div class="coupon-card p-3 mb-4 shadow-sm">
			<div class="row align-items-center">
				<div class="col-8">
					<div class="small text-muted">Re.Cook 利用特典</div>
					<div class="fw-bold text-danger fs-5">全品 10% OFF</div>
					<div class="small text-muted">有効期限：2024/12/31</div>
				</div>
				<div class="col-4 text-end">
					<button class="btn btn-sm btn-danger rounded-pill px-3">使用中</button>
				</div>
			</div>
		</div>

		<%-- ■ セクション2：本日のセール商品（DISCOUNTED_PRODUCT想定） --%>
		<h6 class="fw-bold mb-3"><i class="fas fa-shopping-cart text-primary"></i> 本日の特売品</h6>

		<div class="card shadow-sm border-0 mb-3">
			<div class="card-body p-0">
				<ul class="list-group list-group-flush">
					<%-- ここは本来 c:forEach で回す部分 --%>
					<li class="list-group-item d-flex align-items-center py-3">
						<div class="product-img me-3">
							<i class="fas fa-drumstick-bite text-muted"></i>
						</div>
						<div class="flex-grow-1">
							<div class="fw-bold">国産若鶏もも肉</div>
							<div class="text-danger fw-bold">100g / ¥98 <span class="sale-badge">20%OFF</span></div>
						</div>
					</li>
					<li class="list-group-item d-flex align-items-center py-3">
						<div class="product-img me-3">
							<i class="fas fa-leaf text-muted"></i>
						</div>
						<div class="flex-grow-1">
							<div class="fw-bold">北海道産たまねぎ</div>
							<div class="text-danger fw-bold">3玉 / ¥158 <span class="sale-badge">SALE</span></div>
						</div>
					</li>
					<li class="list-group-item d-flex align-items-center py-3">
						<div class="product-img me-3">
							<i class="fas fa-egg text-muted"></i>
						</div>
						<div class="flex-grow-1">
							<div class="fw-bold">特選たまご（10個入）</div>
							<div class="text-danger fw-bold">¥198 <span class="sale-badge">目玉商品</span></div>
						</div>
					</li>
				</ul>
			</div>
		</div>

		<%-- 注意書き --%>
		<div class="alert alert-light border small text-muted">
			※セールの内容は店舗によって異なる場合があります。<br>
			※クーポンは会計時に画面をご提示ください。
		</div>

	</div>

	<%-- 下部固定ナビゲーション --%>
	<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
	  <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp"
	     class="text-dark text-decoration-none text-center bar-home"
	     style="min-width: 60px;">ホーム</a>

	  <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp"
	     class="text-dark text-decoration-none text-center bar-search"
	     style="min-width: 60px;">検索</a>

	  <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp"
	     class="text-dark text-decoration-none text-center bar-recipe"
	     style="min-width: 60px;">料理提案</a>

	  <a href="${pageContext.request.contextPath}/user/StoreList"
	     class="text-dark text-decoration-none text-center bar-store"
	     style="min-width: 60px;">店舗</a>

	  <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp"
	   class="text-dark text-decoration-none text-center bar-account"
	   style="min-width: 60px;">アカウント</a>

	</nav>

</c:set>

<%-- base.jspを呼び出し --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />