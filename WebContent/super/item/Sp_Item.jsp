<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>商品ページ</title>
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
    rel="stylesheet">

<style>
body {
    background-color: #F5F5F0; /* ロゴに合う淡いグレーベージュ */
}

/* 左メニュー */
.sidebar {
    width: 240px;
    background: #ffffff;
    padding: 30px 20px;
    border-radius: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    height: calc(100vh - 40px);
    position: fixed;
    left: 20px;
    top: 20px;
}

.main-card {
    background: #ffffff;
    padding: 30px;
    border-radius: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    min-height: calc(100vh - 40px);
    position: fixed;
    left: 270px;
    right: 20px;
    top: 20px;
}

.logo {
    font-size: 32px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 40px;
}

.menu-btn {
    width: 100%;
    margin-bottom: 15px;
}
</style>
</head>

<body>

    <!-- 左サイドメニュー -->
    <div class="sidebar">
        <div class="logo">
            <img src="<%= request.getContextPath() %>/pic/recook_logo.png"
                alt="Re.Cook Logo" style="width: 200px;">
        </div>

        <button class="btn btn-outline-dark menu-btn">商品</button>
        <button class="btn btn-outline-dark menu-btn">値引き商品</button>
        <button class="btn btn-outline-dark menu-btn">クーポン</button>
        <button class="btn btn-outline-dark menu-btn">ログアウト</button>
    </div>

    <!-- メイン画面 -->
    <div class="container">
        <div class="main-card">

            <!-- タイトル＋区切り線 -->
            <h4 class="text-center mb-2">商品ページ</h4>
            <hr class="mb-4">

            <div class="row">

                <!-- 左：商品一覧 -->
                <div class="col-6 border-end">
                    <h5>商品</h5>
                    <ul>
                        <li>にんじん</li>
                        <li>じゃがいも</li>
                        <li>にら</li>
                        <li>鮭</li>
                    </ul>
                </div>

                <!-- 右：自店舗商品一覧 -->
                <div class="col-6 ps-4">
                    <h5>自店舗商品一覧</h5>

                    <table class="table">
                        <thead>
                            <tr>
                                <th>選択</th>
                                <th>商品名</th>
                                <th>価格</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>じゃがいも</td>
                                <td>100円</td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>ブロッコリー</td>
                                <td>120円</td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>なす</td>
                                <td>80円</td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>大根</td>
                                <td>150円</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- 削除ボタン -->
                    <div class="mt-3 text-center">
                        <button class="btn btn-danger px-4">削除</button>
                    </div>

                </div><!-- col-6 end -->
            </div><!-- row end -->

        </div><!-- main-card end -->
    </div><!-- container end -->

</body>
</html>
