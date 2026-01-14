package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// セッションを取得（なければnull）
		HttpSession session = request.getSession(false);

		if (session != null) {
			// ■ ここでセッションを破棄（ログアウト処理の本体）
			session.invalidate();
		}

		// ログアウト完了後、ログイン画面へリダイレクト
		response.sendRedirect(request.getContextPath() + "/user/main/Us_Login.jsp");
	}
}