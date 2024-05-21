<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>boardWrite</title>
</head>
<script type="text/javascript">
$j(document).ready(function(){
	
	$j("#loginBtn").on("click",function(){
		var $frm = $j('.loginForm :input');
		var param = $frm.serialize();
		
		$j.ajax({
		    url : "/user/loginAction.do",
		    dataType: "json",
		    type: "POST",
		    data : param,
		    success: function(data, textStatus, jqXHR)
		    {
				if(data.success == "N") {
					alert("잘못된 로그인 정보입니다 ");
					return
				}
				
				alert("로그인 성공");
				window.location.href = "/board/boardList.do";
				
		    },
		    error: function (jqXHR, textStatus, errorThrown)
		    {
		    	alert("Server Error");
		    }
		});
	});
});


</script>
<body>
	<form class="loginForm">
	<table align="center">
		<tr>
			<td>

				<table border="1">

					<tr>
						<td align="center" width="80">id</td>
						<td><input name="userId" id="inputId" type="text"></td>
					</tr>
					<tr>
						<td align="center" width="80">pw</td>
						<td><input name="userPw" id="inputPw" type="password"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right" id="loginBtn">login</td>
		</tr>


	</table>
	</form>


</body>
</html>