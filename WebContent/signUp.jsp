<%@page import="java.util.regex.Pattern" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
  <meta charset="utf-8">
  <title>jQuery UI Datepicker - Default functionality</title>
  <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
  <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
  <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script>
  $(function() {
    $( "#datepicker" ).datepicker();
  });
  </script>
</head>
<body>
<form action ="insertMember.jsp" method="post">
	<center>
	<table border="1" width="30%" cellpadding="5">
	<thead>
	<tr>
	<th colspan="2">회원가입</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td>아이디</td>
		<td><input type="text" name="mem_id" /></td>
	</tr>
	<tr>
		<td>비밀번호</td>
		<td><input type="text" name="mem_pw"  /></td>
	</tr>
	<tr>
		<td>이름</td>
		<td><input type="text" name="mem_name" /></td>
	</tr>
	<tr>
		<td>성별</td>
		<td><input type="text" name="mem_sex" /></td>
	</tr>
	<tr>
		<td>생일</td>
		<td><input type="text" name="mem_birthday"/></td>
	</tr>
	<tr>
		<td>전화번호</td>
		<td><input type="text" name="mem_number" /></td>
	</tr>
	<tr>
		<td>모바일</td>
		<td><input type="text" name="mem_mobilenumber"/></td>
	</tr>
	<tr>
		<td>주소</td>
		<td><input type="text" name="mem_address"/></td>
	</tr>
	<tr>
		<td>Email</td>
		<td><input type="text" name="mem_email"/></td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" value="가입" /></td>
	</tr>
	<tr>
		<td colspan="2">이미 회원이세요? <a href="login.jsp">로그인</a></td>
	</tr>
	</tbody>
	</table>
	</center>

</body>
</html>