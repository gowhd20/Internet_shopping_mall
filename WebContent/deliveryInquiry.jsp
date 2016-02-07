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
<%
PreparedStatement pstmt = null;
ResultSet rs = null;
Connection con = null; 
String mem_id = session.getAttribute("mem_id").toString();
String[] enterprise_name;
String[] enterprise_number;
String mem_mobilenumber = "";
String[] addressee_name;
String[] addressee_number;
int count = 0;

try{
	String url = "jdbc:oracle:thin:@localhost:1521:XE";
	Class.forName("oracle.jdbc.driver.OracleDriver");
	con = DriverManager.getConnection(url, "haejong", "0000");
	con.setAutoCommit(true);
	out.println("Oracle Database Connection Success.");
	
	String countQuery = "select count(*) from addressee where mem_id = ?";
	pstmt = con.prepareStatement(countQuery);
	pstmt.setString(1, mem_id);
	rs = pstmt.executeQuery();
	rs.next();
	count = rs.getInt(1);
	
	enterprise_name = new String[count];
	enterprise_number = new String[count];
	addressee_name = new String[count];
	addressee_number = new String[count];
	if(count>0){
		String query = "select dee.enterprise_name, dee.enterprise_number, m.mem_mobilenumber, ad.addressee_name, ad.addressee_number from member m join addressee ad on ad.mem_id = m.mem_id join delivery de on de.mem_id = ad.mem_id join deliveryenterprise dee on dee.deliveryenterprise_no = de.deliveryenterprise_no where ad.mem_id = ?";
		pstmt = con.prepareStatement(query);
		pstmt.setString(1, mem_id);
		rs = pstmt.executeQuery();
		rs.next();
		mem_mobilenumber = rs.getString("mem_mobilenumber");
		
		rs = pstmt.executeQuery();
		for(int i=0; i<count; i++){
			rs.next();
			enterprise_name[i] = rs.getString("enterprise_name");
		}//enterprise_name[여러개]
		rs = pstmt.executeQuery();
		for(int i=0; i<count; i++){
			rs.next();
			enterprise_number[i] = rs.getString("enterprise_number");
		}
		rs = pstmt.executeQuery();
		for(int i=0; i<count; i++){
			rs.next();
			addressee_name[i] = rs.getString("addressee_name");
		}
		rs = pstmt.executeQuery();
		for(int i=0; i<count; i++){
			rs.next();
			addressee_number[i] = rs.getString("addressee_number");
		}
	}
	else{
		%>
		<script>
			alert("배송중인 상품이 없습니다.");
			location.href("index.jsp");
		</script>
		<%
	}
	
}catch(SQLException e){
if(con != null) 
	con.rollback();
throw e;
}finally{
if(con != null){
	con.setAutoCommit(true);
	con.close();
}
if(pstmt != null)
	pstmt.close();
}

%>

<body>
<table border="1" width=800px height=500px cellspacing="0">
<tr>
	<th colspan="5" width=800px height=25px ><font size="5">배송조회</font></th>
</tr>
<tr>
	<th colspan="5" width=800px>
	<%for(int i=0; i<count; i++){%>
	<tbody>
	<tr>
	<center>
		<th colspan="5" height=25px><font size="5" color="blue"> 배송목록 <%=i+1%></font></th>
		</center>
	</tr>
	<tr>
	<center>
		<th colspan="1">배송업체 명</th>
		<th colspan="1">배송업체 연락처</th>
		<th colspan="1">주문자 연락처</th>
		<th colspan="1">수취자 이름</th>
		<th colspan="1">수취자 연락처</th>
		</center>
	</tr>
		<td><%=enterprise_name[i] %></td>
		<td><%=enterprise_number[i] %></td>
		<td><%=mem_mobilenumber %></td>
		<td><%=addressee_name[i] %></td>
		<td><%=addressee_number[i] %></td>
	<br>
	<br>
	<%} %>
	</tbody>
</tr>

</table>
<table border="1" width=800px height=300px cellspacing="0">
<tr>
	<th colspan="5" width=800px height=25px ><font size="5">배송상태 입력 받을 부분</font></th>
</tr>
</table>
</body>
</html>