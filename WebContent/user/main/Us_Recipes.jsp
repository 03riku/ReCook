<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%-- ■パラメータ取得 --%>
<c:set var="searchKeyword" value="${param.keyword}" />
<c:set var="searchGenre" value="${param.genre}" />

<%-- ■モード判定と設定 --%>
<c:choose>
    <c:when test="${not empty searchKeyword}">
        <c:set var="pageTitle" value="検索結果" scope="request" />
        <c:set var="headerColor" value="#c9daf8" />
        <c:set var="mode" value="keyword" />
        <c:set var="currentNav" value="search" />
    </c:when>
    <c:when test="${not empty searchGenre}">
        <c:set var="pageTitle" value="料理提案" scope="request" />
        <c:set var="headerColor" value="#d9ead3" />
        <c:set var="mode" value="genre" />
        <c:set var="currentNav" value="suggestion" />
        <c:if test="${searchGenre == 'japanese'}"><c:set var="genreName" value="和食" /></c:if>
        <c:if test="${searchGenre == 'western'}"><c:set var="genreName" value="洋食" /></c:if>
        <c:if test="${searchGenre == 'budget'}"><c:set var="genreName" value="節約飯" /></c:if>
        <c:if test="${searchGenre == 'manmeshi'}"><c:set var="genreName" value="漢メシ" /></c:if>
    </c:when>
    <c:otherwise>
        <c:set var="pageTitle" value="アカウント" scope="request" />
        <c:set var="headerColor" value="#ead1dc" />
        <c:set var="mode" value="favorite" />
        <c:set var="currentNav" value="account" />
    </c:otherwise>
</c:choose>

<c:set var="pageBody" scope="request">
    <style>
        .page-header { background-color: ${headerColor} !important; }
        .recipe-row { border-bottom: 1px solid #000; padding: 10px 0; background-color: #fff; }
        .recipe-img-placeholder { width: 100%; height: 90px; background-color: #eee; display: flex; align-items: center; justify-content: center; color: #aaa; font-size: 0.8rem; }
        .return-box { width: 100%; padding: 15px; text-align: center; border: 1px solid #000; background-color: #ffffff; color: #333; text-decoration: none; display: block; }
    </style>

    <div class="container py-0 px-0" style="max-width: 500px;">

        <%-- 検索バー（キーワードモード時） --%>
        <c:if test="${mode == 'keyword'}">
            <div class="p-3 bg-white border-bottom border-dark">
                <form action="${pageContext.request.contextPath}/user/Search" method="get">
                    <div class="input-group">
                        <button type="submit" class="input-group-text bg-white border-end-0">
                            <i class="fas fa-search text-primary"></i>
                        </button>
                        <input type="text" name="keyword" class="form-control border-start-0" value="${searchKeyword}" placeholder="検索">
                    </div>
                </form>
            </div>
        </c:if>

        <div class="recipe-list-container border-top border-dark">
            <c:choose>
                <%-- ★キーワード検索：DBから取得した menuList を表示 --%>
                <c:when test="${mode == 'keyword'}">
                    <c:choose>
                        <c:when test="${not empty menuList}">
                            <c:forEach var="item" items="${menuList}">
                                <a href="${pageContext.request.contextPath}/user/main/Us_Coupon.jsp?id=${item.menuItemId}" class="text-decoration-none text-dark">
                                    <div class="row g-0 recipe-row align-items-center">
                                        <div class="col-4 px-2"><div class="recipe-img-placeholder border"><i class="fas fa-utensils fa-2x"></i></div></div>
                                        <div class="col-8 px-1 text-center">
                                            <div class="fw-bold">${item.menuName}
                                                <c:if test="${item.cookTime > 0}"><span class="small fw-normal"><i class="far fa-clock"></i> ${item.cookTime}分</span></c:if>
                                            </div>
                                            <div class="small mt-1 text-muted">詳細を見る</div>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="py-5 text-center text-muted"><p>該当するレシピはありません。</p></div>
                        </c:otherwise>
                    </c:choose>
                </c:when>

                <%-- ジャンル検索（固定表示） --%>
                <c:when test="${mode == 'genre'}">
                    <div class="text-center py-2 bg-light border-bottom">ジャンル：${genreName}</div>
                    <%-- ここに既存のジャンル別<a>タグを記述 --%>
                </c:when>

                <%-- お気に入り表示（固定表示） --%>
                <c:otherwise>
                    <div class="p-3 text-muted">お気に入り一覧</div>
                    <a href="${pageContext.request.contextPath}/user/main/Us_Coupon.jsp?recipeName=ポトフ" class="text-decoration-none text-dark">
                        <div class="row g-0 recipe-row align-items-center">
                            <div class="col-4 px-2"><div class="recipe-img-placeholder border"><i class="fas fa-utensils fa-2x"></i></div></div>
                            <div class="col-8 px-1 text-center"><div class="fw-bold">美味しいポトフ</div></div>
                        </div>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${mode == 'favorite'}">
            <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="return-box">戻る</a>
        </c:if>
        <div style="height: 80px;"></div>
    </div>

    <%-- ナビゲーション --%>
    <nav class="fixed-bottom border-top bg-white d-flex justify-content-around py-2">
        <a href="${pageContext.request.contextPath}/user/main/Us_Top.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">ホーム</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Search.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">
            <div>検索</div>
            <c:if test="${currentNav == 'search'}"><div class="mt-1 mx-auto" style="background-color: #c9daf8; height: 5px; width: 80%;"></div></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/user/main/Us_RecipeGenre.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">料理提案</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Store.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">店舗</a>
        <a href="${pageContext.request.contextPath}/user/main/Us_Account.jsp" class="text-dark text-decoration-none text-center" style="min-width: 60px;">アカウント</a>
    </nav>
</c:set>

<c:import url="/user/base.jsp" charEncoding="UTF-8" />