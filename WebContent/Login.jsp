<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<!-- Bootstrap CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
    <title>ログイン画面</title>
</head>

<body>

<!-------------------------------------- ヘッダー------------------------------------->

	<header class="bg-info p-3 mb-5">
		<div>
				<h5 class=" text-white text-sm-left">社員情報管理システム</h5>
		</div>
	</header>


<!-------------------------------------- メイン------------------------------------->

	<main class="container bg-light form-control w-50">
		<form method="post" action="Login">

		<!-------------------------エラー表示---------------------->

		<% String err = (String)request.getAttribute("err"); %>
		<% if(err != null) { %>
			<div class="alert alert-danger form-control text-center" role="alert">
				<%= err %>
				<button type="button" class="close" data-dismiss="alert" aria-label="Close">
					<span aria-hidden="true">&times;</span>
	  			</button>
    		</div>
    	<% } %>

		<!-------------------------入力フォーム---------------------->

			<div class="form-group">
				<label for="employee_id">社員番号</label>
				<input type="text" name="loginId" class="form-control">
			</div>

			<div class="form-group">
				<label>パスワード</label>
				<input type="password" name="loginPass" class="form-control">
			</div>

			<div class="form-group">
			   <input type="submit" value="ログイン" class="btn btn-block btn-info mb-3 mt-1">

			</div>

		</form>
	</main>

</body>
</html>