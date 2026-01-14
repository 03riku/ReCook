<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="検索結果" scope="request" />

<c:set var="pageBody" scope="request">
    <div class="container py-4">
        <h5 class="mb-4">検索結果：${menuList.size()} 件</h5>

        <div class="list-group">
            <c:forEach var="item" items="${menuList}">
                <%-- ★ここが重要：item.menuName ではなく item.dishName にする --%>
                <a href="${pageContext.request.contextPath}/user/MenuDetail?id=${item.menuItemId}"
                   class="list-group-item list-group-item-action">
                    <div class="d-flex w-100 justify-content-between">
                        <h6 class="mb-1">${item.dishName}</h6>
                    </div>
                    <small class="text-muted">${item.description}</small>
                </a>
            </c:forEach>
        </div>

        <c:if test="${empty menuList}">
            <p class="text-center mt-5">該当する料理は見つかりませんでした。</p>
        </c:if>
    </div>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />