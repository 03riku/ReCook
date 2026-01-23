<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>クーポン登録 - Re.Cook</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { background-color: #F5F5F0; }
    .sidebar {
        width: 240px; background: #ffffff; padding: 30px 20px; border-radius: 20px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); height: calc(100vh - 40px);
        position: fixed; left: 20px; top: 20px;
    }
    .main-card {
        background: #ffffff; padding: 30px; border-radius: 20px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); min-height: calc(100vh - 40px);
        position: fixed; left: 270px; right: 20px; top: 20px; overflow-y: auto;
    }
    .logo { text-align: center; margin-bottom: 40px; }
    .menu-btn { width: 100%; margin-bottom: 15px; text-align: left; padding-left: 20px; }
    .dish-img { width: 100%; max-width: 320px; border-radius: 10px; object-fit: cover; border: 1px solid #ddd; }
    .item-table th { background-color: #f8f9fa; text-align: center; }
    .action-buttons .btn { width: 160px; font-weight: bold; border-width: 2px; }
</style>
</head>
<body>

    <div class="sidebar">
        <div class="logo">
            <img src="<%= request.getContextPath() %>/pic/recook_logo.png" alt="Logo" style="width: 200px;">
        </div>
        <a href="<%= request.getContextPath() %>/super/storeProductPage" class="btn btn-outline-dark menu-btn">商品</a>
        <a href="<%= request.getContextPath() %>/super/discountPage" class="btn btn-outline-dark menu-btn">値引き商品</a>
        <a href="<%= request.getContextPath() %>/super/couponPage" class="btn btn-dark menu-btn">クーポン</a>
        <a href="<%= request.getContextPath() %>/super/account/Sp_LogoutConfirm.jsp" class="btn btn-outline-dark menu-btn">ログアウト</a>
    </div>

    <div class="main-card">
        <div class="text-center mb-2">
            <span class="text-muted small">スーパー　クーポン登録</span>
            <h4 class="mt-2 fw-bold">オススメ料理登録画面</h4>
            <hr>
        </div>

        <form action="<%= request.getContextPath() %>/super/addCoupon" method="post">
            <div class="row mt-4">
                <!-- 左側：自店舗の具材一覧（在庫確認用） -->
                <div class="col-md-6">
                    <h6 class="fw-bold mb-3">在庫のある具材</h6>
                    <div style="max-height: 300px; overflow-y: auto; border: 1px solid #ddd;">
                        <table class="table table-bordered item-table mb-0">
                            <thead>
                                <tr>
                                    <th style="width: 30%;">赤色表示</th>
                                    <th>商品名</th>
                                </tr>
                            </thead>
                            <tbody class="text-center">
                                <c:forEach var="item" items="${ingredients}">
                                    <tr>
                                        <td><input type="checkbox" name="ingredients" value="${item.productId}"></td>
                                        <td>${item.productName}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 右側：対象料理の選択 -->
                <div class="col-md-6 text-center">
                    <h6 class="fw-bold mb-3 text-start ps-4">対象の料理を選択</h6>
                    <select name="menuItemId" class="form-select mb-3 mx-auto" style="max-width: 320px;" required>
                        <option value="">-- 料理を選択してください --</option>
                        <c:forEach var="m" items="${menus}">
                            <option value="${m.menuItemId}">${m.dishName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <!-- 下部：設定エリア -->
            <div class="row mt-5">
                <div class="col-md-8">
                    <!-- 時間設定（DBに項目がない場合はUIのみ表示） -->
                    <div class="row mb-3 align-items-center">
                        <div class="col-5">
                            <label class="form-label small fw-bold">開始時間</label>
                            <input type="datetime-local" class="form-control" name="startTime">
                        </div>
                        <div class="col-2 text-center pt-4"><span class="fs-4">～</span></div>
                        <div class="col-5">
                            <label class="form-label small fw-bold">終了時間</label>
                            <input type="datetime-local" class="form-control" name="endTime">
                        </div>
                    </div>

                    <div class="row align-items-center mt-4">
                        <div class="col-5">
                            <label class="form-label small fw-bold">値引き率</label>
                            <div class="input-group">
                                <input type="number" class="form-control text-end" name="discountRate" required>
                                <span class="input-group-text">%</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 d-flex flex-column align-items-end justify-content-end action-buttons">
                    <button type="submit" class="btn btn-outline-dark py-3 mb-3">追加</button>
                    <button type="button" onclick="location.href='<%= request.getContextPath() %>/super/storeProductPage'" class="btn btn-outline-dark py-3">戻る</button>
                </div>
            </div>
        </form>
    </div>
</body>
</html>