package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import util.Common;
@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public Login() {
        super();
    }
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		Connection db = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		HttpSession session = null;

		try {


			//入力された値を変数に代入
			String logId = request.getParameter("loginId");
			String logPass = request.getParameter("loginPass");

			//入力エラー表示
			if((logId == "") || (logPass == "")) {
				request.setAttribute("err", Common.IdPassErr);
				getServletContext().getRequestDispatcher("/Login.jsp").forward(request,response);
			}

			//データベース接続
			try {
				Context context = new InitialContext();
				DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/kensyu");
				db = ds.getConnection();
			}catch(SQLException e) {
				//未接続エラー表示
				request.setAttribute("err", Common.IdPassErr);
				getServletContext().getRequestDispatcher("/Login.jsp").forward(request,response);
			}


			//データベースから検索
			ps = db.prepareStatement("SELECT * FROM tb_employee_info WHERE employee_id='" + logId + "' AND password='" + logPass + "'");
			rs = ps.executeQuery();

			//データ判定
			if (rs.next()) {
				session = request.getSession(true);

				//権限権限レベル判定
				if(rs.getInt("admin_level") == Common.AUTH_GENE) {
					//閲覧のみのセッション記憶
					session.setAttribute("hyoji",Common.AUTH_GENE);
				} else {
					//登録編集可のセッション記憶
					session.setAttribute("hyoji", Common.AUTH_MANE);
				}

				//ユーザ名とIDをセッションに記憶
				session.setAttribute("name",rs.getString("employee_name"));
				session.setAttribute("id", rs.getString("employee_id"));

				response.sendRedirect("List");
			} else {
				//入力エラー表示
				request.setAttribute("err", Common.IdPassErr);
				getServletContext().getRequestDispatcher("/Login.jsp").forward(request,response);
			}
			rs.close();
			ps.close();
			db.close();

		}catch(NamingException e) {
			e.printStackTrace();
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
}
