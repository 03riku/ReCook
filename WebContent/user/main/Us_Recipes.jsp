<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="${pageTitle}" scope="request" />

<c:set var="pageBody" scope="request">
    <style>
        body { background: rgb(238, 237, 234) !important; }
        .page-header { background-color: #d9ead3 !important; }

        /* ★戻るボタン付きヘッダー */
        .header-bar {
            display: flex; align-items: center; padding: 10px;
            background: #fff; border-bottom: 1px solid #ddd;
            position: sticky; top: 0; z-index: 1020;
        }
        .back-btn { font-size: 1.5rem; color: #333; text-decoration: none; margin-right: 15px; }

        .recipe-item { border: 2px solid #000; border-radius: 10px; padding: 12px 0; margin: 10px 0; background: #fff; }
        .recipe-link { text-decoration: none; color: #333; display: block; }
        .recipe-img-placeholder { width: 100%; height: 100px; background: #f0f0f0; display: flex; align-items: center; justify-content: center; color: #adb5bd; }
        .text-truncate-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; font-size: 0.85rem; }

        /* ナビゲーションスタイル (以下省略、既存のものと同じ) */
    </style>

    <%-- ★画面上部の戻るボタンバー --%>
    <div class="header-bar">
        <a href="javascript:history.back();" class="back-btn"><i class="fas fa-chevron-left"></i></a>
        <h5 class="mb-0 fw-bold">${pageTitle} (${menuList.size()}件)</h5>
    </div>

    <div class="container py-2" style="max-width: 500px;">
        <div class="px-2">
            <c:forEach var="item" items="${menuList}">
                <a href="${pageContext.request.contextPath}/user/MenuDetail?id=${item.menuItemId}&fromStore=${fromStore}" class="recipe-link">
                    <div class="row g-0 recipe-item">
                        <div class="col-4 px-2">
                            <div class="recipe-img-placeholder border rounded"><i class="fas fa-utensils fa-2x"></i></div>
                        </div>
                        <div class="col-8 px-2 text-start">
                            <div class="fw-bold mb-1">${item.dishName}</div>
                            <div class="text-muted small mb-1"><i class="far fa-clock"></i> 調理時間 ${item.cookTime}分</div>
                            <div class="text-secondary text-truncate-2">${item.description}</div>
                        </div>
                    </div>
                </a>
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

    <%-- ナビゲーションバーは既存の通り --%>
</c:set>
<c:import url="/user/base.jsp" charEncoding="UTF-8" />