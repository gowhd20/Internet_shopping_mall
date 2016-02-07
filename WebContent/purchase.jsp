<%@page import="java.util.regex.Pattern" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<% 
String[] values;
int sum = 0;
int discount = 0;
int discountedSum = 0;
String mem_address = "";
String mem_name = "";
String mem_mobilenumber = "";

values = request.getParameterValues("check");
String[] pro_no = new String[values.length];
String[] pro_price = new String[values.length];
String mem_class = "";
String mem_id = session.getAttribute("mem_id").toString();
for(int i=0; i<pro_no.length; i++){
	pro_no[i] = values[i];
}


PreparedStatement pstmt = null;
ResultSet rs = null;
Connection con = null; 

String url = "jdbc:oracle:thin:@localhost:1521:XE";
Class.forName("oracle.jdbc.driver.OracleDriver");
con = DriverManager.getConnection(url, "haejong", "0000");
//con.setAutoCommit(false);
out.println("Oracle Database Connection Success.");

for(int i=0; i<pro_no.length; i++){
	String query = "select pro_price, m.mem_address, m.mem_name, m.mem_mobilenumber, m.mem_class from product p join basket_article ba on ba.pro_no = p.pro_no join basket b on b.basket_no = ba.basket_no join member m on m.mem_id = b.mem_id where p.pro_no = ? and m.mem_id = ?";
	pstmt = con.prepareStatement(query);
	pstmt.setString(1, pro_no[i]);
	pstmt.setString(2, mem_id);
	rs = pstmt.executeQuery();
	while(rs.next()){
		pro_price[i] = rs.getString("pro_price");
		mem_class = rs.getString("mem_class");
		mem_address = rs.getString("mem_address");
		mem_name = rs.getString("mem_name");
		mem_mobilenumber = rs.getString("mem_mobilenumber");
	}
}// üũ�ڽ� ���� ������ ������� ���� ���� ȹ��

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

for(int i=0; i<pro_no.length; i++){
	sum += Integer.parseInt(pro_price[i]);
}

discountedSum = sum - sum*discount/100;

%>
</head>


<body>
<form action="purchaseDone.jsp" method="post">
<table border="1" width=800px height=400px cellspacing="0">
<tr>
	<th colspan="5" width=800px height=25px  >����</th>
</tr>
<tr>
	<th width=266px height=25px>�� �ֹ��ݾ�</th>
	<th width=266px height=25px>���γ���</th>
	<th width=266px height=25px>�����ݾ�</th>
</tr>
<tr>
	<td>
		<center>
		 <font size="7" color="black"><%=sum%>��</font>
		</center>
	</td>
	<td>
		<center>
		 <font size="7" color="red"><%=mem_class%>ȸ�� <%=discount%>%����</font>
		</center>
	</td>
	<td>
		<center>
		 <font size="7" color="red"><%=discountedSum%>��</font>
		</center>
	</td>
</tr>
<tr>
	<td>

		 �ֹ��� ID: <b><font size="3" color="black"><%=mem_id%></font></b><br>
		 �ֹ��� �̸�: <b><font size="3" color="black"><%=mem_name%></font></b><br>
		 �ֹ��� ����ó: <b><font size="3" color="black"><%=mem_mobilenumber%></font></b><br>
		 �ֹ��� �ּ�: <b><font size="3" color="black"><%=mem_address%></font></b><br>

	</td>
	<td>
		<center>
			<input type="submit" value="�����ϱ�" ><br><br>
			<% 
			for (int i =0; i<pro_no.length; i++)
			{
			%>
			<Input type = "Hidden" name = "loc" value = "<%= pro_no[i] %>">
			<%
			}
			%>
			<a href="basket.jsp">�ڷΰ���</a>
		</center>
	</td>
	<td>
		������ �̸�: <input type="text" name="addressee_name" /><br>
		������ ����ó: <input type="text" name="addressee_number" /><br>
		������ �ּ�: <input type="text" name="addressee_address" /><br>
		
	</td>
</tr>
</table>
</body>
</html>
