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


String addressee_name = request.getParameter("addressee_name");
String addressee_number = request.getParameter("addressee_number");
String addressee_address = request.getParameter("addressee_address");


int i = 0;
String mem_id = session.getAttribute("mem_id").toString();
String[] values = request.getParameterValues("loc");
String[] pro_no = new String[values.length];
String purchase_no = "";
String purchase_article_no = "";
String[] pro_quantity = new String[values.length];
String[] notEnoughQuantity = new String[values.length];
String deliveryenterprise_no = "";
String basket_no = "";

for(i=0; i<values.length; i++){
	pro_no[i] = values[i];
}
PreparedStatement pstmt = null;
ResultSet rs = null;
Connection con = null; 

try{
	String url = "jdbc:oracle:thin:@localhost:1521:XE";
	Class.forName("oracle.jdbc.driver.OracleDriver");
	con = DriverManager.getConnection(url, "haejong", "0000");
	con.setAutoCommit(true);
	out.println("Oracle Database Connection Success.");
	Statement stmt = con.createStatement(); 

	String countQuery = "select count(*) from purchase";
	rs = stmt.executeQuery(countQuery);
	rs.next();
	int count = rs.getInt(1);
	
	
	String listQuery = "select purchase_no from purchase order by purchase_no";// 가장 큰 purchase_no 를 찾기 위해
	rs = stmt.executeQuery(listQuery);
	
	if(count!=0){
		for(i=0; i<count; i++)
			rs.next();
		String _purchase_no = rs.getString("purchase_no");
		int _purchase_no_ = Integer.parseInt(_purchase_no);
		_purchase_no_++;
		purchase_no = Integer.toString(_purchase_no_);
	}
	else{
		purchase_no = "11"; //purchase_no 가 아무도 없을시 11부터 시작 
	}
	
	for(i=0; i<pro_no.length; i++){
		String getQuantityQuery = "select pro_quantity from product where pro_no = ?";
		pstmt = con.prepareStatement(getQuantityQuery);
		pstmt.setString(1, pro_no[i]);
		rs = pstmt.executeQuery();
		rs.next();
		pro_quantity[i] = rs.getString("pro_quantity");
	}// 재고 갯수 체크

	// 재고가 5개 미만일시 알림 알리고 거래 취소
	for(i=0; i<pro_no.length; i++){
		if(Integer.parseInt(pro_quantity[i])<2){
			int j=0;
			notEnoughQuantity[j]=pro_quantity[i]; j++;
			%>
			<script>
				alert("상품의 재고가 부족합니다 죄송합니다 거래를 종료합니다.");
				location.href("basket.jsp");
			</script>
			<%
		}
	}

	String insertPurchaseQuery = "insert into purchase select '"+purchase_no+"', '"+mem_id+"' from dual where not exists (select mem_id from purchase where mem_id = '"+mem_id+"')";
	stmt.executeQuery(insertPurchaseQuery); //해당아이디가 가진 purchase_no 가 없을시 생성
	
	
	String countArticleQuery = "select count(*) from product_purchase_article"; // purchase_article 가장 높은 수 를 구하기 위해 카운트
	rs = stmt.executeQuery(countArticleQuery);
	rs.next();
	int count2 = rs.getInt(1);

	String listArticleQuery = "select purchase_article_no from product_purchase_article order by purchase_article_no";
	rs = stmt.executeQuery(listArticleQuery);
	
	if(count2!=0){
		for(i=0; i<count2; i++)
			rs.next();
		String _purchase_article_no = rs.getString("purchase_article_no");
		int _purchase_article_no_ = Integer.parseInt(_purchase_article_no);
		_purchase_article_no_++;
		purchase_article_no = Integer.toString(_purchase_article_no_);
	}// purchase_article_no 가 비지 않았다면 기존 있는 최고 높은 번호에 +1 
	else{
		purchase_article_no = "1001";
	}
	
	//get purchase_no
	String getPurchase_noQuery = "select purchase_no, basket_no from member m join purchase p on p.mem_id = m.mem_id join basket ba on ba.mem_id = m.mem_id where m.mem_id = ?"; //이미 한가지 이상의 아이템이 해당계정으로 배송중일시
	pstmt = con.prepareStatement(getPurchase_noQuery);
	pstmt.setString(1, mem_id);
	rs = pstmt.executeQuery();
	rs.next();
	purchase_no = rs.getString("purchase_no");
	basket_no = rs.getString("basket_no");

	for(i=0; i<pro_no.length; i++){
		String insertPPAQuery = "insert into product_purchase_article (purchase_article_no, purchase_no, pro_no) values ('"+purchase_article_no+"', '"+purchase_no+"', '"+pro_no[i]+"')";
		stmt.executeQuery(insertPPAQuery);
		String _purchase_article_no = purchase_article_no;
		int _purchase_article_no_ = Integer.parseInt(_purchase_article_no);
		_purchase_article_no_++;
		purchase_article_no = Integer.toString(_purchase_article_no_);
	}// 구매목록 등록
	
	for(i=0; i<pro_no.length; i++){
		String updateQuantityQuery = "update product set pro_quantity = nvl(pro_quantity,0)-1 where pro_no = ?";
		pstmt = con.prepareStatement(updateQuantityQuery);
		pstmt.setString(1, pro_no[i]);
		pstmt.executeQuery();
	}// 구매상품 재고 차감
	
	for(i=0; i<pro_no.length; i++){
		String deleteQuery = "delete from basket_article where pro_no = ? and basket_no = ?";
		pstmt = con.prepareStatement(deleteQuery);
		pstmt.setString(1, pro_no[i]);
		pstmt.setString(2, basket_no);
		pstmt.executeQuery();
	}// 구매상품 재고 차감
	
	// 배송회사 등록번호 조회
	String getCampInfoQuery = "select deliveryenterprise_no from deliveryenterprise";
	pstmt = con.prepareStatement(getCampInfoQuery);
	rs = pstmt.executeQuery();
	rs.next();
	deliveryenterprise_no = rs.getString("deliveryenterprise_no");
	
	// 수취자 정보와 배송정보를 입력
	String insertPurInfoQuery = "insert all into addressee values (?, ?, ?, ?) into delivery values (?, ?, ?, ?) select * from dual";
	pstmt = con.prepareStatement(insertPurInfoQuery);
	pstmt.setString(1, addressee_name);
	pstmt.setString(2, addressee_number);
	pstmt.setString(3, addressee_address);
	pstmt.setString(4, mem_id);
	
	pstmt.setString(5, purchase_no);
	pstmt.setString(6, deliveryenterprise_no);
	pstmt.setString(7, addressee_name);
	pstmt.setString(8, mem_id);
	pstmt.executeQuery();
	
	
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
	out.print("<script>location.href='index.jsp';</script>");
}

%>

<body>

</body>
</html>