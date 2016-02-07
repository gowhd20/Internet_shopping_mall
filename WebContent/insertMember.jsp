<%@page import="java.sql.Date"%>
<%@page import="java.util.regex.Pattern" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="java.sql.*" %>
<%@page import="java.text.*" %>
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
	int i = 0;
	String url = "jdbc:oracle:thin:@localhost:1521:XE";
	//String message="";
	String basket_no = "";
	String mem_id = request.getParameter("mem_id");
	String mem_pw = request.getParameter("mem_pw");
	String mem_name = request.getParameter("mem_name");
	String mem_sex = request.getParameter("mem_sex");
	String _mem_birthday = request.getParameter("mem_birthday");
	String mem_number = request.getParameter("mem_number");
	String mem_mobilenumber = request.getParameter("mem_mobilenumber");
	String mem_address = request.getParameter("mem_address");
	String mem_email = request.getParameter("mem_email");
	

	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	java.util.Date Umem_birthday = new java.util.Date();
	Umem_birthday = format.parse(_mem_birthday);
	java.sql.Date mem_birthday = new java.sql.Date(Umem_birthday.getTime());
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		con = DriverManager.getConnection(url, "haejong", "0000");
		out.println("Oracle Database Connection Success.");
		con.setAutoCommit(false);
		
		String query = "select count(*) from member where mem_id = ?";
		pstmt = con.prepareStatement(query);
		pstmt.setString(1, mem_id);
		rs = pstmt.executeQuery();
		rs.next(); 
		if(rs.getInt(1)==0){
			
			Statement stmt = con.createStatement(); 
			String countQuery = "select count(*) from basket";
			rs = stmt.executeQuery(countQuery);
			rs.next();
			int count = rs.getInt(1);
			
			String listQuery = "select basket_no from basket order by basket_no";
			rs = stmt.executeQuery(listQuery);
			for(i=0; i<count; i++)
				rs.next();
			String _basket_no = rs.getString("basket_no");
			
			int _basket_no_ = Integer.parseInt(_basket_no);
			_basket_no_++;
			basket_no = Integer.toString(_basket_no_);
			
			query = "insert into member (mem_id, mem_pw, mem_name, mem_sex, mem_birthday, mem_number, mem_mobilenumber, mem_address, mem_email, mem_class)"
					+"values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, mem_id);
			pstmt.setString(2, mem_pw);
			pstmt.setString(3, mem_name);
			pstmt.setString(4, mem_sex);
			pstmt.setDate(5, mem_birthday);
			pstmt.setString(6, mem_number);
			pstmt.setString(7, mem_mobilenumber);
			pstmt.setString(8, mem_address);
			pstmt.setString(9, mem_email);
			pstmt.setString(10, "New");

			
			if(pstmt.executeUpdate()>0){
			
				String insertBasketQuery = "insert into basket (basket_no, mem_id) values (?, ?)";
				pstmt = con.prepareStatement(insertBasketQuery);
				pstmt.setString(1, basket_no);
				pstmt.setString(2, mem_id);
				pstmt.executeQuery();

			%>
			<script>
				alert("ȸ������ �Ǽ̽��ϴ� ȯ���մϴ�!");
				location.href("login.jsp");
			</script>
			<%
			}
		}
		else{
			%>
			<script>
				alert("���̵� ������Դϴ�");
				location.href("signUp.jsp");
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
</form>
<script>
function formCheck(){
		
	var id = document.forms[0].mem_id.value;
	var pw = document.forms[0].mem_pw.value;
	var name = document.forms[0].mem_name.value;
	var sex = document.forms[0].mem_sex.value;
	var birthday = document.forms[0].mem_birthday.value;
	var number = document.forms[0].mem_number.value;
	var mobilenumber = document.forms[0].mem_mobilenumber.value;
	var address = document.forms[0].mem_address.value;
	var email = document.forms[0].mem_email.value;
	if (id == null || id == ""){      // null���� ���� ��
		alert('���̵� �Է��ϼ���');           // ���â�� ����
		document.forms[0].mem_id.focus();    // �ش��±׿� ��Ŀ���� �ص�
		return false;                       // false�� �����մϴ�.
	}
	else if(pw == null || pw==""){			
		alert('��й�ȣ�� �Է��ϼ���');           // ���â�� ����
		document.forms[0].mem_pw.focus();    // �ش��±׿� ��Ŀ���� �ص�
		return false;
	}
	else if(name == null || name==""){			
		alert('�̸��� �Է��ϼ���');           // ���â�� ����
		document.forms[0].mem_name.focus();    // �ش��±׿� ��Ŀ���� �ص�
		return false;
	}
	else if(sex == null || sex==""){			
		alert('������ �Է��ϼ���');           // ���â�� ����
		document.forms[0].mem_sex.focus();    // �ش��±׿� ��Ŀ���� �ص�
		return false;
	}
	else if(birthday == null || birthday==""){			
		alert('������ �Է��ϼ���');           // ���â�� ����
		document.forms[0].mem_birthday.focus();    // �ش��±׿� ��Ŀ���� �ص�
		return false;
	}
	else if(number == null || number==""){			
		alert('��ȭ��ȣ�� ����ϼ���');           // ���â�� ����
		document.forms[0].mem_number.focus();    // �ش��±׿� ��Ŀ���� �ص�
		return false;
	}
	else if(mobilenumber == null || mobilenumber==""){			
		alert('�޴��ȣ�� �Է��ϼ���');           // ���â�� ����
		document.forms[0].mem_mobilenumber.focus();    // �ش��±׿� ��Ŀ���� �ص�
		return false;
	}
	else if(address == null || address==""){			
		alert('�ּҸ� �Է��ϼ���');           // ���â�� ����
		document.forms[0].mem_address.focus();    // �ش��±׿� ��Ŀ���� �ص�
		return false;
	}
	else if(email == null || email==""){			
		alert('�̸����� �Է��ϼ���');           // ���â�� ����
		document.forms[0].mem_email.focus();    // �ش��±׿� ��Ŀ���� �ص�
		return false;
	}
}

</script>
</body>

</html>