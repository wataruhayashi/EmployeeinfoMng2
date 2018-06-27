<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="util.Common"%>
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
//登録履歴表示
String busyo = request.getParameter("department");
if(busyo == null || !Common.NameMatch("busyo")){ busyo = ""; }
//エラー表示
String err = (String)request.getAttribute("err");
if(err == null){err = "";}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="css/add.css" />
	<title>部署登録</title>
</head>
<body>
	<form method="post" action="Logout">
		<h1><a href="Menu.jsp">社員情報管理システム</a></h1>
		<div id="yuza">
			ログインユーザ名：<span class="yu"><%= yuza %></span>
				<input type="submit" value="ログアウト" class="square_btn2">
		</div>
		<h2>部署登録</h2>
	</form>

	<form method="post" action="AddDept">

		<div style="color:red;text-align:center;">
			<%= err %>
		</div>

		<div id="busyo">
			<label>部署名</label>
			<input type="text" name="department" value="<%= busyo %>" id="input_border">
		</div>

		<div>
			<input type="submit" value="登録" class="square_btn" id="butn1">
		</div>

	</form>

	<div>
		<a href="Menu.jsp"><input type="button" value="キャンセル" class="square_btn"id="butn2"></a>
	</div>

</body>
</html>