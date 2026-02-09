<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
/* サイドバー全体のスタイル設定 */
.sidebar {
	background-color: #f8f9fa !important; /* 背景色：薄いグレー */
	padding: 20px !important;
	height: 100vh; /* 画面の高さいっぱいに表示 */
}

/* ロゴ画像の枠線とコンテナのスタイル */
.logo-container {
	display: inline-block;
	padding: 5px;
	border: 2px solid #dee2e6; /* 枠線の色：薄いグレー */
	border-radius: 12px;       /* 角丸の設定 */
	background-color: white;   /* 背景色：白 */
	transition: all 0.3s ease; /* アニメーションの速度設定 */
	box-shadow: 0 4px 6px rgba(0,0,0,0.05); /* 軽い影をつける */
}

/* ロゴにマウスを乗せた時（ホバー時）のエフェクト */
.logo-container:hover {
	border-color: #6c757d;     /* 枠線の色を濃くする */
	transform: scale(1.05);    /* 5%拡大表示 */
	box-shadow: 0 6px 12px rgba(0,0,0,0.1);
}

/* メニューリンクの基本スタイル */
.menu-link-item {
	text-decoration: none;
	padding: 10px 15px;
	border-radius: 5px;
	transition: background-color 0.15s ease-in-out;
	display: block;
	color: #212529;
}

/* 現在選択されている（アクティブな）メニューのスタイル */
.menu-link-active {
	background-color: #6c757d !important; /* 背景色：濃いグレー */
	color: white !important; /* 文字色：白 */
	font-weight: bold;
}

/* 非アクティブなメニューにマウスを乗せた時のスタイル */
.menu-link-item:not(.menu-link-active):hover {
	background-color: #e9ecef;
	color: #000 !important;
}
</style>

<div class="sidebar bg-light p-3 border-end">
	<h2 class="text-center mb-4">
		<div class="logo-container">
			<img src="${pageContext.request.contextPath}/pic/recook_logo.png" alt="Re.Cook Logo"
				style="max-width: 140px; height: auto; display: block; border-radius: 8px;">
		</div>
	</h2>

	<ul class="list-unstyled p-0 m-0" id="sidebar-menu">
		<li class="mb-2">
			<a href="${pageContext.request.contextPath}/product/Admin_ProductServlet" class="menu-link-item">
				商品
			</a>
		</li>

		<li class="mb-2">
			<a href="${pageContext.request.contextPath}/admin/store/StoreServlet" class="menu-link-item">
				店舗
			</a>
		</li>

		<li class="mb-2">
			<a href="${pageContext.request.contextPath}/admin/recipe/RecipeServlet" class="menu-link-item">
				料理
			</a>
		</li>

		<li class="mt-2">
			<a href="${pageContext.request.contextPath}/admin/account/Ad_logout.jsp" class="menu-link-item">
				ログアウト
			</a>
		</li>
	</ul>
</div>

<script>
    // ページ読み込み完了時に実行される処理
    document.addEventListener("DOMContentLoaded", function() {
        // 現在のURLパスを取得
        const currentPath = window.location.pathname;
        // すべてのメニューリンク要素を取得
        const menuLinks = document.querySelectorAll('#sidebar-menu .menu-link-item');

        // 各リンクに対して、現在のURLと一致するかチェック
        menuLinks.forEach(link => {
            const linkPath = link.getAttribute('href');
            // リンク先が現在のパスに含まれている場合（かつ "#" でない場合）
            if (currentPath.includes(linkPath) && linkPath !== "#") {
                // アクティブクラスを追加（ハイライト表示）
                link.classList.add('menu-link-active');
            } else {
                // アクティブクラスを削除
                link.classList.remove('menu-link-active');
            }
        });

        // 管理画面のトップページなどの場合、デフォルトで最初のメニューをアクティブにする処理
        if (currentPath.endsWith("/admin/") || currentPath.endsWith("/index.jsp")) {
            if(menuLinks.length > 0) menuLinks[0].classList.add('menu-link-active');
        }
    });
</script>