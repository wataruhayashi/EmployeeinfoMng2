<%@ page contentType="text/html; charset=UTF-8"
	import="beans.Tb_employee_info, java.sql.*, javax.naming.*, javax.sql.*, java.text.*, util.Common"%>
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
//アクセス権限表示
Integer hyoji =(Integer)session.getAttribute("hyoji");
//入力された社員番号を変数に代入
String id = (String)request.getParameter("employee_id");
if(id == null || !Common.IdMatch(id)){ id = ""; }
//入力された社員名を変数に代入
String name = (String)request.getParameter("employee_name");
if(name == null || !Common.NameMatch(name)){ name = ""; }
//エラー表示
String nulErr = (String)request.getAttribute("nulErr");
if(nulErr == null){nulErr ="";}

SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
%>

<jsp:useBean id="list" class="java.util.ArrayList" scope="request" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" />
	<link rel="stylesheet" type="text/css" href="css/main.css" />
	<link href="https://fonts.googleapis.com/earlyaccess/nikukyu.css" rel="stylesheet" />
	<title>社員一覧</title>
</head>

<body>
	<form method="post" action="Logout">
		<h1><a href="Menu.jsp">社員情報管理システム</a></h1>
		<div id="yuza">
			ログインユーザ名：<span class="yu"><%=yuza%></span>
				<input type="submit" value="ログアウト" class="square_btn2">
		</div>
		<h2 class="wf-nikukyu">社員一覧</h2>
	</form>

<%
//tb_departmentテーブルに接続
request.setCharacterEncoding("UTF-8");
Context context = new InitialContext();
DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/kensyu");
Connection db = ds.getConnection();
PreparedStatement ps = db.prepareStatement("SELECT department FROM tb_department");
ResultSet rs = ps.executeQuery();
%>
	<form method="post" action="Query" class="kensaku">
		<label id="ken">社員情報検索</label><br>
		<div class="border1">
			<span id="name">社員番号</span><input type="text" size="40" name="employee_id" value="<%= id %>"id="input_text">
			<span id="name">社員名</span><input type="text" size="40" name="employee_name" value="<%= name %>"id="input_text"><br>
			<span id="name">所属</span>
			<select name="department" id="input_text" style="width:800px;">
				<% while(rs.next()) { //全データを表示 %>
					<option value="<%= rs.getString("department") %>">
					<%= rs.getString("department") %>
					</option>
				<% }
					rs.close();
					ps.close();
					db.close();
				%>
			</select><br/>

			<input type="submit" value="検索" class="square_btn">
		</div>
	</form>

	<div class="border2">
		<form method="post" action="RegProfile.jsp">
			<div class="touroku">
			<% if(hyoji != Common.AUTH_GENE){ //アクセス権限表示 %>
				<input type="submit" value="新規登録" class="square_btn2">
			<% } %>
			</div>
		</form>

			<table class="tbe">
				<tr>
					<th>社員番号</th><th>社員名</th><th>所属</th><th>役職</th><th>入社日</th>
					<% if(hyoji != Common.AUTH_GENE){ //アクセス権限表示 %>
						<th></th>
					<% } %>
				</tr>

				<% for(Object item : list) {
					Tb_employee_info info = (Tb_employee_info)item; %>
				<tr>
					<td><%= info.getEmployee_id() %></td>
					<td><%= info.getEmployee_name() %></td>
					<td><%= info.getDepartment() %></td>
						<% String str = "-"; %>
						<% if(info.getPost()== null){ %>
							<td><%= str %></td>
						<% } else { %>
							<td><%= info.getPost() %></td>
						<% } %>


						<% if(info.getEntry_date() == null){ %>
							<td><%= str %></td>
						<% } else { %>
							<td><%= sdf.format(info.getEntry_date()) %></td>
						<% } %>

						<% if(hyoji != Common.AUTH_GENE){//アクセス権限表示 %>
							<td><a href="EditProfile.jsp?employee_id=<%= info.getEmployee_id() %>"><button class="square_btn2">変更</button></a></td>
						<% } %>
				</tr>
				<% } %>
			</table>
		</div>
</body>
</html>
