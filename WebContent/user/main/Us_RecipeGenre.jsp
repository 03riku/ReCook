<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="料理提案" scope="request" />

<c:set var="pageBody" scope="request">
	<style> .page-header { background-color: #d9ead3 !important; }

			/* ★ページの余白（白い部分）をこの背景色にする */
    	body {
      		background: rgb(238, 237, 234) !important;
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
        .bottom-nav a.bar-home    { --bar-color:#ffe5d9; } /* ホーム：薄いピンク */
        .bottom-nav a.bar-search  { --bar-color:#c9daf8; } /* 検索：青 */
        .bottom-nav a.bar-recipe  { --bar-color:#d9ead3; } /* 料理提案：緑 */
        .bottom-nav a.bar-store   { --bar-color:#fff2cc; } /* 店舗：黄 */
        .bottom-nav a.bar-account { --bar-color:#ead1dc; } /* アカウント：ピンク */
        }
	</style>

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
	
	<!-- 下部固定ナビゲーション -->
<nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
  
  <!-- ホーム -->
  <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp"
     class="text-dark text-decoration-none text-center bar-home"
     style="min-width: 60px;">ホーム</a>

  <!-- 検索 -->
  <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp"
     class="text-dark text-decoration-none text-center bar-search"
     style="min-width: 60px;">検索</a>

  <!-- 料理提案 -->
  <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp"
     class="text-dark text-decoration-none text-center bar-recipe"
     style="min-width: 60px;">料理提案</a>

  <!-- 店舗（★必ずサーブレットのURLを指定します） -->
  <a href="${pageContext.request.contextPath}/user/StoreList"
     class="text-dark text-decoration-none text-center bar-store"
     style="min-width: 60px;">店舗</a>

  <!-- アカウント -->
  <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp"
     class="text-dark text-decoration-none text-center bar-account"
     style="min-width: 60px;">アカウント</a>
     
     </nav>

</c:set>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />