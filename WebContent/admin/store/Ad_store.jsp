<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*, bean.Store" %>

<%!
    private String createBody1Content(List<String[]> stores, String contextPath) {
        StringBuilder sb = new StringBuilder();
        sb.append("<h4 class=\"mb-4 text-dark\">店舗一覧</h4>");
        sb.append("<form action=\"").append(contextPath).append("/admin/store/StoreServlet\" method=\"get\" class=\"mb-4\">");
        sb.append("<div class=\"input-group\">");
        sb.append("<input type=\"text\" name=\"keyword\" class=\"form-control form-control-line\" placeholder=\"店舗名で検索...\">");
        sb.append("<button class=\"btn btn-dark\" type=\"submit\">検索</button>");
        sb.append("</div></form>");
        sb.append("<div class=\"table-responsive\"><table class=\"table table-hover\"><tbody>");

        if (stores != null && !stores.isEmpty()) {
            for (String[] store : stores) {
                String editUrl = contextPath + "/admin/store/StoreServlet?editId=" + store[0];
                sb.append("<tr><td><a href=\"").append(editUrl).append("\" class=\"text-dark text-decoration-none d-block\">");
                sb.append("<span class=\"me-2\">・</span>").append(store[1]).append("</a></td></tr>");
            }
        } else {
            sb.append("<tr><td class=\"text-center\">店舗が登録されていません。</td></tr>");
        }
        sb.append("</tbody></table></div>");
        return sb.toString();
    }

    private String createBody2Content(String contextPath, Store sel, Object msg, String mode) {
        StringBuilder sb = new StringBuilder();
        if (msg != null) {
            String msgStr = msg.toString();
            String alertClass = msgStr.contains("Error") ? "alert-danger" : "alert-success";
            sb.append("<div class=\"alert ").append(alertClass).append(" py-2\">").append(msgStr.replace("Error: ", "")).append("</div>");
        }

        if (sel != null && "confirm".equals(mode)) {
            sb.append("<div class=\"card border-danger text-center p-4\"><h4 class=\"text-danger\">削除の確認</h4>");
            sb.append("<p>本当に <strong>").append(sel.getStoreName()).append("</strong> を削除しますか？</p>");
            sb.append("<form action=\"").append(contextPath).append("/admin/store/StoreServlet\" method=\"post\">");
            sb.append("<input type=\"hidden\" name=\"storeId\" value=\"").append(sel.getStoreId()).append("\">");
            sb.append("<div class=\"d-flex justify-content-center gap-3 mt-3\">");
            sb.append("<button type=\"submit\" name=\"action\" value=\"delete\" class=\"btn btn-danger btn-large-stacked\">はい</button>");
            sb.append("<a href=\"").append(contextPath).append("/admin/store/StoreServlet?editId=\"").append(sel.getStoreId()).append("\" class=\"btn btn-outline-dark btn-large-stacked d-flex align-items-center justify-content-center\">いいえ</a>");
            sb.append("</div></form></div>");
        } else {
            boolean isEdit = (sel != null);
            sb.append("<h4 class=\"mb-4 text-dark\">").append(isEdit ? "店舗編集" : "店舗追加").append("</h4>");
            sb.append("<form id=\"storeForm\" action=\"").append(contextPath).append("/admin/store/StoreServlet\" method=\"post\" onsubmit=\"return validateForm()\">");

            if(isEdit) {
                sb.append("<input type=\"hidden\" name=\"oldStoreId\" value=\"").append(sel.getStoreId()).append("\">");
            }

            sb.append("<div class=\"row\"><div class=\"col-8\">");
            String[][] fields = {
                {"店舗名", "storeName", isEdit ? sel.getStoreName() : ""},
                {"店舗ID", "storeId", isEdit ? String.valueOf(sel.getStoreId()) : ""},
                {"パスワード", "storePassword", isEdit ? sel.getStorePassword() : ""},
                {"住所", "storeAddress", isEdit ? sel.getStoreAddress() : ""}
            };

            for (String[] f : fields) {
                sb.append("<div class=\"row g-3 align-items-center mb-4\">");
                sb.append("<div class=\"col-4\"><label class=\"fw-bold\">").append(f[0]).append("</label></div>");
                sb.append("<div class=\"col-8\"><input type=\"text\" id=\"").append(f[1]).append("\" name=\"").append(f[1]).append("\" value=\"").append(f[2]).append("\" class=\"form-control form-control-line\" required>");

                // Div hiển thị lỗi cho ID
                if(f[1].equals("storeId")) {
                    sb.append("<div id=\"idError\" class=\"text-danger small mt-1\" style=\"display:none;\"></div>");
                }
                sb.append("</div></div>");
            }
            sb.append("</div><div class=\"col-4 d-flex justify-content-end align-items-start pt-4\"><div class=\"d-grid gap-3\">");

            if (isEdit) {
                sb.append("<button type=\"submit\" name=\"action\" value=\"update\" class=\"btn btn-dark btn-large-stacked\">保存</button>");
                sb.append("<a href=\"").append(contextPath).append("/admin/store/StoreServlet?editId=").append(sel.getStoreId()).append("&mode=confirm\" class=\"btn btn-danger btn-large-stacked d-flex align-items-center justify-content-center\">削除</a>");
                sb.append("<a href=\"").append(contextPath).append("/admin/store/StoreServlet\" class=\"btn btn-outline-dark btn-large-stacked d-flex align-items-center justify-content-center\">新規</a>");
            } else {
                sb.append("<button type=\"submit\" name=\"action\" value=\"add\" class=\"btn btn-dark btn-large-stacked\">追加</button>");
                sb.append("<button type=\"button\" onclick=\"window.history.back()\" class=\"btn btn-outline-dark btn-large-stacked\">戻る</button>");
            }
            sb.append("</div></div></div></form>");
        }
        return sb.toString();
    }
%>

<style>
    .form-control-line { border: none; border-bottom: 1px solid #333; border-radius: 0; padding: 5px 0; background-color: transparent; box-shadow: none !important; }
    .btn-large-stacked { width: 140px; height: 55px; font-weight: bold; }
</style>

<script>
function validateForm() {
    const storeIdInput = document.getElementById('storeId');
    const idError = document.getElementById('idError');
    const val = storeIdInput.value;

    idError.style.display = 'none';
    storeIdInput.classList.remove('is-invalid');

    if (!/^\d{10}$/.test(val)) {
        idError.innerText = "店舗IDは10桁の数字で入力してください。";
        idError.style.display = 'block';
        storeIdInput.focus();
        return false;
    }

    if (val.charAt(0) === '0') {
        idError.innerText = "最初の桁は０以外入力してください。";
        idError.style.display = 'block';
        storeIdInput.focus();
        return false;
    }

    return true;
}
</script>

<%
    request.setAttribute("pageTitle", "店舗管理");
    request.setAttribute("currentMenu", "store");

    List<String[]> storeList = (List<String[]>) request.getAttribute("stores");
    Store sel = (Store) request.getAttribute("selectedStore");
    Object msg = request.getAttribute("message");
    String mode = (String) request.getAttribute("mode");

    request.setAttribute("pageContentBody1", createBody1Content(storeList, request.getContextPath()));
    request.setAttribute("pageContentBody2", createBody2Content(request.getContextPath(), sel, msg, mode));
%>

<c:import url="../Ad_base.jsp" />