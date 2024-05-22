<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>boardWrite</title>
</head>
<script type="text/javascript">
$j(document).ready(function(){
	
	$j("#loginBtn").on("click", function() {
		var userId = $j("#inputId").val().trim();
		var userPw = $j("#inputPw").val().trim();
		
		// 아이디와 패스워드가 입력되지 않았을 때 알림 메시지 표시
		if (!userId) {
			alert("아이디를 입력하세요.");
			$j("#inputId").focus();
			return;
		}
		
		if (!userPw) {
			alert("비밀번호를 입력하세요.");
			$j("#inputPw").focus();
			return;
		}

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
					return;
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