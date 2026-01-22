<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
.sidebar {
	background-color: #f8f9fa !important;
	padding: 20px !important;
	height: 100vh;
}

/* Hiệu ứng cho khung viền ảnh Logo */
.logo-container {
	display: inline-block;
	padding: 5px;
	border: 2px solid #dee2e6; /* Màu viền xám nhạt */
	border-radius: 12px;       /* Bo góc khung viền */
	background-color: white;   /* Nền trắng cho ảnh */
	transition: all 0.3s ease; /* Hiệu ứng mượt mà */
	box-shadow: 0 4px 6px rgba(0,0,0,0.05); /* Đổ bóng nhẹ */
}

/* Hiệu ứng khi di chuột vào Logo */
.logo-container:hover {
	border-color: #6c757d;     /* Đổi màu viền khi hover */
	transform: scale(1.05);    /* Phóng to nhẹ 5% */
	box-shadow: 0 6px 12px rgba(0,0,0,0.1);
}

.menu-link-item {
	text-decoration: none;
	padding: 10px 15px;
	border-radius: 5px;
	transition: background-color 0.15s ease-in-out;
	display: block;
	color: #212529;
}

.menu-link-active {
	background-color: #6c757d !important;
	color: white !important;
	font-weight: bold;
}

.menu-link-item:not(.menu-link-active):hover {
	background-color: #e9ecef;
	color: #000 !important;
}
</style>

<div class="sidebar bg-light p-3 border-end">
	<h2 class="text-center mb-4">
		<div class="logo-container">
			<img src="${pageContext.request.contextPath}/pic/recook_logo.png" alt="Re.Cook Logo"
				style="max-width: 140px; height: auto; display: block; border-radius: 8px;">
		</div>
	</h2>

	<ul class="list-unstyled p-0 m-0" id="sidebar-menu">
		<li class="mb-2">
			<a href="${pageContext.request.contextPath}/product/Admin_ProductServlet" class="menu-link-item">
				商品
			</a>
		</li>

		<li class="mb-2">
			<a href="${pageContext.request.contextPath}/admin/store/StoreServlet" class="menu-link-item">
				店舗
			</a>
		</li>

		<li class="mb-2">
			<a href="${pageContext.request.contextPath}/admin/recipe/RecipeServlet" class="menu-link-item">
				料理
			</a>
		</li>

		<li class="mt-2">
			<a href="${pageContext.request.contextPath}/admin/account/Ad_logout.jsp" class="menu-link-item">
				ログアウト
			</a>
		</li>
	</ul>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const currentPath = window.location.pathname;
        const menuLinks = document.querySelectorAll('#sidebar-menu .menu-link-item');

        menuLinks.forEach(link => {
            const linkPath = link.getAttribute('href');
            if (currentPath.includes(linkPath) && linkPath !== "#") {
                link.classList.add('menu-link-active');
            } else {
                link.classList.remove('menu-link-active');
            }
        });

        if (currentPath.endsWith("/admin/") || currentPath.endsWith("/index.jsp")) {
            if(menuLinks.length > 0) menuLinks[0].classList.add('menu-link-active');
        }
    });
</script>