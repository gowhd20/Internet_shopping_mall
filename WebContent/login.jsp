
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>로그인</title>
</head>
<body>
<form action="loginProcess.jsp" method="post">
<center>
	<center>
아이디	<input type="text" name="mem_id" size="40"/>
비밀번호<input  type="password" name="mem_pw" size="40"/>

<td><input type="submit" value="로그인"/></td>
<br><td colspan="2">아직 회원이 아니세요? <a href="signUp.jsp">회원가입</a>
	</center>
	
</center>
</form>
</body>
</html>