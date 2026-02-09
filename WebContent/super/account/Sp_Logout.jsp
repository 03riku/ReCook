<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>ログアウト完了</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { background-color: #F5F5F0; }
    .sidebar {
        width: 240px; background: #ffffff; padding: 30px 20px; border-radius: 20px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); height: calc(100vh - 40px);
        position: fixed; left: 20px; top: 20px;
    }
    .main-card {
        background: #ffffff; padding: 60px 30px; border-radius: 20px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); height: calc(100vh - 40px);
        position: fixed; left: 270px; right: 20px; top: 20px;
        display: flex; flex-direction: column; align-items: center; justify-content: center;
    }
    .logo { text-align: center; margin-bottom: 40px; }
    .menu-btn { width: 100%; margin-bottom: 15px; opacity: 0.5; pointer-events: none; }
</style>
</head>
<body>

<!-- サイドバー（見た目維持のため配置） -->
<div class="sidebar">
    <div class="logo">
        <img src="<%= request.getContextPath() %>/pic/recook_logo.png" alt="Logo" style="width: 200px;">
    </div>
    <button class="btn btn-outline-dark menu-btn">商品</button>
    <button class="btn btn-outline-dark menu-btn">値引き商品</button>
    <button class="btn btn-outline-dark menu-btn">クーポン</button>
    <button class="btn btn-outline-dark menu-btn">ログアウト</button>
</div>

<div class="container">
    <div class="main-card text-center">
        <div class="mb-4">
            <h2 class="fw-bold">ログアウト完了</h2>
            <p class="text-muted">ご利用ありがとうございました。</p>
        </div>

        <hr class="w-50 mb-4">

        <p>安全にログアウトされました。<br>再度ご利用になる場合は、下記のボタンからログインしてください。</p>

        <div class="mt-4">
            <a href="<%= request.getContextPath() %>/super/account/Sp_Login.jsp" class="btn btn-primary px-5 py-2 rounded-pill shadow-sm">
                ログイン画面へ戻る
            </a>
        </div>
    </div>
</div>

</body>
</html>