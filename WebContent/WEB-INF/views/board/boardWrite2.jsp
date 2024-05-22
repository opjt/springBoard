<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>boardWrite</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
	$j(document).ready(function() {
		
		$j("#addRow").on("click", function() {
			var newRow = `
				<tr class="boardRow">
					<td width="120" align="center">Type</td>
					<td>
						<select name="boardType" class="boardType">
							<c:forEach items="${codeList}" var="list">
								<option value="${list.codeId}">${list.codeName}</option>
							</c:forEach>
						</select>
					</td>
					<td width="120" align="center">Title</td>
					<td width="400"><input name="boardTitle" type="text" size="50" class="boardTitle"></td>
					<td height="300" align="center">Comment</td>
					<td valign="top"><textarea name="boardComment" rows="5" cols="55" class="boardComment"></textarea></td>
					<td align="center"><button type="button" class="removeRow">Remove</button></td>
				</tr>`;
			$j("#boardTable").append(newRow);
		});
		
		$j(document).on("click", ".removeRow", function() {
			$j(this).closest(".boardRow").remove();
		});

		$j("#submit").on("click", function() {
			var boardData = [];
			
			$j(".boardRow").each(function() {
				var boardType = $j(this).find(".boardType").val();
				var boardTitle = $j(this).find(".boardTitle").val();
				var boardComment = $j(this).find(".boardComment").val();
				
				boardData.push({
					boardType: boardType,
					boardTitle: boardTitle,
					boardComment: boardComment,
					creator: "<%= (user != null) ? user.getUserName() : '익명' %>"
				});
			});
			
			$j.ajax({
				url : "/board/boardWriteAction.do",
				dataType : "json",
				type : "POST",
				contentType: "application/json",
				data : JSON.stringify(boardData),
				success : function(data, textStatus, jqXHR) {
					alert("작성완료");
					alert("메세지:" + data.success);

					location.href = "/board/boardList.do";
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("실패");
				}
			});
		});
	});
</script>
</head>
<body>
	<form class="boardWrite">
		<table align="center" id="boardTable">
			<tr>
				<td align="right"><input id="submit" type="button" value="작성">
					<button type="button" id="addRow">행추가</button>
				</td>
			</tr>
			<tr class="boardRow">
				<td width="120" align="center">Type</td>
				<td>
					<select name="boardType" class="boardType">
						<c:forEach items="${codeList}" var="list">
							<option value="${list.codeId}">${list.codeName}</option>
						</c:forEach>
					</select>
				</td>
				<td width="120" align="center">Title</td>
				<td width="400"><input name="boardTitle" type="text" size="50" class="boardTitle"></td>
				<td height="300" align="center">Comment</td>
				<td valign="top"><textarea name="boardComment" rows="5" cols="55" class="boardComment"></textarea></td>
				<td align="center"><button type="button" class="removeRow">Remove</button></td>
			</tr>
			<tr>
				<td align="right"><a href="/board/boardList.do">List</a></td>
			</tr>
		</table>
	</form>
</body>
</html>
