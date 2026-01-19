<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- サーブレットから渡されたタイトル（検索結果、ジャンル名、店舗名など）を表示 --%>
<c:set var="pageTitle" value="${pageTitle}" scope="request" />

<%-- 画面の中身を設定 --%>
<c:set var="pageBody" scope="request">

    <style>
        /* ★ページの余白（白い部分）をこの背景色にする */
        body {
            background: rgb(238, 237, 234) !important;
        }

        /* ヘッダーの色（料理リスト共通のグリーン系） */
        .page-header { background-color: #d9ead3 !important; }

        /* レシピリスト全体のスタイル（黒枠） */
        .recipe-item {
            border: 2px solid #000;
            border-radius: 10px;
            padding: 12px 0;
            margin: 10px 0;
            background: #fff;
            transition: background-color 0.2s;
        }
        .recipe-link:hover .recipe-item {
            background-color: #f8f9fa;
        }

        /* リンクの装飾を消す */
        .recipe-link {
            text-decoration: none;
            color: #333;
            display: block;
        }

        /* 画像を表示するエリアのプレースホルダー */
        .recipe-img-placeholder {
            width: 100%;
            height: 100px;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #adb5bd;
        }

        /* 説明文が長い場合に2行で省略する設定 */
        .text-truncate-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            font-size: 0.85rem;
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
            transform: translateX(-50%) scaleX(1);
        }

        /* ====== 色分け（好きに変更OK） ====== */
        .bottom-nav a.bar-home    { --bar-color:#ffe5d9; } /* ホーム：ピンク */
        .bottom-nav a.bar-search  { --bar-color:#c9daf8; } /* 検索：青 */
        .bottom-nav a.bar-recipe  { --bar-color:#d9ead3; } /* 料理提案：緑 */
        .bottom-nav a.bar-store   { --bar-color:#fff2cc; } /* 店舗：黄 */
        .bottom-nav a.bar-account { --bar-color:#ead1dc; } /* アカウント：ピンク */
    </style>

    <div class="container py-0" style="max-width: 500px;">

        <%-- サブヘッダー：現在のカテゴリと件数 --%>
        <div class="text-center py-2 border-bottom border-dark mb-2">
            <h5 class="mb-0">${pageTitle} ： ${menuList.size()} 件</h5>
        </div>

        <%-- 料理リストループ開始 --%>
        <div class="px-2">
            <c:forEach var="item" items="${menuList}">
                <a href="${pageContext.request.contextPath}/user/MenuDetail?id=${item.menuItemId}&fromStore=${fromStore}" class="recipe-link">
                    <div class="row g-0 recipe-item">
                        <%-- 左側：画像プレースホルダー --%>
                        <div class="col-4 px-2">
                            <div class="recipe-img-placeholder border rounded">
                                <i class="fas fa-utensils fa-2x"></i>
                            </div>
                        </div>
                        <%-- 右側：料理情報 --%>
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

        <%-- リストが空の場合の表示 --%>
        <c:if test="${empty menuList}">
            <div class="py-5 text-center text-muted">
                <i class="fas fa-search fa-3x mb-3"></i>
                <p>該当する料理が見つかりませんでした。</p>
                <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="btn btn-outline-secondary btn-sm mt-2">ホームへ戻る</a>
            </div>
        </c:if>

        <div style="height: 100px;"></div> <%-- 下部ナビとの余白 --%>
    </div>

    <%-- 下部固定ナビゲーション（★bottom-nav追加 + 色分けクラス追加） --%>
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

        <%-- 店舗リンクは常にサーブレットを通す --%>
        <a href="${pageContext.request.contextPath}/user/StoreList"
           class="text-dark text-decoration-none text-center bar-store"
           style="min-width: 60px;">店舗</a>

        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp"
           class="text-dark text-decoration-none text-center bar-account"
           style="min-width: 60px;">アカウント</a>
    </nav>

</c:set>

<%-- レイアウト枠を読み込み --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />
