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
//ユーザ名表示
String yuza = (String)session.getAttribute("name");
//アクセス権限表示
Integer hyoji =(Integer)session.getAttribute("hyoji");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="css/main.css" />
	<title>メニュー</title>
</head>
<body>
	<form method="post" action="Logout">
		<h1><a href="Menu.jsp">社員情報管理システム</a></h1>
		<div id="yuza">
			ログインユーザ名：<span class="yu"><%= yuza %></span>
				<input type="submit" value="ログアウト" class="square_btn2">
		</div>
		<h2>メニュー</h2>
	</form>



	<div id="input_text" style="margin-left:470px;" class="wf-kokoro">
		<a href="List"><input type="button" value="社員一覧" class="square_btn"></a>
	</div>
	
	<% if(hyoji != Common.AUTH_GENE){//アクセス権限表示 %>
		<div id="input_text" style="margin-left:470px;" class="wf-kokoro">
			<a href="RegDept.jsp"><input type="button" value="部署登録" class="square_btn"></a>
		</div>
	<% } %>
</body>
</html>