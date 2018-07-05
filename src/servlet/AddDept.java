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
import javax.sql.DataSource;

import util.Common;

@WebServlet("/AddDept")
public class AddDept extends HttpServlet {
	private static final long serialVersionUID = 1L;


    public AddDept() {
        super();
    }

    @SuppressWarnings("resource")
	public void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

    	request.setCharacterEncoding("UTF-8");

    	Connection db = null;
		PreparedStatement ps =null;

		//入力された値を変数に代入
		String dep = (String)request.getParameter("department");

		try {

			//データベースに接続
			Context context = new InitialContext();
			DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/kensyu");
			db = ds.getConnection();

			//データベース検索
			ps = db.prepareStatement("SELECT department FROM tb_department WHERE department='" + dep + "'");
			ResultSet rs = ps.executeQuery();

			//エラー表示
			if((dep == "")) {
				//未入力の場合
				request.setAttribute("err",Common.NulErr);
				getServletContext().getRequestDispatcher("/RegDept.jsp").forward(request,response);
			}else if(rs.next()) {
				//入力された所属がすでに登録されている場合
				request.setAttribute("err", Common.DepErr);
				getServletContext().getRequestDispatcher("/RegDept.jsp").forward(request,response);
			}else {
				//入力された値をデータベースに登録
				ps = db.prepareStatement("INSERT INTO tb_department(department) VALUES('" + dep + "')");
				ps.executeUpdate();

			}
			rs.close();
			ps.close();
			db.close();

		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		response.sendRedirect("List");
	}
}
