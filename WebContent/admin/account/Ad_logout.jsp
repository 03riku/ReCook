<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%!
    // 画面中央に表示するHTMLコンテンツ（ログアウト確認画面）を動的に生成するメソッド
    private String createBodyContent(String contextPath) {
        StringBuilder sb = new StringBuilder();

        // 外側のコンテナ：Flexboxを使って上下左右中央揃えにする
        sb.append("<div class=\"d-flex flex-column align-items-center justify-content-center h-100 w-100\">");

        // メッセージ表示エリア
        sb.append("<div class=\"logout-prompt p-5 mb-5 shadow-sm bg-white border border-dark rounded\">");
        sb.append("<h3 class=\"mb-0\" style=\"font-size: 2.5rem; white-space: nowrap;\">ログアウトしますか？</h3>");
        sb.append("</div>");

        // ボタンエリア
        sb.append("<div class=\"d-flex justify-content-center gap-5\">");

        // 「いいえ」ボタン：前の画面に戻る (History Back)
        sb.append("<button type=\"button\" onclick=\"window.history.back()\" class=\"btn btn-outline-dark btn-logout-action\">いいえ</button>");

        // 「はい」ボタン：ログアウト用サーブレットへPOST送信
        sb.append("<form action=\"").append(contextPath).append("/admin/logout\" method=\"post\" style=\"display: inline;\">");
        sb.append("<button type=\"submit\" class=\"btn btn-dark btn-logout-action\">はい</button>");
        sb.append("</form>");

        sb.append("</div>");
        sb.append("</div>");

        return sb.toString();
    }
%>

<style>
    /* ログアウト画面専用のボタンスタイル（大きめのサイズ） */
    .btn-logout-action {
        width: 180px;
        height: 70px;
        font-size: 1.5rem;
        font-weight: bold;
        border-width: 2px;
    }

    /* 確認メッセージボックスのスタイル */
    .logout-prompt {
        text-align: center;
        width: 70%;
        max-width: 600px;
        min-height: 150px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-left: auto;
        margin-right: auto;
    }

    /* 重要：Ad_base.jspのレイアウトを上書きする設定 */

    /* 左側のカラム（リスト表示エリア）を非表示にする */
    .content-body-split .content-col-2 {
        display: none !important;
    }

    /* 右側のカラムを横幅100%に広げ、画面全体を使うように変更 */
    .content-body-split .content-col-3 {
        width: 100% !important;
    }

    /* コンテンツエリアの高さを確保 */
    .content-body-split {
        height: 100%;
        width: 100%;
    }
</style>

<%
    // ページタイトルの設定
    request.setAttribute("pageTitle", "ログアウト");

    // 現在のメニュー位置（サイドバーのハイライト用）
    request.setAttribute("currentMenu", "logout");

    // 上記のヘルパーメソッドを呼び出してHTMLを生成
    String bodyContent = createBodyContent(request.getContextPath());

    // Ad_base.jsp に渡すコンテンツ
    // 左カラム(col-2)はCSSで非表示にしているため空文字を設定
    request.setAttribute("pageContentBody1", "");

    // 生成したHTMLを右カラム(col-3、現在は全画面化されている)に設定
    request.setAttribute("pageContentBody2", bodyContent);
%>

<c:import url="../Ad_base.jsp" />