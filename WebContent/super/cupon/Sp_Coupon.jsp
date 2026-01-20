<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>オススメ料理登録 - Re.Cook</title>
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
    rel="stylesheet">

<style>
/* 全体の背景色 */
body {
    background-color: #F5F5F0;
}

/* 左メニュー（サイドバー）固定設定 */
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

/* メインコンテンツ（カード）固定設定 */
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
    overflow-y: auto;
}

.logo {
    text-align: center;
    margin-bottom: 40px;
}

.menu-btn {
    width: 100%;
    margin-bottom: 15px;
    text-align: left;
    padding-left: 20px;
}

/* 料理画像のスタイル */
.dish-img {
    width: 100%;
    max-width: 320px;
    border-radius: 10px;
    object-fit: cover;
    border: 1px solid #ddd;
}

/* チェックボックス用テーブルの調整 */
.item-table th {
    background-color: #f8f9fa;
    text-align: center;
}

/* 右下ボタンのスタイル */
.action-buttons .btn {
    width: 160px;
    font-weight: bold;
    border-width: 2px;
}
</style>
</head>

<body>

    <!-- 左サイドメニュー -->
    <div class="sidebar">
        <div class="logo">
            <!-- ロゴ画像へのパスをルートから指定 -->
            <img src="<%= request.getContextPath() %>/pic/recook_logo.png"
                alt="Re.Cook Logo" style="width: 180px;">
        </div>

        <!-- リンク先は想定されるパスに設定しています -->
        <button class="btn btn-outline-dark menu-btn"
                onclick="location.href='<%= request.getContextPath() %>/super/item/Sp_Item.jsp'">・ 商品</button>
        <button class="btn btn-outline-dark menu-btn">・ 値引き商品</button>
        <button class="btn btn-dark menu-btn">・ クーポン</button> <!-- 現在のページなので色を反転 -->

        <div style="margin-top: 50px;">
            <button class="btn btn-outline-dark menu-btn"
                    onclick="location.href='<%= request.getContextPath() %>/super/account/Sp_Login.jsp'">・ ログアウト</button>
        </div>
    </div>

    <!-- メイン画面 -->
    <div class="main-card">

        <!-- ヘッダー部分 -->
        <div class="text-center mb-2">
            <span class="text-muted small">スーパー　オススメ登録</span>
            <h4 class="mt-2 fw-bold">オススメ料理画面</h4>
            <hr>
        </div>

        <form action="<%= request.getContextPath() %>/super/cupon/CouponRegisterServlet" method="post">
            <div class="row mt-4">

                <!-- 左側：具材選択テーブル -->
                <div class="col-md-6">
                    <table class="table table-bordered item-table">
                        <thead>
                            <tr>
                                <th style="width: 30%;">赤色表示</th>
                                <th>商品名</th>
                            </tr>
                        </thead>
                        <tbody class="text-center">
                            <tr>
                                <td><input type="checkbox" name="ingredients" value="rice"></td>
                                <td>米</td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" name="ingredients" value="egg"></td>
                                <td>卵</td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" name="ingredients" value="chicken" checked></td>
                                <td>鶏肉</td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" name="ingredients" value="onion"></td>
                                <td>ネギ</td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" name="ingredients" value="cabbage"></td>
                                <td>キャベツ</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- 右側：料理のプレビュー画像 -->
                <div class="col-md-6 text-center">
                    <img src="<%= request.getContextPath() %>/pic/dish_sample.jpg"
                         alt="料理画像" class="dish-img shadow-sm">
                </div>
            </div>

            <!-- 下部：時間・価格設定エリア -->
            <div class="row mt-5">
                <div class="col-md-8">
                    <div class="row mb-3 align-items-center">
                        <div class="col-5">
                            <label class="form-label small fw-bold">開始時間</label>
                            <input type="datetime-local" class="form-control" name="startTime">
                        </div>
                        <div class="col-2 text-center pt-4">
                            <span class="fs-4">～</span>
                        </div>
                        <div class="col-5">
                            <label class="form-label small fw-bold">終了時間</label>
                            <input type="datetime-local" class="form-control" name="endTime">
                        </div>
                    </div>

                    <div class="row align-items-center mt-4">
                        <div class="col-5">
                            <label class="form-label small fw-bold">値引き率</label>
                            <div class="input-group">
                                <input type="number" class="form-control text-end" placeholder="00" name="discountRate">
                                <span class="input-group-text">%</span>
                            </div>
                        </div>
                        <div class="col-2"></div>
                        <div class="col-5">
                            <label class="form-label small fw-bold">値引き後の値段</label>
                            <div class="input-group">
                                <input type="number" class="form-control text-end" placeholder="00" name="discountedPrice">
                                <span class="input-group-text">円</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 右下：操作ボタン -->
                <div class="col-md-4 d-flex flex-column align-items-end justify-content-end action-buttons">
                    <button type="submit" class="btn btn-outline-dark py-3 mb-3">追加</button>
                    <button type="button" onclick="history.back()" class="btn btn-outline-dark py-3">戻る</button>
                </div>
            </div>
        </form>
    </div>

</body>
</html>