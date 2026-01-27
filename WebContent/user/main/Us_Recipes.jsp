<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    request.setCharacterEncoding("UTF-8");
    // 現在時刻取得 (yyyy-MM-dd HH:mm)
    String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    request.setAttribute("nowTime", now);
%>

<c:set var="pageTitle" value="${pageTitle}" scope="request" />

<c:set var="pageBody" scope="request">
    <style>
        body { background: rgb(238, 237, 234) !important; }
        .header-bar { display: flex; align-items: center; padding: 10px; background: #fff; border-bottom: 1px solid #ddd; position: sticky; top: 0; z-index: 1020; }
        .back-btn { font-size: 1.5rem; color: #333; text-decoration: none; margin-right: 15px; }
        .recipe-item { border: 2px solid #000; border-radius: 10px; padding: 12px 0; margin: 10px 0; background: #fff; transition: background-color 0.2s; }
        .recipe-item:hover { background-color: #f8f9fa; }
        .recipe-link { text-decoration: none; color: #333; display: block; }
        .recipe-img-box { width: 100%; height: 100px; background: #f0f0f0; display: flex; align-items: center; justify-content: center; overflow: hidden; border-radius: 5px; }
        .recipe-img-box img { width: 100%; height: 100%; object-fit: cover; }
        .text-truncate-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; font-size: 0.85rem; }
        .status-badge { font-size: 0.75rem; font-weight: bold; padding: 2px 6px; border-radius: 4px; vertical-align: middle; }
    </style>

    <div class="header-bar">
        <a href="javascript:history.back();" class="back-btn"><i class="fas fa-chevron-left"></i></a>
        <h5 class="mb-0 fw-bold">${pageTitle} (${menuList.size()}件)</h5>
    </div>

    <div class="container py-2" style="max-width: 500px;">
        <div class="px-2">
            <c:forEach var="item" items="${menuList}">

                <%-- 予定判定 --%>
                <c:set var="isPlanned" value="${not empty item.startTime && nowTime < item.startTime}" />

                <%-- ★ クリック判定：店舗詳細画面(fromStore)かつ予定(isPlanned)の場合のみ制限 --%>
                <c:set var="canClick" value="true" />
                <c:if test="${fromStore && isPlanned}">
                    <c:set var="canClick" value="false" />
                </c:if>

                <c:choose>
                    <c:when test="${canClick}">
                        <a href="${pageContext.request.contextPath}/user/MenuDetail?id=${item.menuItemId}&fromStore=${fromStore}" class="recipe-link">
                    </c:when>
                    <c:otherwise>
                        <div class="recipe-link" style="opacity: 0.75; cursor: not-allowed;">
                    </c:otherwise>
                </c:choose>

                    <div class="row g-0 recipe-item shadow-sm">
                        <div class="col-4 px-2">
                            <div class="recipe-img-box border">
                                <c:choose>
                                    <c:when test="${not empty item.image}"><img src="${pageContext.request.contextPath}/pic/${item.image}" alt="${item.dishName}"></c:when>
                                    <c:otherwise><i class="fas fa-utensils fa-2x text-muted"></i></c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="col-8 px-2 text-start">
                            <div class="fw-bold mb-1">
                                <%-- ★ 修正：店舗詳細画面のときだけバッジを表示 --%>
                                <c:if test="${fromStore && not empty item.startTime}">
                                    <c:choose>
                                        <c:when test="${!isPlanned}"><span class="status-badge bg-success text-white">表示中</span></c:when>
                                        <c:otherwise><span class="status-badge bg-primary text-white">予定</span></c:otherwise>
                                    </c:choose>
                                </c:if>
                                ${item.dishName}
                            </div>

                            <div class="text-muted small mb-1">
                                <i class="far fa-clock"></i> ${item.cookTime}分
                                <%-- ★ 修正：店舗詳細画面のときだけ「～まで」の時間を表示 --%>
                                <c:if test="${fromStore && not empty item.endTime}">
                                    <span class="ms-1 text-danger fw-bold">～${item.endTime.substring(5,16).replace("-","/")}まで</span>
                                </c:if>
                            </div>
                            <div class="text-secondary text-truncate-2">${item.description}</div>

                            <%-- ★ 修正：店舗詳細画面 かつ 予定 のときだけ開始案内を表示 --%>
                            <c:if test="${fromStore && isPlanned}">
                                <div class="mt-1 small text-primary fw-bold"><i class="fas fa-info-circle"></i> ${item.startTime.substring(5,16).replace("-","/")} から開始</div>
                            </c:if>
                        </div>
                    </div>

                <c:choose>
                    <c:when test="${canClick}"></a></c:when>
                    <c:otherwise></div></c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

        <c:if test="${empty menuList}">
            <div class="py-5 text-center text-muted">
                <i class="fas fa-search fa-3x mb-3"></i>
                <p>該当する料理が見つかりませんでした。</p>
            </div>
        </c:if>
        <div style="height: 100px;"></div>
    </div>

    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2 bottom-nav">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center bar-home">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center bar-search active">検索</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center bar-recipe">料理提案</a>
        <a href="${pageContext.request.contextPath}/user/StoreList" class="text-dark text-decoration-none text-center bar-store">店舗</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center bar-account">アカウント</a>
    </nav>
</c:set>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />