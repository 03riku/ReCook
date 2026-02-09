<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- JSTLライブラリの読み込み --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle} | Re.Cook</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* ページ全体の基本設定 */
        body {
            margin: 0;
            padding: 0;
            overflow-x: hidden; /* 横スクロールを禁止 */
            font-family: sans-serif;
            background-color: #f8f9fa;
        }

        /* サイドバー（メニュー）の固定スタイル */
        .sidebar {
            width: 200px;
            height: 100vh;
            position: fixed; /* 画面左側に固定 */
            top: 0;
            left: 0;
            z-index: 1000;
        }

        /* メインコンテンツエリア（サイドバーの右側） */
        .main-content {
            margin-left: 200px; /* サイドバーの幅分だけ右にずらす */
            padding: 0;
            display: flex;
            flex-direction: column;
            height: 100vh;
        }

        /* ヘッダーエリア（タイトル表示部） */
        .header-content {
            padding: 10px 20px;
            border-bottom: 2px solid #dee2e6; /* 下線 */
            background-color: white;
            height: 70px;
            display: flex;
            align-items: center;     /* 垂直方向中央揃え */
            justify-content: center; /* 水平方向中央揃え */
        }

        /* コンテンツエリアの分割コンテナ */
        .content-body-split {
            flex-grow: 1; /* 残りの高さを全て使用 */
            display: flex;
            width: 100%;
            overflow: hidden;
        }

        /* 左側のカラム（例：一覧表示用）幅30% */
        .content-col-2 {
            width: 30%;
            padding: 20px;
            border-right: 2px solid #dee2e6; /* 右側の境界線 */
            overflow-y: auto; /* 内容が多い場合はスクロール */
            background-color: #f8f9fa;
        }

        /* 右側のカラム（例：詳細表示・編集用）幅70% */
        .content-col-3 {
            width: 70%;
            padding: 20px;
            overflow-y: auto; /* 内容が多い場合はスクロール */
            background-color: white;
        }
    </style>
</head>
<body>

    <c:import url="/admin/Ad_menu.jsp" />

    <div class="main-content">

        <div class="header-content">
            <h5 class="mb-0 text-dark">${pageTitle}</h5>
        </div>

        <div class="content-body-split">
            <div class="content-col-2">
                <c:out value="${pageContentBody1}" escapeXml="false" />
            </div>

            <div class="content-col-3">
                <c:out value="${pageContentBody2}" escapeXml="false" />
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>