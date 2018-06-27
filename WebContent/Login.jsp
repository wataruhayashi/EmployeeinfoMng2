<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//エラー表示
String err = (String)request.getAttribute("err");
if(err == null){err = "";}
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="css/log.css">
	
	<title>ログイン画面</title>
</head>

<body>
	<form method="post" action="Login">
		<div id="log"><h2>ログイン</h2></div><br/>
		
		<div class="err"><%= err %></div>
		
		<div id="log">
			<span>社員番号</span><br/>
			<input type="text" name="loginId" size="50" id="input_text">
		</div>
		
		<div id="log">
			<span>パスワード</span><br/>
			<input type="password" name="loginPass" size="50" id="input_text">
		</div>
		
		<div id="log">
		   <input type="submit" value="ログイン"class="square_btn">
		</div>
	</form>
</body>
</html>