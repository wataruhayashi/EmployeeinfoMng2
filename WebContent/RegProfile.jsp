<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, javax.naming.*,javax.sql.*,util.Common"%>
<%
//キャッシュ削除
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
String NulId =(String)request.getAttribute("NulId");
if(NulId == null){NulId = "";}
String NulName =(String)request.getAttribute("NulName");
if(NulName == null){NulName = "";}
String NulDep =(String)request.getAttribute("NulDep");
if(NulDep == null){NulDep = "";}
String NulPass =(String)request.getAttribute("NulPass");
if(NulPass == null){NulPass = "";}
String IdmissMatch =(String)request.getAttribute("IdmissMatch");
if(IdmissMatch == null){IdmissMatch = "";}
String NamemissMatch =(String)request.getAttribute("NamemissMatch");
if(NamemissMatch == null){NamemissMatch = "";}
//登録履歴表示
String employee_id = request.getParameter("employee_id");
if(employee_id == null || !Common.IdMatch(employee_id)){employee_id = "";}
String employee_name = request.getParameter("employee_name");
if(employee_name == null || !Common.NameMatch(employee_name)){employee_name = "";}
String department = request.getParameter("department");
if(department == null){department = "";}
String post = request.getParameter("post");
if(post == null){post = "";}
String entry_date = request.getParameter("entry_date");
if(entry_date == null){entry_date = "";}
String password = request.getParameter("password");
if(password == null){password = "";}
String oz = request.getParameter("admin_level");
if(oz == null){ oz = "0"; }
Integer admin_level = Integer.parseInt(oz);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="css/add.css" />
	<title>社員登録</title>
</head>

<body>
	<form method="post" action="Logout">
		<h1><a href="Menu.jsp">社員情報管理システム</a></h1>
		<div id="yuza">
			ログインユーザー氏名：<span class="yu"><%= yuza %></span>
			<input type="submit" value="ログアウト" class="square_btn2">
		</div>
		<h2>社員登録</h2>
	</form>

	<form method="post" action="Add" id="input">
		<div class="err"><%= err %></div>
		<div class="err"><%= IdmissMatch %></div>
		<div class="err"><%= NamemissMatch %></div>
		<div class="err"><%= NulId %></div>
		<div class="err"><%= NulName %></div>
		<div class="err"><%= NulDep %></div>
		<div class="err"><%= NulPass %></div>

		<%
		//tb_departmentテーブルに接続
		request.setCharacterEncoding("UTF-8");
		Context context = new InitialContext();
		DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/kensyu");
		Connection db = ds.getConnection();
		PreparedStatement ps = db.prepareStatement("SELECT department FROM tb_department");
		ResultSet rs = ps.executeQuery();
		%>

		<div id="input_text">
			<label>社員番号<span style="color:red;">＊</span><br />
				<input type="text" name="employee_id" value="<%= employee_id %>" size=50 maxlength=5 id="input_border"/>
			</label>
		</div>

		<div id="input_text">
			<label>社員氏名<span style="color:red;">＊</span><br />
				<input type="text" name="employee_name" value="<%= employee_name %>" size=50 maxlength=20 id="input_border"/>
			</label>
		</div>

		<div id="input_text">
			<label>所属<span style="color:red;">＊</span><br />
				<select name="department" id="input_border"style="width:380px;">
				<% while(rs.next()) { //全データを表示 %>
				<option value="<%= rs.getString("department") %>">
				<%= rs.getString("department") %>
				</option>
				<% }
					rs.close();
					ps.close();
					db.close();
				%>
			</select>
			</label>
		</div>

		<div id="input_text">
			<label>役職<br />
				<input type="text" name="post" value="<%= post %>" size=50 maxlength=255 id="input_border"/>
			</label>
		</div>

		<div id="input_text">
			<label>入社日<br />
				<input type="date" name="entry_date" value="<%= entry_date %>" id="input_border"/>
			</label>
		</div>

		<div id="input_text">
			<label>パスワード<span style="color:red;">＊</span><br />
				<input type="password" name="password" value="<%= password %>" size=50 maxlength=255 id="input_border"/>
			</label>
		</div>


		<div id="input_text">
			<label>管理権限<br />
				<select name="admin_level" id="input_border">
				<option value="<%= Common.AUTH_GENE %>" <% if(admin_level == Common.AUTH_GENE){ %> selected <% } %>>閲覧のみ</option>
				<option value="<%= Common.AUTH_MANE %>" <% if(admin_level == Common.AUTH_MANE){ %> selected <% } %>>登録編集可</option>
				</select>
			</label>
		</div>

		<div>
			<input type="submit" value="登 録" class="square_btn2"
				onclick="return confirm('登録を行いますが、よろしいですか？')"/>
		</div>

	</form>

	<div id="input">
		<a href="List"><button class="square_btn2">キャンセル</button></a>
	</div>

</body>
</html>