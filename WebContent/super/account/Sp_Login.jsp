<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>スーパーログイン - Re.Cook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #eeedea; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: #fff; padding: 40px; border-radius: 14px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); width: 380px; text-align: center; }
        .login-title { font-size: 26px; font-weight: 700; margin-bottom: 20px; }
        .btn-super { background: #000; color: #fff; width: 100%; padding: 12px; border-radius: 8px; font-weight: 600; border: none; }
    </style>
</head>
<body>

<div class="login-card">
    <div class="login-title">スーパーログイン</div>

    <% String msg = (String)request.getAttribute("errorMsg"); %>
    <% if(msg != null) { %>
        <div class="alert alert-danger" style="font-size: 13px; text-align: left;"><%= msg %></div>
    <% } %>

    <%-- サーブレットのURL名「SuperLoginServlet」を指定 --%>
    <form action="<%= request.getContextPath() %>/SuperLoginServlet" method="post">
        <div class="mb-3">
            <input type="text" name="id" class="form-control" placeholder="店舗ID" required autofocus>
        </div>
        <div class="mb-3">
            <input type="password" name="pass" class="form-control" placeholder="パスワード" required>
        </div>
        <button type="submit" class="btn btn-super">ログイン</button>
    </form>
</div>

</body>
</html>