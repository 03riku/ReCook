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
        max-height: 200px;
        overflow-y: auto;
        border: 1px solid #dee2e6;
        border-radius: 5px;
        margin-bottom: 15px;
    }

    .existing-list-container {
        height: calc(100vh - 200px);
        overflow-y: auto;
        border: 1px solid #dee2e6;
        border-radius: 10px;
        background-color: #fcfcfc;
    }

    .coupon-card {
        background: #fff;
        border-bottom: 1px solid #eee;
        padding: 15px;
        transition: 0.2s;
        cursor: pointer; /* クリックできることを示す */
        position: relative;
    }
    .coupon-card:hover { background-color: #e9ecef; border-left: 5px solid #343a40; }
    .coupon-card.active { background-color: #e2e6ea; border-left: 5px solid #0d6efd; }

    .total-area {
        background-color: #f8f9fa;
        padding: 10px 15px;
        border-radius: 10px;
        border: 1px solid #dee2e6;
    }
</style>
</head>
<body>

    <!-- サイドバー -->
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
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <span class="text-muted small">スーパー　クーポン登録</span>
                <h4 class="mt-1 fw-bold">オススメ料理登録画面</h4>
            </div>
            <div>
                <c:if test="${not empty sessionScope.errorMsg}">
                    <div class="alert alert-danger py-1 px-3 mb-0 small" role="alert">${sessionScope.errorMsg}</div>
                    <c:remove var="errorMsg" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.successMsg}">
                    <div class="alert alert-success py-1 px-3 mb-0 small" role="alert">${sessionScope.successMsg}</div>
                    <c:remove var="successMsg" scope="session"/>
                </c:if>
            </div>
        </div>
        <hr class="mt-0">

        <div class="row">
            <!-- 【左側】：登録・編集フォーム -->
            <div class="col-md-7 border-end pe-4">
                <form id="couponForm" action="<%= request.getContextPath() %>/super/addCoupon" method="post">

                    <!-- 隠しフィールド：操作タイプとクーポンID -->
                    <input type="hidden" name="action" id="formAction" value="register">
                    <input type="hidden" name="couponId" id="formCouponId" value="0">

                    <!-- モード表示 -->
                    <div class="d-flex justify-content-between mb-2">
                        <span id="modeBadge" class="badge bg-secondary">新規登録モード</span>
                        <button type="button" class="btn btn-sm btn-outline-secondary" onclick="resetForm()">新規登録に戻る</button>
                    </div>

                    <!-- 料理選択 -->
                    <div class="mb-3">
                        <label class="fw-bold form-label"><i class="bi bi-search"></i> 対象の料理を選択</label>
                        <select id="menuSelector" name="menuItemId" class="form-select" required>
                            <option value="">-- 料理を選択してください --</option>
                            <c:forEach var="m" items="${menus}">
                                <option value="${m.menuItemId}">${m.dishName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- 具材一覧 -->
                    <label class="form-label small fw-bold text-muted">必要な具材と原価</label>
                    <div class="table-container bg-white">
                        <table class="table table-sm table-borderless mb-0">
                            <thead class="table-light sticky-top">
                                <tr>
                                    <th class="ps-3">具材名</th>
                                    <th class="text-end pe-3">単価</th>
                                </tr>
                            </thead>
                            <tbody id="ingredientTableBody">
                                <tr><td colspan="2" class="text-center text-muted py-4 small">料理を選択すると表示されます</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 合計金額 -->
                    <div class="total-area d-flex justify-content-between align-items-center mb-4">
                        <span class="small fw-bold text-secondary">具材合計(原価):</span>
                        <span class="fw-bold text-dark"><span id="totalAmount">0</span> 円</span>
                    </div>

                    <!-- 設定エリア -->
                    <h6 class="fw-bold mb-3"><i class="bi bi-gear"></i> 販売設定</h6>
                    <div class="row mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted">販売開始</label>
                            <input type="datetime-local" class="form-control" name="startTime" id="startTime" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-muted">販売終了</label>
                            <input type="datetime-local" class="form-control" name="endTime" id="endTime" required>
                        </div>
                    </div>

                    <div class="row align-items-end mb-4">
                        <div class="col-4">
                            <label class="form-label small fw-bold text-muted">値引き率</label>
                            <div class="input-group">
                                <input type="number" id="discountRate" name="discountRate" class="form-control text-end" required min="1" max="99" placeholder="0">
                                <span class="input-group-text">%</span>
                            </div>
                        </div>
                        <div class="col-1 text-center pb-2"><i class="bi bi-arrow-right"></i></div>
                        <div class="col-4">
                            <label class="form-label small fw-bold text-muted">販売価格</label>
                            <div class="input-group">
                                <input type="text" id="discountedPriceDisplay" class="form-control text-end bg-white fw-bold text-danger" readonly placeholder="0">
                                <span class="input-group-text">円</span>
                            </div>
                        </div>
                    </div>

                    <!-- ボタンエリア -->
                    <div class="d-grid gap-2">
                        <!-- 新規登録ボタン -->
                        <button type="submit" id="btnRegister" class="btn btn-dark py-2">
                            <i class="bi bi-plus-circle"></i> クーポンを登録
                        </button>

                        <!-- 更新・削除ボタン（初期は非表示） -->
                        <div id="btnUpdateDelete" class="row gx-2 d-none">
                            <div class="col-6">
                                <button type="submit" onclick="setAction('update')" class="btn btn-primary w-100 py-2">
                                    <i class="bi bi-pencil-square"></i> 更新
                                </button>
                            </div>
                            <div class="col-6">
                                <!-- formnovalidateを追加し、削除時はHTML5バリデーションを無視 -->
                                <button type="submit" onclick="setAction('delete')" class="btn btn-outline-danger w-100 py-2" formnovalidate>
                                    <i class="bi bi-trash"></i> 削除
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- 【右側】：登録済みリスト -->
            <div class="col-md-5 ps-4">
                <h6 class="fw-bold mb-3"><i class="bi bi-list-check"></i> 現在登録中のクーポン</h6>
                <p class="small text-muted mb-2">クリックして編集・削除できます</p>

                <div class="existing-list-container">
                    <c:choose>
                        <c:when test="${empty couponList}">
                            <div class="text-center text-muted mt-5">
                                <p>登録済みのクーポンはありません</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="coupon" items="${couponList}">
                                <!-- クリックイベントを追加し、データを埋め込む -->
                                <div class="coupon-card"
                                     onclick='selectCoupon(
                                         "${coupon.couponId}",
                                         "${coupon.menuItemId}",
                                         "${coupon.discountRate}",
                                         "${coupon.startTime}",
                                         "${coupon.endTime}"
                                     )'>
                                    <div class="d-flex justify-content-between align-items-start">
                                        <h6 class="fw-bold text-primary mb-1">${coupon.dishName}</h6>
                                        <span class="badge bg-danger">${coupon.discountRate}% OFF</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-end mt-2">
                                        <div class="small text-muted">
                                            <div><i class="bi bi-clock"></i> ${coupon.startTime}</div>
                                            <div><i class="bi bi-arrow-return-right"></i> ${coupon.endTime}</div>
                                        </div>
                                        <div class="fw-bold fs-5">
                                            ${coupon.price} <span class="fs-6">円</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    let currentTotal = 0;

    // 料理選択時の処理 (具材取得)
    document.getElementById('menuSelector').addEventListener('change', function() {
        const menuId = this.value;
        const tableBody = document.getElementById('ingredientTableBody');
        const totalDisp = document.getElementById('totalAmount');

        if (!menuId) {
            tableBody.innerHTML = '<tr><td colspan="2" class="text-center text-muted py-4 small">料理を選択すると表示されます</td></tr>';
            totalDisp.textContent = '0';
            currentTotal = 0;
            updateFinalPrice();
            return;
        }

        // 非同期で具材と価格を取得
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
                    tableBody.innerHTML = '<tr><td colspan="2" class="text-center text-muted py-4 small">具材データがありません</td></tr>';
                    totalDisp.textContent = '0';
                    currentTotal = 0;
                }
                updateFinalPrice();
            })
            .catch(err => {
                console.error('Error:', err);
            });
    });

    // 値引き率変更時の計算
    document.getElementById('discountRate').addEventListener('input', updateFinalPrice);

    function updateFinalPrice() {
        const rate = parseInt(document.getElementById('discountRate').value) || 0;
        const display = document.getElementById('discountedPriceDisplay');

        if (currentTotal > 0) {
            // ★ 切り捨てに統一（DBのTRUNCATEと合わせる）
            const finalPrice = Math.floor(currentTotal * (1 - (rate / 100)));
            display.value = finalPrice.toLocaleString();
        } else {
            display.value = "0";
        }
    }


    // --- リスト選択時の処理 ---
    function selectCoupon(couponId, menuItemId, rate, startTime, endTime) {
        document.getElementById('formCouponId').value = couponId;
        document.getElementById('menuSelector').value = menuItemId;
        document.getElementById('discountRate').value = rate;
        document.getElementById('startTime').value = startTime;
        document.getElementById('endTime').value = endTime;

        // メニュー選択イベントを手動発火
        const event = new Event('change');
        document.getElementById('menuSelector').dispatchEvent(event);

        // モード切替
        document.getElementById('formAction').value = 'update';
        document.getElementById('btnRegister').classList.add('d-none');
        document.getElementById('btnUpdateDelete').classList.remove('d-none');

        const badge = document.getElementById('modeBadge');
        badge.className = 'badge bg-primary';
        badge.textContent = '編集モード';
    }

    // ボタンクリック時にActionを設定
    function setAction(actionType) {
        document.getElementById('formAction').value = actionType;
    }

    // 新規登録モードに戻す
    function resetForm() {
        document.getElementById('couponForm').reset();
        document.getElementById('formCouponId').value = "0";
        document.getElementById('formAction').value = "register";

        document.getElementById('ingredientTableBody').innerHTML = '<tr><td colspan="2" class="text-center text-muted py-4 small">料理を選択すると表示されます</td></tr>';
        document.getElementById('totalAmount').textContent = "0";
        document.getElementById('discountedPriceDisplay').value = "0";

        document.getElementById('btnRegister').classList.remove('d-none');
        document.getElementById('btnUpdateDelete').classList.add('d-none');

        const badge = document.getElementById('modeBadge');
        badge.className = 'badge bg-secondary';
        badge.textContent = '新規登録モード';

        currentTotal = 0;
    }

    // ==========================================
    // ★【追加・修正】フォーム送信時のバリデーション
    // ==========================================
    document.getElementById('couponForm').addEventListener('submit', function(e) {
        const action = document.getElementById('formAction').value;

        // 1. 削除の場合のチェック
        if (action === 'delete') {
            if (!confirm('本当にこのクーポンを削除しますか？')) {
                e.preventDefault(); // キャンセル
            }
            return; // 削除なら時間チェックはスキップ
        }

        // 2. 登録・更新の場合の時間チェック
        const startTime = document.getElementById('startTime').value;
        const endTime = document.getElementById('endTime').value;

        if (startTime && endTime) {
            // 文字列比較で十分判定可能です (ISOフォーマットの為)
            if (startTime >= endTime) {
                e.preventDefault(); // 送信を中止
                alert("【エラー】\n終了日時は、開始日時より未来の日時を指定してください。");
            }
        }
    });
    </script>
</body>
</html>