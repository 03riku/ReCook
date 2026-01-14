<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle} | Re.Cook</title>

    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            font-family: sans-serif;
            background-color: #f8f9fa; /* Thêm màu nền nhẹ */
        }

        .sidebar {
            width: 200px; /* Độ rộng Sidebar */
            height: 100vh; /* Chiếm toàn bộ chiều cao */
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
        }

        .main-content {
            margin-left: 200px;
            padding: 0;
            display: flex;
            flex-direction: column;
            height: 100vh;
        }

        .header-content {
            padding: 10px 20px;
            border-bottom: 2px solid #dee2e6;
            background-color: white;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .content-body-split {
            flex-grow: 1;
            display: flex;
            width: 100%;
            overflow: hidden;
        }

        .content-col-2 {
            width: 30%;
            padding: 20px;
            border-right: 2px solid #dee2e6;
            overflow-y: auto;
            background-color: #f8f9fa;
        }

        .content-col-3 {
            width: 70%;
            padding: 20px;
            overflow-y: auto;
            background-color: white;
        }
    </style>
</head>
<body>

    <!-- IMPORT MENU (Sidebar) -->
    <c:import url="/admin/Ad_menu.jsp" />

    <!-- MAIN CONTENT -->
    <div class="main-content">

        <!-- HEADER -->
        <div class="header-content">
            <h5 class="mb-0 text-dark">${pageTitle}</h5>
        </div>

        <!-- CONTENT BODY -->
        <!-- Nhờ flex-grow: 1 và overflow: hidden, khu vực này sẽ chiếm hết chiều cao còn lại -->
        <div class="content-body-split">
            <!-- Cột trái (danh sách) -->
            <div class="content-col-2">
                <c:out value="${pageContentBody1}" escapeXml="false" />
            </div>

            <!-- Cột phải (form chi tiết) -->
            <div class="content-col-3">
                <c:out value="${pageContentBody2}" escapeXml="false" />
            </div>
        </div>
    </div>

    <!-- Bootstrap JS CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>