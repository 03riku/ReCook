<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 文字化け防止の設定 --%>
<% request.setCharacterEncoding("UTF-8"); %>

<%-- 1. ページタイトルの設定：サーブレット（Java）から送られてきたタイトルを表示 --%>
<c:set var="pageTitle" value="${pageTitle}" scope="request" />

<%-- 2. ページの中身（pageBody）の開始 --%>
<c:set var="pageBody" scope="request">
    <style>
        /* --- デザイン（CSS）の設定 --- */
        body { background: rgb(238, 237, 234) !important; } /* 全体の背景色 */
        .page-header { background-color: #d9ead3 !important; } /* 料理提案系のテーマカラー（緑） */

        /* ヘッダーバー：戻るボタンとタイトルの固定表示設定 */
        .header-bar {
            display: flex; align-items: center; padding: 10px;
            background: #fff; border-bottom: 1px solid #ddd;
            position: sticky; top: 0; z-index: 1020;
        }
        .back-btn { font-size: 1.5rem; color: #333; text-decoration: none; margin-right: 15px; }

        /* 料理カード（1項目分）の枠のデザイン */
        .recipe-item {
            border: 2px solid #000;      /* 黒い太枠 */
            border-radius: 10px;         /* カドを丸く */
            padding: 12px 0;
            margin: 10px 0;
            background: #fff;            /* カードの中は白 */
            transition: background-color 0.2s;
        }
        .recipe-item:hover { background-color: #f8f9fa; } /* 触れた時に少し色を変える */
        .recipe-link { text-decoration: none; color: #333; display: block; }

        /* 画像を表示する四角いエリアの設定 */
        .recipe-img-box {
            width: 100%;
            height: 100px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border-radius: 5px;
        }
        .recipe-img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* 枠に合わせて画像を綺麗に収める */
        }

        /* 説明文が長すぎる場合に2行で省略する設定 */
        .text-truncate-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            font-size: 0.85rem;
        }

        /* 下部メニューの装飾設定（ホバーで線が出るアニメーション） */
        .bottom-nav a { position: relative; padding-bottom: 10px; }
        .bottom-nav a::after {
            content: ""; position: absolute; left: 50%; bottom: 2px;
            width: 70%; height: 5px; background-color: var(--bar-color, #c9daf8);
            transform: translateX(-50%) scaleX(0); transform-origin: center;
            border-radius: 2px; transition: transform 0.15s ease;
        }
        .bottom-nav a:hover::after,
        .bottom-nav a.active::after { transform: translateX(-50%) scaleX(1) !important; }

        /* ナビゲーションの各メニューの色分け */
        .bottom-nav a.bar-home    { --bar-color:#ffe5d9; }
        .bottom-nav a.bar-search  { --bar-color:#c9daf8; }
        .bottom-nav a.bar-recipe  { --bar-color:#d9ead3; }
        .bottom-nav a.bar-store   { --bar-color:#fff2cc; }
        .bottom-nav a.bar-account { --bar-color:#ead1dc; }
    </style>

    <%-- 3. 画面上部：戻るボタンと、タイトル＋件数の表示 --%>
    <div class="header-bar">
        <a href="javascript:history.back();" class="back-btn"><i class="fas fa-chevron-left"></i></a>
        <h5 class="mb-0 fw-bold">${pageTitle} (${menuList.size()}件)</h5>
    </div>

    <%-- 4. 料理リストの表示エリア --%>
    <div class="container py-2" style="max-width: 500px;">
        <div class="px-2">
            <%-- Javaから届いた「menuList」を1つずつ取り出して「item」としてループ処理 --%>
            <c:forEach var="item" items="${menuList}">
                <%-- 詳細画面（User_MenuDetailServlet）へのリンク --%>
                <a href="${pageContext.request.contextPath}/user/MenuDetail?id=${item.menuItemId}&fromStore=${fromStore}" class="recipe-link">
                    <div class="row g-0 recipe-item shadow-sm">

                        <%-- 左側：料理画像部分 --%>
                        <div class="col-4 px-2">
                            <div class="recipe-img-box border">
                                <c:choose>
                                    <%-- 画像データがある場合は画像を表示 --%>
                                    <c:when test="${not empty item.image}">
                                        <img src="${pageContext.request.contextPath}/pic/${item.image}" alt="${item.dishName}">
                                    </c:when>
                                    <%-- 画像がない場合はフォークとナイフのアイコンを表示 --%>
                                    <c:otherwise>
                                        <i class="fas fa-utensils fa-2x text-muted"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <%-- 右側：料理の情報（名前、時間、説明文） --%>
                        <div class="col-8 px-2 text-start">
                            <div class="fw-bold mb-1">${item.dishName}</div>
                            <div class="text-muted small mb-1">
                                <i class="far fa-clock"></i> 調理時間 ${item.cookTime}分
                            </div>
                            <div class="text-secondary text-truncate-2">
                                ${item.description}
                            </div>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>

        <%-- 5. もしリストが空っぽだった場合の表示 --%>
        <c:if test="${empty menuList}">
            <div class="py-5 text-center text-muted">
                <i class="fas fa-search fa-3x mb-3"></i>
                <p>該当する料理が見つかりませんでした。</p>
            </div>
        </c:if>

        <%-- ナビに隠れないように下に余白を作る --%>
        <div style="height: 100px;"></div>
    </div>

    <%-- 6. 下部固定ナビゲーション：画面下部のメニュー --%>
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center bar-home" style="min-width: 60px;">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center bar-search active" style="min-width: 60px;">検索</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center bar-recipe" style="min-width: 60px;">料理提案</a>
        <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center bar-store" style="min-width: 60px;">店舗</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center bar-account" style="min-width: 60px;">アカウント</a>
    </nav>
</c:set>

<%-- 土台となる base.jsp に上記の内容を流し込む --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />