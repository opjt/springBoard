<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>boardWrite</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
    $j(document).ready(function() {
        var rowIdx = 0; // 행 구분을 위한 인덱스

        $j("#addRow").on("click", function() {
            rowIdx++;
            var newRow = `
                <table border="1" data-idx="\${rowIdx}">
                    <tr class="boardEntry" >
                        <td width="120" align="center">Type</td>
                        <td>
                            <select name="boardType" class="boardType">
                                <c:forEach items="${codeList}" var="list">
                                    <option value="${list.codeId}">${list.codeName}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr class="boardEntry" >
                        <td width="120" align="center">Title</td>
                        <td width="400"><input name="boardTitle" type="text" size="50" class="boardTitle"></td>
                    </tr>
                    <tr class="boardEntry" >
                        <td height="300" align="center">Comment</td>
                        <td valign="top"><textarea name="boardComment" rows="20" cols="40" class="boardComment"></textarea></td>
                    </tr>
                    <tr class="boardEntry">
                    	<td >
                    		<button type="button" data-idx="\${rowIdx}" class="removeTable">Remove Table</button>
                    	</td>
                    </tr>
                </table>
                `;
                
            $j("#boardRows").append(newRow);
        });

        $j(document).on("click", ".removeTable", function() {
            var idx = $j(this).data("idx");
            console.log(idx)
            $j(`#boardRows table[data-idx="\${idx}"]`).remove();
        });

        $j("#submit").on("click", function() {
            var boardData = [];

            $j("#boardRows table").each(function() {
                var rowData = {};
                $j(this).find('input, select, textarea').each(function() {
                    var fieldName = $j(this).attr('name');
                    var fieldValue = $j(this).val();
                    rowData[fieldName] = fieldValue;
                });
                rowData["creator"] = "<%=(user != null) ? user.getUserName() : "익명"%>"
                boardData.push(rowData);
            });

          console.log(boardData)

            $j.ajax({
                url: "/board/boardWriteAction.do",
                type: "POST",
                dataType: "json",
                contentType: "application/json",
                data: JSON.stringify(boardData),
                success: function(data, textStatus, jqXHR) {
                	console.log(data)
                    alert("작성완료");
                    alert("메세지:" + data.success);

                    location.href = "/board/boardList.do";
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert("실패");
                }
            });
        });
    });
</script>
</head>
<body>
	<form class="boardWrite">
		<table align="center">
			<tr>
				<td align="right"><input id="submit" type="button" value="작성">
					<button type="button" id="addRow">행추가</button></td>
			</tr>
			<tr>
				<td id="boardRows">
					<table border="1">
						<tr class="boardEntry" data-idx="0">
							<td width="120" align="center">Type</td>
							<td><select name="boardType" class="boardType">
									<c:forEach items="${codeList}" var="list">
										<option value="${list.codeId}">${list.codeName}</option>
									</c:forEach>
							</select></td>
						</tr>
						<tr class="boardEntry" data-idx="0">
							<td width="120" align="center">Title</td>
							<td width="400"><input name="boardTitle" type="text"
								size="50" class="boardTitle"></td>
						</tr>
						<tr class="boardEntry" data-idx="0">
							<td height="300" align="center">Comment</td>
							<td valign="top"><textarea name="boardComment" rows="20"
									cols="40" class="boardComment"></textarea></td>
						</tr>
						<!-- 						<tr class="boardEntry" data-idx="0">
							<td align="center"><button type="button" class="removeRow" data-idx="0">Remove</button></td>
						</tr> -->
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table border="1" id="boardRows">
						<tr class="writerRow">
							<td width="120" align="center">Writer</td>
							<td width="400"><span id="creator"><%=(user != null) ? user.getUserName() : "익명"%></span>
								<input type="hidden" name="creator"
								value="<%=(user != null) ? user.getUserName() : "익명"%>">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="right"><a href="/board/boardList.do">List</a></td>
			</tr>
		</table>
	</form>
</body>
</html>

