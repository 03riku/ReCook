<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>店舗ログイン - Re.Cook</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: rgb(238, 237, 234);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 0;
            margin: 0;
            overflow: hidden;
        }

        .login-wrapper {
            text-align: center;
            position: relative;
            top: -90px;
        }

        .logo-img {
            width: 380px; /* 指定のサイズ */
            display: block;
            margin: 0 auto -80px auto;
            object-fit: cover;
            padding: 0;
        }

        .login-card {
            background: #ffffff;
            border-radius: 14px;
            padding: 32px;
            width: 380px;
            box-shadow: 0px 6px 25px rgba(0,0,0,0.08);
            position: relative;
            top: -40px;
        }


        .login-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 22px;
        }

        .btn-login {
            background: #000;
            color: #fff;
            width: 100%;
            padding: 10px;
            font-size: 15px;
            border: none;
            border-radius: 6px;
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    <%-- ロゴ画像 --%>
    <img src="${pageContext.request.contextPath}/pic/recook_logo.png" class="logo-img" alt="Re.Cook ロゴ">

    <div class="login-card">
        <div class="login-title">店舗ログイン</div>

        <%-- エラーメッセージの表示 (SuperLoginServletから受け取る) --%>
        <%
            String msg = (String)request.getAttribute("errorMsg");
            if(msg != null) {
        %>
            <div class="alert alert-danger mb-3" style="font-size: 13px; text-align: left;" role="alert">
                <%= msg %>
            </div>
        <% } %>

        <%-- 店舗ログイン用サーブレットへのフォーム --%>
        <form action="<%= request.getContextPath() %>/SuperLoginServlet" method="post">
            <div class="mb-3">
                <input type="text" name="id" class="form-control" placeholder="店舗ID" required autofocus>
            </div>
            <div class="mb-3">
                <input type="password" name="pass" class="form-control" placeholder="パスワード" required>
            </div>
            <button type="submit" class="btn btn-login">ログイン</button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>