<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- FIX: Import các lớp Java cần thiết: List và StringBuilder --%>
<%@ page import="java.util.List" %>
<%@ page import="java.lang.StringBuilder" %>

<%!
    private String createBody1Content(List<String> products) {
        StringBuilder sb = new StringBuilder();
        sb.append("<h4 class=\"mb-4 text-dark\">商品一覧</h4>");
        sb.append("<div class=\"table-responsive\">");
        sb.append("<table class=\"table table-hover product-list-table\">");
        sb.append("<thead><tr class=\"table-secondary\"><th>ID</th><th>商品名</th></tr></thead>");
        sb.append("<tbody>");

        if (products != null && !products.isEmpty()) {
            for (int i = 0; i < products.size(); i++) {
                sb.append("<tr>");
                sb.append("<td>").append(i + 1).append("</td>");
                sb.append("<td>");
                sb.append("<a href=\"#\" class=\"text-dark\" onclick=\"alert('Đã chọn sản phẩm: ").append(products.get(i)).append("')\">");
                sb.append(products.get(i));
                sb.append("</a>");
                sb.append("</td>");
                sb.append("</tr>");
            }
        } else {
            sb.append("<tr><td>1</td><td>牛肉 </td></tr>");
            sb.append("<tr><td>2</td><td>野菜 </td></tr>");
            sb.append("<tr><td>3</td><td>牛乳 </td></tr>");
            sb.append("<tr><td>4</td><td>豚肉 </td></tr>");
            sb.append("<tr><td>5</td><td>鶏肉 </td></tr>");
            sb.append("<tr><td>6</td><td>魚介 </td></tr>");
            sb.append("<tr><td>7</td><td>果物 </td></tr>");
            sb.append("<tr><td>8</td><td>パン </td></tr>");
        }

        sb.append("</tbody></table></div>");
        return sb.toString();
    }

    private String createBody2Content() {
        StringBuilder sb = new StringBuilder();
        sb.append("<h4 class=\"mb-4 text-dark\">商品編集</h4>");
        sb.append("<form id=\"ProductEditForm\" action=\"ProductServlet\" method=\"post\">");
        sb.append("<div class=\"row\">");

        sb.append("<div class=\"col-8\">");

        sb.append("<div class=\"row g-3 align-items-center mb-3\">");
        sb.append("<div class=\"col-3\"><label class=\"form-label\">商品名</label></div>");
        sb.append("<div class=\"col-3\"><label class=\"form-label\">商品名</label></div>");
        sb.append("<div class=\"col-6\">");
        sb.append("<input type=\"text\" name=\"productName\" class=\"form-control form-control-line\" value=\"牛肉\" required>");
        sb.append("</div>");
        sb.append("</div>");

        sb.append("<div class=\"row g-3 align-items-center mb-3\">");
        sb.append("<div class=\"col-3\"><label class=\"form-label\">カテゴリ</label></div>");
        sb.append("<div class=\"col-3\"><label class=\"form-label\">カテゴリ</label></div>");
        sb.append("<div class=\"col-6\">");
        sb.append("<select name=\"category\" class=\"form-select form-control-line\">");
        sb.append("<option value=\"\"></option>");
        sb.append("<option value=\"meat\" selected>肉</option>");
        sb.append("<option value=\"vegetable\">野菜</option>");
        sb.append("<option value=\"dairy\">乳製品</option>");
        sb.append("<option value=\"other\">その他</option>");
        sb.append("</select>");
        sb.append("</div>");
        sb.append("</div>");

        sb.append("<div class=\"row g-3 align-items-center mb-5\">");
        sb.append("<div class=\"col-3\"><label class=\"form-label\">その他</label></div>");
        sb.append("<div class=\"col-3\"><label class=\"form-label\">その他</label></div>");
        sb.append("<div class=\"col-6\">");
        sb.append("<input type=\"text\" name=\"otherField\" class=\"form-control form-control-line\" value=\"\">");
        sb.append("</div>");
        sb.append("</div>");

        sb.append("</div>"); // End col-8

        sb.append("<div class=\"col-4 d-flex justify-content-end align-items-start pt-custom-align\">");
        sb.append("<div class=\"d-grid gap-3\">");
        sb.append("<button type=\"submit\" name=\"action\" value=\"update\" form=\"ProductEditForm\" class=\"btn btn-dark btn-large-stacked\">更新</button>");
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

    .product-list-table {
        font-size: 0.9rem;
        cursor: pointer;
    }
    .product-list-table th, .product-list-table td {
        padding: 8px;
        text-align: left;
    }
</style>

<%
    request.setAttribute("pageTitle", "商品");

    @SuppressWarnings("unchecked")
    List<String> productList = (List<String>) request.getAttribute("products");
    String body1Content = createBody1Content(productList);
    request.setAttribute("pageContentBody1", body1Content);

    String body2Content = createBody2Content();
    request.setAttribute("pageContentBody2", body2Content);
%>

<c:import url="../Ad_base.jsp" />