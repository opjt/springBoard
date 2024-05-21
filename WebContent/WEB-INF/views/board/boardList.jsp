<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>list</title>
</head>
<script type="text/javascript">
    $j(document).ready(function(){
        // 개별 체크박스에 대한 이벤트 처리
        $j("[name='code']").click(function(){
            var allChecked = true;
            $j("[name='code']").each(function(){
                if(!$j(this).prop("checked")) {
                    allChecked = false; // 하나라도 체크되지 않은 경우
                }
            });

            if(allChecked) {
                $j("[name='codeAll']").prop("checked", true); // 모두 체크되었을 때 전체 선택 체크박스 선택
            } else {
                $j("[name='codeAll']").prop("checked", false); // 하나라도 체크되지 않았을 때 전체 선택 체크박스 해제
            }
        });

        // 전체 선택 체크박스에 대한 이벤트 처리
        $j("[name='codeAll']").click(function(){
            if($j(this).prop("checked")) {
                $j("[name='code']").prop("checked", true); // 전체 선택 시 모든 체크박스 선택
            } else {
                $j("[name='code']").prop("checked", false); // 전체 해제 시 모든 체크박스 해제
            }
        });
        
        $j("[value='조회']").click(function(){
            var checkedValues = [];
            $j("[name='code']:checked").each(function(){
                checkedValues.push($j(this).val());
            });
			console.log(checkedValues)
            $j.ajax({
                type: "GET",
                url: "/board/getBoards.do",
                data: { codes: checkedValues.join(",") },
                success: function(data, textStatus, jqXHR) {
                    // 받아온 데이터로 테이블을 재구성
                    console.log(data);
                    var boards = data.board;
              		var code = data.code;
              		
                    var html = `<tr>
						<td width="80" align="center">Type</td>
						<td width="40" align="center">No</td>
						<td width="300" align="center">Title</td>
					</tr>`;
                   
                    boards.forEach(function(item) {
                   		var type = item.boardType
                        html += "<tr>";
                        html += "<td align='center' data-board-type='" + item.boardType + "'>" + code[type] + "</td>";
                        html += "<td>" + item.boardNum + "</td>";
                        html += "<td><a href='/board/" + item.boardType + "/" + item.boardNum + "/boardView.do?pageNo=" + item.pageNo + "'>" + item.boardTitle + "</a></td>";
                        html += "</tr>";
                    });
                    $j("#boardTable tbody").html(html);
                },
                error: function(xhr, status, error) {
                    console.error(xhr.responseText);
                }
            });
        });
            
    });
</script>

<body>
	<table align="center">
		<tr>
			<td align="right">total : ${totalCnt}</td>
		</tr>
		<tr>
			<td>
				<table id="boardTable" border="1">
					<tr>
						<td width="80" align="center">Type</td>
						<td width="40" align="center">No</td>
						<td width="300" align="center">Title</td>
					</tr>
					<c:forEach items="${boardList}" var="list">
				        <tr>
				            <td align="center" data-board-type="${list.boardType}">${codeMap[list.boardType]}</td>
				            <td>${list.boardNum}</td>
				            <td><a href="/board/${list.boardType}/${list.boardNum}/boardView.do?pageNo=${pageNo}">${list.boardTitle}</a></td>
				        </tr>
					</c:forEach>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right"><a href="/board/boardWrite.do">글쓰기</a></td>
		</tr>
		<tr>
			<td>
				<label><input type="checkbox" name="codeAll" value="#ALL">전체</label>
				<c:forEach items="${codeList}" var="list">
					<label><input type="checkbox" name="code" value="${list.codeId}">${list.codeName}</label>
					
				</c:forEach>
				<input type="button" value="조회">		
			</td>
			
		</tr>
	</table>
</body>
</html>