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
//アクセス権限表示
Integer hyoji =(Integer)session.getAttribute("hyoji");
//入力された社員番号を変数に代入
String id = (String)request.getParameter("employee_id");
if(id == null || !Common.IdMatch(id)){ id = ""; }
//入力された社員名を変数に代入
String name = (String)request.getParameter("employee_name");
if(name == null || !Common.NameMatch(name)){ name = ""; }

SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
%>

<jsp:useBean id="list" class="java.util.ArrayList" scope="request" />
<jsp:include page="header.jsp" flush="true" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" />
	<!-- Bootstrap CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
	<link rel="stylesheet" href="http://icono-49d6.kxcdn.com/icono.min.css">
	<script type="text/javascript" src="js/clr.js"></script>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
	<title>社員一覧</title>
</head>

<body>

<%-- <!-------------------------------------- ヘッダー------------------------------------->

	<header class="bg-info mb-2 text-light fixed-top">
		<nav class="navbar navbar-light">
			<ul class="nav">
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
			<ul class="nav">
				<form method="post" action="Logout">
						<i class="icono-user mr-2"></i><%= yuza %>
						<i class="icono-signOut ml-4"></i><input type="submit" value="ログアウト" class="btn btn-info">
				</form>
			</ul>
		</nav>
	</header>

 --%>
<!--------------------------------------メイン------------------------------------->

	<main class="w-75 mr-auto ml-auto sukima">

		<div class="mt-5 mb-5">
			<h4 class="bdr">社員情報一覧</h4>
		</div>

		<!-------------------------処理完了メッセージ---------------------->
		<%
		String edit = (String)session.getAttribute("Edit");
		String del = (String)session.getAttribute("Del");
		String add = (String)session.getAttribute("Add");
		%>

		<% if(edit != null) { %>
			<div class="alert alert-success  alert-dismissible fade show text-center" role="alert">
				<button type="button" class="close" data-dismiss="alert" aria-label="Close">
	   				<span aria-hidden="true">&times;</span>
	  			</button><%= edit %>
  			</div>
		<% } %>
		<% if(del != null) { %>
			<div class="alert alert-success text-center" role="alert">
				<button type="button" class="close" data-dismiss="alert" aria-label="Close">
		   			<span aria-hidden="true">&times;</span>
		  		</button><%= del %>
			</div>
		<% } %>
		<% if(add != null) { %>
			<div class="alert alert-success text-center" role="alert">
				<button type="button" class="close" data-dismiss="alert" aria-label="Close">
	   				<span aria-hidden="true">&times;</span>
	  			</button><%= add %>
			</div>
		<% } %>

		<%
		session.removeAttribute("Edit");
		session.removeAttribute("Del");
		session.removeAttribute("Add");
		%>


		<!-------------------------検索--------------------->
		<%
		//tb_departmentテーブルに接続
		request.setCharacterEncoding("UTF-8");
		Context context = new InitialContext();
		DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/kensyu");
		Connection db = ds.getConnection();
		PreparedStatement ps = db.prepareStatement("SELECT department FROM tb_department");
		ResultSet rs = ps.executeQuery();
		%>

		<div class="form-control bg-light">
			<form method="post" action="Query" name="ken">

				<div class="form-group row pt-2">

					<label class="col-2 col-form-label text-center">社員番号</label>
					<div class="col-4">
						<input type="text" name="employee_id" value="<%= id %>" class="form-control">
					</div>

					<label class="col-2 col-form-label text-center">社員名</label>
					<div class="col-4">
						<input type="text" name="employee_name" value="<%= name %>" class="form-control">
					</div>

				</div>

				<div class="form-group row">

					<label class="col-2 col-form-label text-center">所属</label>
					<div class="col-4">
						<select name="department" class="form-control">
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
					</div>

					<div class="col-2"></div>

					<div class="col-2">
						<input type="submit" value="検索" class="col-auto form-control bg-dark text-light">
					</div>
					<div class="col-2">
						<label class="col-auto form-control bg-secondary text-center text-light" onClick="clr()">クリア</label>
						<!-- <input type="reset" value="クリア" class="col-auto form-control bg-secondary text-light"> -->
					</div>

				</div>

			</form>
		</div>

		<!---------------------新規登録ボタン----------------->

		<div class="mt-2 mb-5 mr-3">
			<form method="post" action="RegProfile.jsp">
				<% if(hyoji != Common.AUTH_GENE){ //アクセス権限表示 %>
					<input type="submit" value="新規登録" class="btn btn-primary float-right pr-4 pl-4">
				<% } %>
			</form>
		</div>


		<!-------------------------テーブル---------------------->

		<div>
			<table class="table table-striped  table-hover text-center m-auto">

				<tr class="bg-secondary">
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
							<td><a href="EditProfile.jsp?employee_id=<%= info.getEmployee_id() %>"><button class="btn btn-dark btn-block">変更</button></a></td>
						<% } %>
				</tr>
				<% } %>
			</table>
		</div>
	</main>


</body>
</html>
