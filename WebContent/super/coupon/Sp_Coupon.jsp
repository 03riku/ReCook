<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>クーポン登録 - Re.Cook</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<style>
    body { background-color: #F5F5F0; margin: 0; padding: 0; overflow: hidden; }

    /* サイドバー */
    .sidebar {
        width: 240px; background: #ffffff; padding: 30px 20px; border-radius: 20px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); height: calc(100vh - 40px);
        position: fixed; left: 20px; top: 20px;
    }

    /* メインカード */
    .main-card {
        background: #ffffff; padding: 30px; border-radius: 20px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        height: calc(100vh - 40px);
        position: fixed; left: 270px; right: 20px; top: 20px;
        overflow-y: auto;
    }

    .logo { text-align: center; margin-bottom: 40px; }
    .menu-btn { width: 100%; margin-bottom: 15px; }

    /* テーブル・リスト設定 */
    .table-container {
        max-height: 220px;
        overflow-y: auto;
        border: 1px solid #dee2e6;
        border-radius: 5px;
    }
    .total-area {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 10px;
        border: 1px solid #dee2e6;
        margin-top: 15px;
    }

    .action-buttons .btn { width: 160px; font-weight: bold; border-width: 2px; }
</style>
</head>
<body>

    <!-- 左サイドメニュー -->
    <div class="sidebar">
        <div class="logo">
            <img src="<%= request.getContextPath() %>/pic/recook_logo.png" alt="Re.Cook Logo" style="width: 200px;">
        </div>
        <a href="<%= request.getContextPath() %>/super/storeProductPage" class="btn btn-outline-dark menu-btn">商品</a>
        <a href="<%= request.getContextPath() %>/super/discountPage" class="btn btn-outline-dark menu-btn">値引き商品</a>
        <a href="<%= request.getContextPath() %>/super/couponPage" class="btn btn-dark menu-btn">クーポン</a>
        <a href="<%= request.getContextPath() %>/super/account/Sp_LogoutConfirm.jsp" class="btn btn-outline-dark menu-btn">ログアウト</a>
    </div>

    <!-- メイン画面 -->
    <div class="main-card">
        <div class="text-center mb-2">
            <span class="text-muted small">スーパー　クーポン登録</span>
            <h4 class="mt-2 fw-bold">オススメ料理登録画面</h4>
            <hr>
        </div>

        <form action="<%= request.getContextPath() %>/super/addCoupon" method="post">
            <div class="row mt-4">
                <!-- 左側：必要な具材一覧（自動表示） -->
                <div class="col-md-7 mb-4">
                    <h6 class="fw-bold mb-3"><i class="bi bi-cart-check"></i> この料理に必要な具材と価格</h6>
                    <div class="table-container">
                        <table class="table table-bordered mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>具材名</th>
                                    <th class="text-end" style="width: 120px;">単価</th>
                                </tr>
                            </thead>
                            <tbody id="ingredientTableBody">
                                <tr><td colspan="2" class="text-center text-muted py-5">右側で料理を選択してください</td></tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 合計金額表示 -->
                    <div class="total-area d-flex justify-content-between align-items-center shadow-sm">
                        <span class="fw-bold text-secondary">具材の合計金額：</span>
                        <span class="fs-4 fw-bold text-primary"><span id="totalAmount">0</span> 円</span>
                    </div>
                </div>

                <!-- 右側：対象料理の選択 -->
                <div class="col-md-5 mb-4 text-center">
                    <h6 class="fw-bold mb-3 text-start ps-2">対象の料理を選択</h6>
                    <select id="menuSelector" name="menuItemId" class="form-select mb-4" required>
                        <option value="">-- 料理を選択 --</option>
                        <c:forEach var="m" items="${menus}">
                            <option value="${m.menuItemId}">${m.dishName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <!-- 下部：期間と値引き設定エリア -->
            <div class="row mt-2 border-top pt-4">
                <div class="col-md-8">
                    <div class="row mb-4">
                        <div class="col-5">
                            <label class="form-label small fw-bold text-muted">開始時間</label>
                            <input type="datetime-local" class="form-control" name="startTime" required>
                        </div>
                        <div class="col-2 text-center pt-4"><span class="fs-4">～</span></div>
                        <div class="col-5">
                            <label class="form-label small fw-bold text-muted">終了時間</label>
                            <input type="datetime-local" class="form-control" name="endTime" required>
                        </div>
                    </div>

                    <div class="row align-items-center">
                        <div class="col-5">
                            <label class="form-label small fw-bold text-muted">値引き率</label>
                            <div class="input-group">
                                <input type="number" id="discountRate" name="discountRate" class="form-control text-end" required min="1" max="99" placeholder="0">
                                <span class="input-group-text">%</span>
                            </div>
                        </div>
                        <div class="col-2"></div>
                        <div class="col-5">
                            <label class="form-label small fw-bold text-muted">値引き後の値段</label>
                            <div class="input-group">
                                <!-- JavaScriptで自動計算される表示用項目 -->
                                <input type="text" id="discountedPriceDisplay" class="form-control text-end bg-white" readonly placeholder="0">
                                <span class="input-group-text">円</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ボタンエリア -->
                <div class="col-md-4 d-flex flex-column align-items-end justify-content-end action-buttons">
                    <button type="submit" class="btn btn-outline-dark py-3 mb-3">追加</button>
                    <button type="button" onclick="location.href='<%= request.getContextPath() %>/super/storeProductPage'" class="btn btn-outline-dark py-3">戻る</button>
                </div>
            </div>
            <div class="mb-5"></div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    let currentTotal = 0;

    // 料理選択時に具材と価格を取得
    document.getElementById('menuSelector').addEventListener('change', function() {
        const menuId = this.value;
        const tableBody = document.getElementById('ingredientTableBody');
        const totalDisp = document.getElementById('totalAmount');

        if (!menuId) {
            tableBody.innerHTML = '<tr><td colspan="2" class="text-center text-muted py-5">料理を選択してください</td></tr>';
            totalDisp.textContent = '0';
            currentTotal = 0;
            updateFinalPrice();
            return;
        }

        fetch('<%= request.getContextPath() %>/super/getIngredientsByMenu?menuId=' + menuId)
            .then(response => response.json())
            .then(data => {
                tableBody.innerHTML = '';
                currentTotal = 0;

                if (data.length > 0) {
                    data.forEach(item => {
                        const tr = document.createElement('tr');
                        const price = item.price || 0;
                        currentTotal += price;

                        tr.innerHTML = `
                            <td class="ps-3">\${item.name}</td>
                            <td class="text-end pe-3">\${price.toLocaleString()} 円</td>
                        `;
                        tableBody.appendChild(tr);
                    });
                    totalDisp.textContent = currentTotal.toLocaleString();
                } else {
                    tableBody.innerHTML = '<tr><td colspan="2" class="text-center text-muted py-5">具材データがありません</td></tr>';
                    totalDisp.textContent = '0';
                    currentTotal = 0;
                }
                updateFinalPrice();
            });
    });

    // 値引き率が変更された時の自動計算
    document.getElementById('discountRate').addEventListener('input', updateFinalPrice);

    function updateFinalPrice() {
        const rate = parseInt(document.getElementById('discountRate').value) || 0;
        const display = document.getElementById('discountedPriceDisplay');

        if (currentTotal > 0 && rate > 0) {
            const finalPrice = Math.round(currentTotal * (1 - (rate / 100)));
            display.value = finalPrice.toLocaleString();
        } else {
            display.value = currentTotal.toLocaleString();
        }
    }
    </script>
</body>
</html>