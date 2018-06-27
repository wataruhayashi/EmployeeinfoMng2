package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import beans.Tb_employee_info;

@WebServlet("/Query")
public class Query extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		Connection db = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		//入力された値を変数に代入
		String id = request.getParameter("employee_id");
		String name = request.getParameter("employee_name");
		String dep = request.getParameter("department");

		//ビーンズ型のArrayList変数を生成
		ArrayList<Tb_employee_info> list = new ArrayList<Tb_employee_info>();

		try {

				//データベース接続
				Context context = new InitialContext();
				DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/kensyu");
				db = ds.getConnection();

				//データベース検索
				String sql = "SELECT * FROM tb_employee_info WHERE 1 = 1";

				//社員番号が入力された場合
				if(id != "") {
					sql += " AND employee_id= BINARY '" + id + "'";
				}
				//社員名が入力された場合
				if(name != "") {
					sql += " AND employee_name LIKE BINARY '" + name + "%'";
				}
				//所属が入力された場合
				if(dep !="") {
					sql += " AND department= BINARY '" + dep + "'";
				}

				ps = db.prepareStatement(sql);
				rs = ps.executeQuery();


				//データをビーンズに格納
				while(rs.next()) {
					Tb_employee_info info = new Tb_employee_info();
					info.setEmployee_id(rs.getString("employee_id"));
					info.setEmployee_name(rs.getString("employee_name"));
					info.setDepartment(rs.getString("department"));
					info.setPost(rs.getString("post"));
					info.setEntry_date(rs.getDate("entry_date"));
					info.setPassword(rs.getString("password"));
					info.setAdmin_level(rs.getInt("admin_level"));
					list.add(info);
				}
				rs.close();
				ps.close();
				db.close();




		}catch(NamingException e) {
			e.printStackTrace();
		}catch(SQLException e) {
			e.printStackTrace();
		}
		//list属性に値をセット
		request.setAttribute("list", list);
		//EmpinfoList.jspにリクエストとレスポンスをフォワード
		getServletContext().getRequestDispatcher("/EmpinfoList.jsp").forward(request,response);

	}
}
