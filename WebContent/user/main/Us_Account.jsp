<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="アカウント" scope="request" />

<c:set var="pageBody" scope="request">
	<style>
	 /* ★ページの余白（白い部分）をこの背景色にする */
    	body {
      		background: rgb(238, 237, 234) !important;
    	}
		.page-header { background-color: #ead1dc !important; }
		.account-link-box { display: flex; align-items: center; justify-content: center; height: 150px; background-color: #ffffff; border: 1px solid #333; color: #333; font-size: 1.5rem; text-decoration: none; transition: background-color 0.2s; }
		.account-link-box:hover { background-color: #f0f0f0; color: #333; }

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
	   class="text-dark text-decoration-none text-center bar-account active"
	   style="min-width: 60px;">アカウント</a>

	</nav>

</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />