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
	<!-- <link rel="stylesheet" type="text/css" href="css/add.css" />
	<script type="text/javascript" src="js/alert.js"></script> -->
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="http://icono-49d6.kxcdn.com/icono.min.css">
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
	<title>社員変更</title>
</head>
<body>


	<!-------------------------------------- ヘッダー------------------------------------->

	<header class="bg-info mb-2 text-light fixed-top">
		<nav class="navbar navbar-light">
			<ul class="nav float-left">
				<li class="navbar-brand">
					<h5><a href="List" class="nav-link active text-light">社員情報管理システム</a></h5>
				</li>
				<li class="navbar-brand">
					<a href="List" class="nav-link text-light">社員一覧</a>
				</li>
				<li class="navbar-brand">
					<a href="RegDept.jsp" class="nav-link text-light">部署登録</a>
				</li>
			</ul>
			<ul class="float-right">
				<form method="post" action="Logout">
						<i class="icono-user mr-2"></i><%=yuza%>
						<i class="icono-signOut ml-4"></i><input type="submit" value="ログアウト" class="btn btn-info">
				</form>
			</ul>
		</nav>
	</header>

	<!--------------------------------------メイン------------------------------------->

	<main class="w-50 mr-auto ml-auto sukima">

		<div class="mt-5 mb-5">
			<h4 class="bdr">社員変更</h4>
		</div>


		<form method="post" action="Edit">

		<!-------------------------エラー表示---------------------->

		<%
		String err =(String)request.getAttribute("err");
		String NulName =(String)request.getAttribute("NulName");
		String NulDep =(String)request.getAttribute("NulDep");
		String NulPass =(String)request.getAttribute("NulPass");
		%>

		<% if((err != null) || (NulName != null) || (NulDep != null) || (NulPass != null)) { %>
		<div class="alert alert-danger text-center" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">&times;</span>
	  		</button>
			<% if(err != null) { %>
				<div><%= err %></div>
			<% } %>
			<% if(NulName != null) { %>
				<div><%= NulName %></div>
			<% } %>
			<% if(NulDep != null) { %>
				<div><%= NulDep %></div>
			<% } %>
			<% if(NulPass != null) { %>
				<div><%= NulPass %></div>
			<% } %>
		</div>
		<% } %>

		<!-------------------------入力フォーム---------------------->


			<div class="form-group row">
				<label class="col-3 col-form-label text-center">社員番号<span class="text-danger">＊</span></label>
				<div class="col-7">
					<input type="text" name="employee_id" value="<%= rs.getString("employee_id") %>"  class="form-control" readonly/>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-3 col-form-label text-center">社員氏名<span class="text-danger">＊</span></label>
				<div class="col-7">
					<input type="text" name="employee_name" value="<%= rs.getString("employee_name") %>" maxlength="20" class="form-control"/>
				</div>
			</div>

			<%
			//tb_departmentテーブルに接続
			PreparedStatement ps2 = db.prepareStatement("SELECT department FROM tb_department");
			ResultSet rs2 = ps2.executeQuery();
			%>

			<div class="form-group row">
				<label class="col-3 col-form-label text-center">所属<span class="text-danger">＊</span></label>
				<div class="col-7">
					<select name="department" class="form-control">
					<% while(rs2.next()) { %>
					<option value="<%= rs2.getString("department") %>"<% if(rs2.getString("department").equals(rs.getString("department"))){ %> selected <% } %>>
					<%= rs2.getString("department") %>
					</option>
					<% }
						rs2.close();
						ps2.close();
					%>
					</select>
				</div>
			</div>

			<%
			String str;
			if(rs.getString("post") == null){
				str = "";
			}else{
				str = rs.getString("post");
			}
			%>

			<div class="form-group row">
				<label class="col-3 col-form-label text-center">役職</label>
				<div class="col-7">
					<input type="text" name="post" value="<%= str %>" maxlength=20 class="form-control"/>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-3 col-form-label text-center">入社日</label>
				<div class="col-7">
					<input type="date" name="entry_date" value="<%= rs.getString("entry_date") %>" class="form-control"/>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-3 col-form-label text-center">パスワード<span class="text-danger">＊</span></label>
				<div class="col-7">
					<input type="password" name="password" value="<%= rs.getString("password") %>" maxlength=20 class="form-control"/>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-3 col-form-label text-center">管理権限</label>
				<div class="col-7">
					<select name="admin_level" class="form-control">
					<option value="<%= Common.AUTH_GENE %>"<% if(rs.getInt("admin_level")== Common.AUTH_GENE ){ %> selected <% } %>>閲覧のみ</option>
					<option value="<%= Common.AUTH_MANE %>"<% if(rs.getInt("admin_level")== Common.AUTH_MANE ){ %> selected <% } %>>登録編集可</option>
					</select>
				</div>
			</div>

			<div class="form-group row">
			<div class="col-3"></div>

				<div class="col-2">
						<input type="submit" name="update" value="更新" class="btn btn-primary btn-block"
							onclick="return confirm('変更を行いますが、よろしいですか？')"/>
				</div>

				<% if(!(id.equals(rs.getString("employee_id")))){ %>
				<div class="col-2">
					<input type="submit" name="delete" value="削除" class="btn btn-danger btn-block"
						onclick="return confirm('削除を行いますが、よろしいですか？')" />
				</div>
				<% } %>

				<div class="col-3">
					<a href="List"><input type="button" class="btn btn-light btn-block" value="キャンセル"></a>
				</div>
			</div>

		</form>

	</main>


<!------------スタイル--------------->
<style>
.bdr {
	border-left: 15px solid #17a2b8;
	border-bottom:1px solid #17a2b8;
}

.sukima {
	padding-top:10px;
  	margin-top:50px;
}

</style>

</body>
</html>
<%
rs.close();
ps.close();
db.close();
} else {out.println("データなし");}
%>