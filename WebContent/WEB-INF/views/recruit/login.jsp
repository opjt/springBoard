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
		$j("#submitButton").click(function() {
			$j("#loginForm").submit();
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
				<td><input name="phone" id="inputPhone" type="text"></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<button>입사지원</button>
				</td>
			</tr>

		</table>
	</form>


</body>
</html>