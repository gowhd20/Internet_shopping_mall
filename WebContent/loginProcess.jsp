<%@page import="java.util.regex.Pattern" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%

	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Connection con = null; 
	String url = "jdbc:oracle:thin:@localhost:1521:XE";
	//String message="";
	
	String mem_id = request.getParameter("mem_id");
	String mem_pw = request.getParameter("mem_pw");
  	
  try{
	  Class.forName("oracle.jdbc.driver.OracleDriver");
	  con = DriverManager.getConnection(url, "haejong", "0000");
	  con.setAutoCommit(true);
	  out.println("Oracle Database Connection Success.");
	  String query = "select * from member where mem_id=? and mem_pw=?";
	  
	    pstmt = con.prepareStatement(query);
 		pstmt.setString(1, mem_id);
 		pstmt.setString(2, mem_pw);
 		rs = pstmt.executeQuery();
 		
 		if(rs.next()){
 			session.setAttribute("mem_id", rs.getString("mem_id"));
 			session.setAttribute("mem_pw", rs.getString("mem_pw"));
 			//System.out.print(rs.getString("mem_id"));
			%>
			<script>
				alert("로그인성공");
				location.href("index.jsp");
			</script>
		<%
 			//message="User login successfully";
 			//response.sendRedirect("login.jsp?error="+message);
 		}
 		else {
 			//message="No user or password matched";
				%>
			<script>
				alert("아이디가 존지하지 않거나 비밀번호가 일치하지 않습니다");
				location.href("login.jsp");
			</script>
			<%
 			//response.sendRedirect("login.jsp?error="+message);
 		}
  	}catch (Exception e){
 			e.printStackTrace();
 		}
  
  try{
	  if(rs != null){
		  rs.close();
	  }
	  if(pstmt != null){
		  pstmt.close();
	  }
	  if(con != null){
		  con.close();
	  }
  }catch (Exception e){
	  e.printStackTrace();
  }
 		%>	
</body>
</html>