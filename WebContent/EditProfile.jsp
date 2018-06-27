<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.sql.*,javax.naming.*,javax.sql.*,util.Common"%>
<%
//キャッシュを削除
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", 0);

if(session.getAttribute("id") == null) {
	request.setAttribute("err", Common.BackErr);
	//Login.jspにリクエストとレスポンスをフォワード
	getServletContext().getRequestDispatcher("/Login.jsp").forward(request,response);
}

//ユーザ名
String yuza = (String)session.getAttribute("name");
//エラー表示
String err =(String)request.getAttribute("err");
if(err == null){err = "";}
String NulName =(String)request.getAttribute("NulName");
if(NulName == null){NulName = "";}
String NulDep =(String)request.getAttribute("NulDep");
if(NulDep == null){NulDep = "";}
String NulPass =(String)request.getAttribute("NulPass");
if(NulPass == null){NulPass = "";}
//ログインしたemployee_idセッションを変数に代入
String id = (String)session.getAttribute("id");
//tb_employee_infoテーブルに接続
request.setCharacterEncoding("UTF-8");
Context context = new InitialContext();
DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/kensyu");
Connection db = ds.getConnection();
PreparedStatement ps = db.prepareStatement("SELECT * FROM tb_employee_info WHERE employee_id= ?");
ps.setString(1,request.getParameter("employee_id"));
ResultSet rs = ps.executeQuery();
if(rs.next()){
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="css/add.css" />
	<title>社員変更</title>
</head>
<body>

	<form method="post" action="Logout">
		<h1><a href="Menu.jsp">社員情報管理システム</a></h1>
		<div id="yuza">
			ログインユーザー氏名：<span class="yu"><%= yuza %></span>
			<input type="submit" value="ログアウト" class="square_btn2">
		</div>
		<h2>社員変更</h2>
	</form>

	<form method="post" action="Edit" id="input">
		<div class="err"><%= err %></div>
		<div class="err"><%= NulName %></div>
		<div class="err"><%= NulDep %></div>
		<div class="err"><%= NulPass %></div>

		<div id="input_text">
			<label>社員番号<span style="color:red;">＊</span><br />
				<input type="text" name="employee_id" value="<%= rs.getString("employee_id") %>" size="50" maxlength="255" style="background-color:gray;"readonly/>
			</label>
		</div>

		<div id="input_text">
			<label>社員氏名<span style="color:red;">＊</span><br />
				<input type="text" name="employee_name" value="<%= rs.getString("employee_name") %>" size="50" maxlength="255" id="input_border"/>
			</label>
		</div>

		<%
		//tb_departmentテーブルに接続
		PreparedStatement ps2 = db.prepareStatement("SELECT department FROM tb_department");
		ResultSet rs2 = ps2.executeQuery();
		%>

		<div id="input_text">
			<label>所属<span style="color:red;">＊</span><br />
				<select name="department" id="input_border"style="width:380px;">
				<% while(rs2.next()) { %>
				<option value="<%= rs2.getString("department") %>"<% if(rs2.getString("department").equals(rs.getString("department"))){ %> selected <% } %>>
				<%= rs2.getString("department") %>
				</option>
				<% }
					rs2.close();
					ps2.close();
				%>
				</select>
			</label>
		</div>

		<%
		String str;
		if(rs.getString("post") == null){
			str = "";
		}else{
			str = rs.getString("post");
		}
		%>

		<div id="input_text">
			<label>役職<br />
				<input type="text" name="post" value="<%= str %>" size=50 maxlength=255 id="input_border"/>
			</label>
		</div>

		<div id="input_text">
			<label>入社日<br />
				<input type="date" name="entry_date" value="<%= rs.getString("entry_date") %>" id="input_border">
			</label>
		</div>

		<div id="input_text">
			<label>パスワード<span style="color:red;">＊</span><br />
				<input type="password" name="password" value="<%= rs.getString("password") %>" size=50 maxlength=255 id="input_border"/>
			</label>
		</div>

		<div id="input_text">
			<label>管理権限<br />
				<select name="admin_level" id="input_border">
				<option value="<%= Common.AUTH_GENE %>"<% if(rs.getInt("admin_level")== Common.AUTH_GENE ){ %> selected <% } %>>閲覧のみ</option>
				<option value="<%= Common.AUTH_MANE %>"<% if(rs.getInt("admin_level")== Common.AUTH_MANE ){ %> selected <% } %>>登録編集可</option>
				</select>
			</label>
		</div>

		<div>
				<input type="submit" name="update" value="更新"
					onclick="return confirm('変更を行いますが、よろしいですか？')" class="square_btn2"/>
			<% if(!(id.equals(rs.getString("employee_id")))){ %>
				<input type="submit" name="delete" value="削除"
					onclick="return confirm('削除を行いますが、よろしいですか？')" class="square_btn2" />
			<% } %>
		</div>

	</form>

	<div id="input">
		<a href="List"><button class="square_btn2">キャンセル</button></a>
	</div>
</body>
</html>
<%
rs.close();
ps.close();
db.close();
} else {out.println("データなし");}
%>