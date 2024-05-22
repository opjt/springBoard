<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>boardView</title>
</head>
<script type="text/javascript">

	$j(document).ready(function(){
		
		$j('#deleteLink').click(function(event) {
	        event.preventDefault(); // 
	        if (confirm('정말 삭제하시겠습니까?')) {
	            $j.ajax({
	                url: '/board/${board.boardType}/${board.boardNum}/boardDeleteAction.do',
	                type: 'POST',
	                success: function(data, textStatus, jqXHR) {
	                    alert('삭제완료');
	                    window.location.href = '/board/boardList.do'; 
	                },
	                error: function (jqXHR, textStatus, errorThrown) {
	                    alert('실패');
	                }
	            });
	        }
	    });
	});
	

</script>
<body>
	<table align="center">
		<tr>
			<td>
				<table border="1">
					<tr>
						<td width="120" align="center">Type</td>
						<td>${codeMap[board.boardType]}</td>
					</tr>
					<tr>
						<td width="120" align="center">Title</td>
						<td width="400">${board.boardTitle}</td>
					</tr>
					<tr>
						<td height="300" align="center">Comment</td>
						<td>${board.boardComment}</td>
					</tr>
					<tr>
						<td align="center">Writer</td>
						<td>${board.creator}</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right"><a
				href="/board/${board.boardType}/${board.boardNum}/boardModify.do">Modify</a>
			</td>
			<td align="right"><a href='#' id="deleteLink">delete</a></td>
			<td align="right"><a href="/board/boardList.do">List</a></td>
		</tr>
	</table>
</body>
</html>