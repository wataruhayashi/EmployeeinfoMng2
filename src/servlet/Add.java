package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
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

@WebServlet("/Add")
public class Add extends HttpServlet {
	private static final long serialVersionUID = 1L;


    public Add() {
        super();
    }

	public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

    	request.setCharacterEncoding("UTF-8");

    	Connection db = null;
		PreparedStatement ps =null;

		//入力された値を変数に代入
		String employee_id = request.getParameter("employee_id");
		String employee_name = request.getParameter("employee_name");
		String department = request.getParameter("department");
		String post = request.getParameter("Post");
		String entry_date = request.getParameter("entry_date");
		String password = request.getParameter("password");
		Integer admin_level = Integer.parseInt(request.getParameter("admin_level"));
		//ログインユーザを変数に代入
		HttpSession session = request.getSession(false);
		String regist_user = (String) session.getAttribute("id");

		try {
			//データベースに接続
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/kensyu");
			db = ds.getConnection();

			//データベース検索
			String sql = "SELECT employee_id FROM tb_employee_info WHERE employee_id='" + employee_id + "';";
			ps = db.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			//エラー表示
			if((employee_id == "") || (employee_name == "") || (department == "") || (password == "")) {

				if(employee_id == "") { request.setAttribute("NulId", Common.NulId); }
				else if(!Common.IdMatch(employee_id)) { request.setAttribute("IdmissMatch", Common.IdMiss); }

				if(employee_name == "") { request.setAttribute("NulName", Common.NulName); }
				else if(!Common.NameMatch(employee_name)) { request.setAttribute("NamemissMatch", Common.NameMiss); }

				if(department == "") { request.setAttribute("NulDep", Common.NulDep); }
				if(password == "") { request.setAttribute("NulPass", Common.NulPass); }
				if(rs.next()) { request.setAttribute("err", Common.IdErr); }

				getServletContext().getRequestDispatcher("/RegProfile.jsp").forward(request,response);

			//入力されたIDがすでに登録されている場合
			} else if(rs.next()) {
				request.setAttribute("err", Common.IdErr);
				getServletContext().getRequestDispatcher("/RegProfile.jsp").forward(request,response);

			//社員番号正規表現
			} else if(!Common.IdMatch(employee_id)){
				request.setAttribute("err", Common.IdMiss);
				getServletContext().getRequestDispatcher("/RegProfile.jsp").forward(request,response);

			//社員名正規表現
			} else if(!Common.NameMatch(employee_name)){
				request.setAttribute("err", Common.NameMiss);
				getServletContext().getRequestDispatcher("/RegProfile.jsp").forward(request,response);

			} else {

				//入力された値をデータベースに登録
				ps = db.prepareStatement("INSERT INTO tb_employee_info(employee_id, employee_name, department, post, entry_date, password, admin_level, regist_user, delete_flg) VALUES(? ,? ,? ,? ,? ,? ,? ,? ,?)");

				ps.setString(1, employee_id);
				ps.setString(2, employee_name);
				ps.setString(3, department);

				if((post == null) || (post == "")) {
					ps.setString(4, null);
				} else {
					ps.setString(4, post);
				}

				//日付正規表現
				if(!Common.DateMatch(entry_date) && (entry_date != null) && (entry_date != "")) {
					request.setAttribute("err", Common.MisErr);
					getServletContext().getRequestDispatcher("/RegProfile.jsp").forward(request,response);
				} else if((entry_date != null) && (entry_date != "")) {
					//文字列entry_dateをDate型に変換
				  	Date date = Date.valueOf(entry_date);
					ps.setDate(5, date);
				} else {
					ps.setDate(5, null);
				}

				ps.setString(6, password);
				ps.setInt(7, admin_level);
				ps.setString(8, regist_user);
				ps.setInt(9, Common.Active);
				ps.executeUpdate();

				//登録メッセージ
				session.setAttribute("Add", Common.AddMsg);

			}

			ps.close();
			db.close();

		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			//入力されたIDがすでに登録されている場合
			/*request.setAttribute("err", Common.IdErr);
			getServletContext().getRequestDispatcher("/RegProfile.jsp").forward(request,response);*/
			e.printStackTrace();
		}


		//Listサーブレットにリダイレクト
		response.sendRedirect("List");
	}

}
