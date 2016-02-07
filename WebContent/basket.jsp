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
String[] pro_no = new String[20];
String[] pro_name = new String[20];
String[] pro_price = new String[20];
String[] pro_photo = new String[20];
Integer[] discountedPrice = new Integer[20];
String basket_no = "";
String mem_class = "";
int count = 0;
int discount = 0;
int sum = 0;

String mem_id = session.getAttribute("mem_id").toString();
PreparedStatement pstmt = null;
//PreparedStatement basketPstmt = null;
ResultSet rs = null;
Connection con = null; 



try{

	String url = "jdbc:oracle:thin:@localhost:1521:XE";
	Class.forName("oracle.jdbc.driver.OracleDriver");
	con = DriverManager.getConnection(url, "haejong", "0000");
	//con.setAutoCommit(false);
	out.println("Oracle Database Connection Success.");
	
	// 장바구니에 항목이 없을시를 처리하기 위해 따로 select문 처리
	String getBasketNoQuery = "select basket_no from basket where mem_id = ?";
	pstmt = con.prepareStatement(getBasketNoQuery);
	pstmt.setString(1, mem_id);
	rs = pstmt.executeQuery();
	rs.next();
	basket_no = rs.getString("basket_no");

	String countQuery = "select count(*) from basket_article where basket_no = ?";
	pstmt = con.prepareStatement(countQuery);
	pstmt.setString(1, basket_no);

	rs = pstmt.executeQuery();
	rs.next();
	count = rs.getInt(1);

	
	if(count > 0){
		String query = "select p.pro_no, pro_name, pro_price, pro_photo, mem_class from member m join basket b on m.mem_id = b.mem_id join basket_article ba on ba.basket_no = b.basket_no join product p on p.pro_no = ba.pro_no where m.mem_id = ?";
		pstmt = con.prepareStatement(query);
		pstmt.setString(1, mem_id);
		rs = pstmt.executeQuery();
	//rs.next();
	//basket_no = rs.getString("basket_no");

	//if(count > 0){
		//rs = pstmt.executeQuery();
		for(int i=0; i<count; i++){
			rs.next();
			pro_name[i] = rs.getString("pro_name");
		}//pro_name[여러개]
		rs = pstmt.executeQuery();
		for(int i=0; i<count; i++){
			rs.next();
			pro_no[i] = rs.getString("pro_no");
		}
		rs = pstmt.executeQuery();
		for(int i=0; i<count; i++){
			rs.next();
			pro_price[i] = rs.getString("pro_price");
		}
		rs = pstmt.executeQuery();
		for(int i=0; i<count; i++){
			rs.next();
			pro_photo[i] = rs.getString("pro_photo");
		}
		//rs = pstmt.executeQuery();
		mem_class = rs.getString("mem_class");
		//System.out.println(mem_class);
	//}
		if(mem_class.compareTo("vip")==0 || mem_class.compareTo("Vip")==0){
			discount = 10;
		}
		else if(mem_class.compareTo("gold")==0 || mem_class.compareTo("Gold")==0){
			discount = 5;
		}
		else if(mem_class.compareTo("silver")==0 || mem_class.compareTo("Silver")==0){
			discount = 2;
		}
		else if(mem_class.compareTo("new")==0 || mem_class.compareTo("New")==0){
			discount = 0;
		}
	
		int[] dPrice = new int[count];
		for(int i=0; i<count; i++){
			dPrice[i] = Integer.parseInt(pro_price[i]); 	
		}//폼목별 할인된 가격
		for(int i=0; i<count; i++){
			discountedPrice[i] = dPrice[i] - dPrice[i]*discount/100;
		}//폼목별 할인된 가격
	}// 장바구니에 항목이 있으면 실행, 없으면 통과

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
<form action="purchase.jsp" method="post">
	<center>
	<table border="1" width="90" cellpadding="5">
	<thead>
	<tr>
		<th colspan="5">장바구니</th>
	<%for(int i=0; i<count; i++){%>
	<tbody>
	
		<td><input type="checkbox" name="check" value="<%=pro_no[i]%>"></td>
		<td><%=pro_photo[i] %></td>
		<td><a href="index.jsp"><%=pro_name[i] %></td></a>
		<td><%=pro_price[i] %>&nbsp;</td>
		<td><%=discountedPrice[i]%>&nbsp;</td>
	</tr>
	<%} %>
	</tbody>
	</table>
	</center>
	<center>
	<td>
		<tr><input type="submit" value="구매하기" ></tr>
		<form action="basketDelete.jsp" method="post">
		</form>
	</td>
	</center>
</form>
</body>
</html>