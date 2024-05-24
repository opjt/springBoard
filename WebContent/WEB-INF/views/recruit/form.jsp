<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>boardWrite</title>
</head>
<script type="text/javascript">
	var lastFocusedInput = null; // 마지막으로 포커스를 받은 입력란을 저장할 변수
	$j(document).ready(function() {
		var rowIdx = 0;

		// Education 추가 버튼 클릭 시
		$j(".addRowsButton").on("click", function() {
			var dataValue = $j(this).data("value"); // 클릭된 버튼의 data-value 값 가져오기
			var tableId = "#form" + dataValue; // 해당하는 테이블의 ID 생성

			addNewRow(tableId);
		});

		function addNewRow(tableId) {
			var table = document.querySelector(tableId);
			var lastRow = table.querySelector('tr:last-child'); // 해당 테이블의 마지막 행 선택
			var newRow = lastRow.cloneNode(true); // 마지막 행 복제

			// 복제된 행에 있는 input 요소 초기화 (필요하다면)
			var inputs = newRow.querySelectorAll('input');
			inputs.forEach(function(input) {
				input.value = ''; // 값 초기화
				input.checked = false;
			});

			// 복제된 행을 추가
			table.appendChild(newRow);
		}

		$j(".removeRows").on("click", function() {
			// 해당 테이블의 행 개수를 가져옴
			var tableId = $j(this).data("table");
			var rowCount = $j(tableId + " tr").length;
			var checkedCount = $j(tableId + " input[type=checkbox]:checked").length;

			// 체크된 체크박스가 없는 경우 return
			if (checkedCount === 0) {
				return;
			}

			// 행이 2개 이하인 경우에만 삭제 실행
			if (rowCount <= 2) {
				alert("테이블에는 최소 1개의 행이 있어야 합니다.");
				return;
			}

			// 해당 테이블의 체크된 체크박스를 가져와서 삭제
			$j(tableId + " input[type=checkbox]:checked").closest("tr").remove();
		});

		$j("#saveButton").on("click", function() {
			var boardData = {};

			var recruitForm = {}
			$j("#RecruitForm input, #RecruitForm select, #RecruitForm textarea").each(function() {
			    var fieldName = $j(this).attr('name');
			    var fieldValue = $j(this).val();
			    recruitForm[fieldName] = fieldValue;
			});
			boardData["recruitForm"] = [recruitForm];
            
			$j("table[id^='form']").each(function() {
				var tableId = $j(this).attr('id');
				var sectionData = [];

				$j(this).find('tr').each(function(index) {
					if (index === 0) return; // Skip header row
					var rowData = {};
					$j(this).find('input, select, textarea').each(function() {
						var fieldName = $j(this).attr('name');
						var fieldValue = $j(this).val();
						rowData[fieldName] = fieldValue;
					});
					sectionData.push(rowData);
				});

				boardData[tableId] = sectionData;
			});

			console.log(boardData);

			$j.ajax({
				type: "POST",
				url: "/recruit/save.do",
				contentType: "application/json",
				data: JSON.stringify(boardData),
				success: function(response) {
					// Handle success response
				},
				error: function(error) {
					alert("Error saving data");
				}
			});
		});
	});
</script>


<body>


	<table align="center">
		<tr>
			<td align="center">
				<h2>입사 지원서</h2>
			</td>
		</tr>
		<tr>
			<td>
				<table border="1" align="center" width="1000">
					<tr>
						<td>
							<table border="1" align="center" style="margin-top: 10px" id="RecruitForm">
								<tr>
									<td width="80" align="center">이름</td>
									<td><input name="name" id="inputName"
										value="${userInfo.name}"></td>
									<td width="80" align="center" >생년월일</td>
									<td><input name="birth" id="inputBirth" value="${userInfo.birth}"></td>
								</tr>
								<tr>
									<td width="80" align="center">성별</td>
									<td><select name="gender" id="inputGender">
											<option value="남자"
												${userInfo.gender == '남자' ? 'selected' : ''}>남자</option>
											<option value="여자"
												${userInfo.gender == '여자' ? 'selected' : ''}>여자</option>
											<option value="기타"
												${userInfo.gender == '기타' ? 'selected' : ''}>기타</option>
									</select></td>
									<td width="80" align="center">연락처</td>
									<td><input name="phone" id="inputPhone"
										value="${userInfo.phone}"></td>
								</tr>
								<tr>
									<td width="80" align="center">이메일</td>
									<td><input name="email" id="inputEmail"
										value="${userInfo.email}"></td>
									<td width="80" align="center">주소</td>
									<td><input name="addr" id="inputAddr"
										value="${userInfo.addr}"></td>
								</tr>
								<tr>
									<td width="80" align="center">희망근무지</td>
									<td><select name="location" id="inputLocation">
											<c:forEach items="${location}" var="list">
												<option value="${list}"
													${userInfo.location == list ? 'selected' : ''}>${list}</option>
											</c:forEach>
									</select></td>
									<td width="80" align="center">근무형태</td>
									<td><select name="workType" id="inputWorkType">
											<option value="정규직"
												${userInfo.workType == '정규직' ? 'selected' : ''}>정규직</option>
											<option value="계약직"
												${userInfo.workType == '계약직' ? 'selected' : ''}>계약직</option>
									</select></td>
								</tr>
							</table>

							<div id="sectionEducation">
								<h2>학력</h2>
								<div style="text-align: right">
									<button class="addRowsButton" data-value="Education">추가</button>
									<button class="removeRows" data-table="#formEducation">삭제</button>
								</div>

								<table border="1" align="center" id="formEducation">
									<tr align="center">
										<td width="20"></td>
										<td width="100">재학기간</td>
										<td width="40">구분</td>
										<td width="180">학교명(소재지)</td>
										<td width="180">전공</td>
										<td width="180">학점</td>
									</tr>
									<tr data-idx="0">
										<td><input type="checkbox" data-idx="0"></td>
										<td><input name="startPeriod" type="text">~<input
											name="endPeriod" type="text"></td>
										<td><select name="division" id="lang">
												<option value="재학">재학</option>
												<option value="중퇴">중퇴</option>
												<option value="졸업">졸업</option>
										</select></td>
										<td><input> <select name="location">
												<c:forEach items="${location}" var="list">
													<option value="${list}">${list}</option>
												</c:forEach>
										</select></td>
										<td><input name="major" type="text"></td>
										<td><input name="grade"></td>
									</tr>
								</table>
							</div>

							<div id="sectionCareer">
								<h2>경력</h2>
								<div style="text-align: right">
									<button class="addRowsButton" data-value="Career">추가</button>
									<button class="removeRows" data-table="#formCareer">삭제</button>
								</div>

								<table border="1" align="center" id="formCareer">
									<tr align="center">
										<td width="20"></td>
										<td width="100">근무기간</td>
										<td width="180">회사명</td>
										<td width="180">부서/직급/직책</td>
										<td width="180">지역</td>
									</tr>
									<tr>
										<td><input type="checkbox"></td>
										<td><input>~<input></td>
										<td><input></td>
										<td><input></td>
										<td><input></td>
									</tr>
								</table>
							</div>
							<div id="sectionCertificate" style="margin-bottom: 10px">
								<h2>자격증</h2>
								<div style="text-align: right">
									<button class="addRowsButton" data-value="Certificate">추가</button>
									<button class="removeRows" data-table="#formCertificate">삭제</button>
								</div>

								<table border="1" align="center" id="formCertificate">
									<tr align="center">
										<td width="20"></td>
										<td width="180">자격증명</td>
										<td width="180">취득일</td>
										<td width="180">발행처</td>
									</tr>
									<tr>
										<td><input type="checkbox"></td>
										<td><input></td>
										<td><input></td>
										<td><input></td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
				</table>
			</td>

		</tr>

		<tr align="center">
			<td>
				<button id="saveButton">저장</button>
				<button>제출</button>
			</td>
		</tr>


	</table>

</body>
</html>