<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>boardWrite</title>
</head>
<script type="text/javascript">
	$j(document).ready(function() {
		function validateForm() {
		    var userName = $j("#inputName").val().trim();
		    var userPhone = $j("#inputPhone").val().trim();
		    var phonePattern = /^\d{11}$/; // 전화번호 11자리 정규식

		    if (!userName) {
		        alert("이름을 입력해주세요");
		        $j("#inputName").focus();
		        return false;
		    }
		    if (!userPhone) {
		        alert("전화번호를 입력하세요.");
		        $j("#inputPhone").focus();
		        return false;
		    }
		    if (!phonePattern.test(userPhone)) {
		        alert("전화번호는 -제외 11자리 숫자로 입력해주세요. Ex(01012345858)");
		        $j("#inputPhone").focus();
		        return false;
		    }
		    return true;
		}
		$j("#submitButton").click(function(event) {
			
			if(!validateForm()) {
				event.preventDefault();
				return;
			}
			$j(".loginForm").submit();
		});
		
	});
</script>
<body>

	<form class="loginForm" method="post" action="/recruit/form.do" >
		<table align="center" border="1">

			<tr>
				<td align="center" width="80">이름</td>
				<td><input name="name" id="inputName" type="text"></td>
			</tr>
			<tr>
				<td align="center" width="80">휴대폰번호</td>
				<td><input name="phone" id="inputPhone" type="text" placeholder="01012341234"></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<button id="submitButton">입사지원</button>
				</td>
			</tr>

		</table>
	</form>


</body>
</html>