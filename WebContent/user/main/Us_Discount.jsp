<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 1. ページの設定：ブラウザのタブやヘッダーに表示される名前を設定 --%>
<c:set var="pageTitle" value="クーポン提示" scope="request" />

<%-- 2. ページの中身（pageBody）の開始 --%>
<c:set var="pageBody" scope="request">
    <style>
        /* --- 見た目の設定（CSS） --- */
        body {
            background: #f0f0f0 !important; /* 背景を薄いグレーにしてクーポンを目立たせる */
        }

        /* クーポン全体を囲う白いボックスの設定 */
        .coupon-wrap {
            max-width: 450px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border: 3px dashed #f44336; /* 赤色の点線で「切り取り線」を表現 */
            border-radius: 20px;
            text-align: center;
        }

        /* バーコード画像のサイズを画面に合わせる設定 */
        .barcode-img {
            width: 100%;
            max-width: 320px;
            height: auto;
            margin: 25px 0;
        }

        /* 「レジにて提示してください」の赤い文字の設定 */
        .red-text {
            color: #f44336;
            font-weight: bold;
            font-size: 1.3rem;
        }
    </style>

    <%-- 3. 上部ヘッダー：戻るボタンとタイトル --%>
    <div class="d-flex align-items-center p-3 bg-white border-bottom sticky-top">
        <%-- javascript:history.back() は、ブラウザの戻るボタンと同じ動きをします --%>
        <a href="javascript:history.back();" class="text-dark fs-3 text-decoration-none">
            <i class="fas fa-chevron-left"></i>
        </a>
        <h5 class="mb-0 ms-3">クーポン提示画面</h5>
    </div>

    <%-- 4. メインコンテンツ：クーポン本体 --%>
    <div class="container">
        <div class="coupon-wrap shadow">
            <%-- 店員さんへのメッセージ --%>
            <div class="red-text">レジにて提示してください</div>

            <%-- ★ バーコード画像を表示
                 重要：もし画像が表示されない場合は、ファイル名が「baakoodo.png」になっていないか確認してください --%>
            <img src="${pageContext.request.contextPath}/pic/baakoodo.png" alt="Barcode" class="barcode-img">

            <%-- クーポンの詳細 --%>
            <div class="text-muted small">
                対象商品 10% OFF<br>
                有効期限：当日限り
            </div>

            <%-- 5. ホーム画面へ戻るボタン --%>
            <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="btn btn-dark mt-4 w-100 py-2">
                ホームへ戻る
            </a>
        </div>
    </div>
</c:set>

<%-- 6. 最後に土台となる base.jsp を読み込んで、上記の中身をはめ込む --%>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />