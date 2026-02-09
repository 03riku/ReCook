<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ログイン - Re.Cook</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* ページ全体のレイアウト設定 */
        body {
            background: rgb(238, 237, 234); /* 背景色 */
            height: 100vh;
            display: flex;       /* Flexboxを使用して中央揃えにする */
            justify-content: center;
            align-items: center;
            padding: 0;
            margin: 0;
            overflow: hidden;    /* スクロールバーを非表示にする */
        }

        /* ログイン画面全体のラッパー */
        .login-wrapper {
            text-align: center;
            position: relative;
            top: -90px; /* 画面の少し上に配置 */
        }

        /* ロゴ画像のスタイル設定 */
        .logo-img {
            width: 380px;
            display: block;
            margin: 0 auto -80px auto; /* 下のマージンをネガティブにしてカードと重ねる */
            object-fit: cover;
            padding: 0;
        }

        /* ログインフォームのカードデザイン */
        .login-card {
            background: #ffffff;
            border-radius: 14px; /* 角を丸くする */
            padding: 32px;
            width: 380px;
            box-shadow: 0px 6px 25px rgba(0,0,0,0.08); /* 影をつけて立体感を出す */
            position: relative;
            top: -40px;
        }

        /* 「ログイン」タイトルのスタイル */
        .login-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 22px;
        }

        /* ログインボタンのカスタムスタイル */
        .btn-login {
            background: #000;
            color: #fff;
            width: 100%;
            padding: 10px;
            font-size: 15px;
        }
    </style>
</head>
<body>

<div class="login-wrapper">

    <img src="${pageContext.request.contextPath}/pic/recook_logo.png" class="logo-img" alt="Re.Cook ロゴ">

    <div class="login-card">
        <div class="login-title">ログイン</div>

        <%-- Javaのエラーハンドリング処理 --%>
        <%
            // リクエストパラメータからエラーコードを取得
            String errorParam = request.getParameter("error");
            String errorMsg = null;

            // エラーコードに応じたメッセージを設定
            if ("invalid".equals(errorParam)) {
                // IDまたはパスワードが間違っている場合
                errorMsg = "IDもしくはパスワードが正しくありません";
            } else if ("notnumber".equals(errorParam)) {
                // IDが数字でない場合
                errorMsg = "IDは数字で入力してください";
            } else if ("emptyfields".equals(errorParam)) {
                // 入力項目が空の場合
                errorMsg = "ユーザーIDとパスワードを入力してください";
            }

            // エラーメッセージが存在する場合のみアラートを表示
            if (errorMsg != null) {
        %>
            <div class="alert alert-danger mb-3" role="alert">
                <%= errorMsg %>
            </div>
        <%
            }
        %>

        <form action="${pageContext.request.contextPath}/Ad_LoginServlet" method="post">
            <div class="mb-3">
                <input type="text" class="form-control" name="username" placeholder="ユーザーID" required>
            </div>
            <div class="mb-3">
                <input type="password" class="form-control" name="password" placeholder="パスワード" required>
            </div>
            <button type="submit" class="btn btn-login">ログイン</button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>