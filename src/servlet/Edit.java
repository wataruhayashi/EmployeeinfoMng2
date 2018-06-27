package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;

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
@WebServlet("/Edit")
public class Edit extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		Connection db = null;
		PreparedStatement ps = null;

		//入力された値を変数に代入
		String employee_id = request.getParameter("employee_id");
		String employee_name = request.getParameter("employee_name");
		String department = request.getParameter("department");
		String post = request.getParameter("post");
		String entry_date = request.getParameter("entry_date");
		String password = request.getParameter("password");
		Integer admin_level = Integer.parseInt(request.getParameter("admin_level"));

		//ログインユーザを変数に代入
		HttpSession session = request.getSession(false);
		String update_user = (String) session.getAttribute("id");

		try {

			//データベース接続
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/kensyu");
			db = ds.getConnection();

			//エラー表示
			if((employee_name == "") || (department == "") || (password == "")) {

				if(employee_name == "") { request.setAttribute("NulName", Common.NulName); }
				if(department == "") { request.setAttribute("NulDep", Common.NulDep); }
				if(password == "") { request.setAttribute("NulPass", Common.NulPass); }
				getServletContext().getRequestDispatcher("/EditProfile.jsp").forward(request,response);

			//削除ボタンを押したとき
			} else if (request.getParameter("delete") != null) {
			  ps = db.prepareStatement("DELETE FROM tb_employee_info WHERE employee_id='" + employee_id + "'");

			//更新ボタンを押したとき
			} else {
			  ps = db.prepareStatement("UPDATE tb_employee_info SET employee_id=?, employee_name=?, department=?, post=?, entry_date=?, password=?, admin_level=?, update_user=?, update_date=? WHERE employee_id=?");
			  ps.setString(1, employee_id);
			  ps.setString(2, employee_name);
			  ps.setString(3, department);

			  if((post != null) && (post != "")) {
					ps.setString(4, post);
			  } else {
					ps.setString(4, null);
			  }

			  if((entry_date != null) && (entry_date != "")) {
				  //文字列entry_dateをDate型に変換
				  Date date = Date.valueOf(entry_date);
				  ps.setDate(5, date);
			  } else {
				  ps.setDate(5, null);
			  }

			  //日付正規表現
			  if(!Common.DateMatch(entry_date) && (entry_date != null) && (entry_date != "")) {
				  request.setAttribute("err", Common.MisErr);
				  getServletContext().getRequestDispatcher("/RegProfile.jsp").forward(request,response);
			  }

			  ps.setString(6, password);
			  ps.setInt(7, admin_level);
			  ps.setString(8, update_user);

			  //現在時刻を入れる
			  Calendar c = Calendar.getInstance();
			  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		      Timestamp timestamp = Timestamp.valueOf(sdf.format(c.getTime()));
			  ps.setTimestamp(9,timestamp);

			  ps.setString(10, employee_id);
			}
			ps.executeUpdate();

		}catch(NamingException e) {
			e.printStackTrace();
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(ps != null) {ps.close();}
				if(db != null) {db.close();}
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		//Listサーブレットにリダイレクト
		response.sendRedirect("List");
	}

}
