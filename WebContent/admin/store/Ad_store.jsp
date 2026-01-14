<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List" %>
<%@ page import="java.lang.StringBuilder" %>
<%@ page import="java.util.Arrays" %>

<%!
    private final List<String[]> DUMMY_STORES = Arrays.asList(
        new String[]{"001", "青山店 (Aoyama)", "東京都渋谷区神宮前"},
        new String[]{"002", "新宿店 (Shinjuku)", "東京都新宿区西新宿"},
        new String[]{"003", "大阪店 (Osaka)", "大阪府大阪市北区梅田"},
        new String[]{"004", "福岡店 (Fukuoka)", "福岡県福岡市博多区"}
    );

    private String createBody1Content(List<String[]> stores) {
        StringBuilder sb = new StringBuilder();
        sb.append("<h4 class=\"mb-4 text-dark\">店舗一覧</h4>");
        sb.append("<div class=\"table-responsive\">");
        sb.append("<table class=\"table table-hover store-list-table\">");
        sb.append("<thead><tr class=\"table-secondary\"><th>ID</th><th>店舗名</th></tr></thead>");
        sb.append("<tbody>");

        List<String[]> list = (stores != null && !stores.isEmpty()) ? stores : DUMMY_STORES;

        for (String[] store : list) {
            String storeId = store[0];
            String storeName = store[1];
            sb.append("<tr>");
            sb.append("<td>").append(storeId).append("</td>");
            sb.append("<td>");
            sb.append("<a href=\"#\" class=\"text-dark\" onclick=\"console.log('Đã chọn cửa hàng ID: ").append(storeId).append("'); return false;\">");
            sb.append(storeName);
            sb.append("</a>");
            sb.append("</td>");
            sb.append("</tr>");
        }

        sb.append("</tbody></table></div>");
        return sb.toString();
    }

    private String createBody2Content() {
        StringBuilder sb = new StringBuilder();
        sb.append("<h4 class=\"mb-4 text-dark\">店舗追加</h4>");
        sb.append("<form id=\"StoreForm\" action=\"StoreServlet\" method=\"post\">");

        sb.append("<div class=\"row\">");

        sb.append("<div class=\"col-8\">");

        sb.append("<div class=\"row g-3 align-items-center mb-3\">");
        sb.append("<div class=\"col-6\"><label class=\"form-label fw-bold\">店舗名</label></div>");
        sb.append("<div class=\"col-6\">");
        sb.append("<input type=\"text\" name=\"storeName\" class=\"form-control form-control-line\" required>");
        sb.append("</div>");
        sb.append("</div>");

        sb.append("<div class=\"row g-3 align-items-center mb-3\">");
        sb.append("<div class=\"col-6\"><label class=\"form-label fw-bold\">店舗ID</label></div>");
        sb.append("<div class=\"col-6\">");
        sb.append("<input type=\"text\" name=\"storeId\" class=\"form-control form-control-line\" required>");
        sb.append("</div>");
        sb.append("</div>");

        sb.append("<div class=\"row g-3 align-items-center mb-3\">");
        sb.append("<div class=\"col-6\"><label class=\"form-label fw-bold\">店舗パスワード</label></div>");
        sb.append("<div class=\"col-6\">");
        sb.append("<input type=\"password\" name=\"storePassword\" class=\"form-control form-control-line\" required>");
        sb.append("</div>");
        sb.append("</div>");

        sb.append("<div class=\"row g-3 align-items-center mb-5\">");
        sb.append("<div class=\"col-6\"><label class=\"form-label fw-bold\">住所</label></div>");
        sb.append("<div class=\"col-6\">");
        sb.append("<input type=\"text\" name=\"storeAddress\" class=\"form-control form-control-line\" placeholder=\"例: 東京都渋谷区\">");
        sb.append("</div>");
        sb.append("</div>");

        sb.append("</div>");

        sb.append("<div class=\"col-4 d-flex justify-content-end align-items-start pt-custom-align\">");
        sb.append("<div class=\"d-grid gap-3\">");

        sb.append("<button type=\"submit\" name=\"action\" value=\"add\" form=\"StoreForm\" class=\"btn btn-dark btn-large-stacked\">追加</button>");

        sb.append("<button type=\"button\" onclick=\"window.history.back()\" class=\"btn btn-outline-dark btn-large-stacked\">戻る</button>");

        sb.append("</div>");
        sb.append("</div>");

        sb.append("</div>"); // End row
        sb.append("</form>");

        return sb.toString();
    }
%>

<style>
    .form-control-line {
        border: none;
        border-bottom: 1px solid black;
        border-radius: 0;
        padding: 5px 0;
        box-shadow: none !important;
        width: 100%;
        transition: border-color 0.15s ease-in-out;
    }
    .form-control-line:focus {
        border-bottom-color: #007bff;
    }
    .btn-large-stacked {
        width: 150px;
        height: 60px;
        font-size: 1.1rem;
        font-weight: bold;
    }
    .pt-custom-align {
        padding-top: 3.5rem !important;
    }

    .store-list-table {
        font-size: 0.9rem;
        cursor: pointer;
    }
    .store-list-table th, .store-list-table td {
        padding: 8px;
        text-align: left;
    }
    .form-label {
        margin-bottom: 0.5rem;
    }
</style>

<%
    request.setAttribute("pageTitle", "店舗");

    request.setAttribute("currentMenu", "store");

    @SuppressWarnings("unchecked")
    List<String[]> storeList = (List<String[]>) request.getAttribute("stores");
    String body1Content = createBody1Content(storeList);
    request.setAttribute("pageContentBody1", body1Content);

    String body2Content = createBody2Content();
    request.setAttribute("pageContentBody2", body2Content);
%>

<c:import url="../Ad_base.jsp" />