<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="クーポン提示" scope="request" />

<c:set var="pageBody" scope="request">
    <style>
        body { background: #f0f0f0 !important; }
        .coupon-wrap {
            max-width: 450px; margin: 40px auto; background: #fff;
            padding: 30px; border: 3px dashed #f44336; border-radius: 20px; text-align: center;
        }
        .barcode-img { width: 100%; max-width: 320px; height: auto; margin: 25px 0; }
        .red-text { color: #f44336; font-weight: bold; font-size: 1.3rem; }
    </style>

    <div class="d-flex align-items-center p-3 bg-white border-bottom sticky-top">
        <a href="javascript:history.back();" class="text-dark fs-3 text-decoration-none"><i class="fas fa-chevron-left"></i></a>
        <h5 class="mb-0 ms-3">クーポン提示画面</h5>
    </div>

    <div class="container">
        <div class="coupon-wrap shadow">
            <div class="red-text">レジにて提示してください</div>

            <%-- ★ バーコード画像（barcode.png になっている必要があります） --%>
            <img src="${pageContext.request.contextPath}/pic/barcode.png" alt="Barcode" class="barcode-img">

            <div class="text-muted small">
                対象商品 10% OFF<br>有効期限：当日限り
            </div>

            <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="btn btn-dark mt-4 w-100 py-2">ホームへ戻る</a>
        </div>
    </div>
</c:set>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />