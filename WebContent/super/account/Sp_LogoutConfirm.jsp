<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>ログアウト確認</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
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
    .menu-btn { width: 100%; margin-bottom: 15px; }

    /* 確認エリアのスタイル */
    .confirm-box {
        max-width: 400px;
        text-align: center;
    }
    .icon-logout {
        font-size: 4rem;
        color: #dc3545;
        margin-bottom: 20px;
    }
</style>
</head>
<body>

<!-- サイドバー（デザイン維持） -->
<div class="sidebar">
    <div class="logo">
        <img src="<%= request.getContextPath() %>/pic/recook_logo.png" alt="Logo" style="width: 200px;">
    </div>
    <button class="btn btn-outline-dark menu-btn">商品</button>
    <button class="btn btn-outline-dark menu-btn">値引き商品</button>
    <button class="btn btn-outline-dark menu-btn">クーポン</button>
    <button class="btn btn-dark menu-btn">ログアウト</button>
</div>

<div class="container">
    <div class="main-card">
        <div class="confirm-box">
            <div class="icon-logout">
                <i class="bi bi-box-arrow-right"></i>
            </div>
            <h3 class="fw-bold mb-3">ログアウト確認</h3>
            <p class="text-muted mb-5">ログアウトしてもよろしいですか？</p>

            <div class="d-grid gap-3">
                <!-- はい：サーブレットを呼び出してセッション破棄 -->
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-danger py-2 rounded-pill shadow-sm">
                    ログアウトする
                </a>

                <!-- いいえ：商品ページに戻る -->
                <a href="<%= request.getContextPath() %>/super/storeProductPage" class="btn btn-outline-secondary py-2 rounded-pill">
                    戻る
                </a>
            </div>
        </div>
    </div>
</div>

</body>
</html>