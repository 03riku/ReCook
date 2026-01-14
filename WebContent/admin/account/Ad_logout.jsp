<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%!
    private String createBodyContent(String contextPath) {
        StringBuilder sb = new StringBuilder();

        sb.append("<div class=\"d-flex flex-column align-items-center justify-content-center h-100 w-100\">");

        sb.append("<div class=\"logout-prompt p-5 mb-5 shadow-sm bg-white border border-dark rounded\">");
        sb.append("<h3 class=\"mb-0\" style=\"font-size: 2.5rem; white-space: nowrap;\">ログアウトしますか？</h3>");
        sb.append("</div>");

        sb.append("<div class=\"d-flex justify-content-center gap-5\">");

        sb.append("<button type=\"button\" onclick=\"window.history.back()\" class=\"btn btn-outline-dark btn-logout-action\">いいえ</button>");

        sb.append("<form action=\"").append(contextPath).append("/admin/logout\" method=\"post\" style=\"display: inline;\">");
        sb.append("<button type=\"submit\" class=\"btn btn-dark btn-logout-action\">はい</button>");
        sb.append("</form>");

        sb.append("</div>");
        sb.append("</div>");

        return sb.toString();
    }
%>

<style>
    .btn-logout-action {
        width: 180px;
        height: 70px;
        font-size: 1.5rem;
        font-weight: bold;
        border-width: 2px;
    }

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

    .content-body-split .content-col-2 {
        display: none !important;
    }
    .content-body-split .content-col-3 {
        width: 100% !important;
    }

    .content-body-split {
        height: 100%;
        width: 100%;
    }
</style>

<%
    request.setAttribute("pageTitle", "ログアウト");

    request.setAttribute("currentMenu", "logout");

    String bodyContent = createBodyContent(request.getContextPath());

    request.setAttribute("pageContentBody1", "");
    request.setAttribute("pageContentBody2", bodyContent);
%>

<c:import url="../Ad_base.jsp" />