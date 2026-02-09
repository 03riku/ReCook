<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<%-- 修正点: param.title ではなく pageTitle を表示 --%>
<title><c:out value="${pageTitle}" default="Re.Cook" /> | Re.Cook</title>

<%-- Bootstrap 5 CSS --%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<%-- FontAwesome --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    body {
        font-family: "Helvetica Neue", Arial, sans-serif;
        background-color: #ffffff;
        padding-bottom: 80px;
    }

    .page-header {
        background-color: #ffe5d9;
        border-bottom: 1px solid #333;
        padding: 10px 0;
        text-align: center;
        font-weight: bold;
        font-size: 1.2rem;
        color: #333;
    }
</style>
</head>
<body>

    <%-- 修正点: param.title ではなく pageTitle を表示 --%>
    <header class="page-header">
        ${pageTitle}画面
    </header>

    <%-- 修正点: param.body ではなく pageBody を表示 --%>
    <main>
        ${pageBody}
    </main>

    <%-- Bootstrap JS --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>