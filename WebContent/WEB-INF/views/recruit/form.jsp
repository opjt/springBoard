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
		var rowIdx = 0;

		 $j(document).on("input", ".dateInput", function(event) {
            var inputValue = $j(this).val();
            console.log(inputValue)

            // 최대 길이 초과 시 잘라내기
            if (inputValue.length > 7) {
                $j(this).val(inputValue.slice(0, 7));
                return;
            }

            var pattern = /^\d{4}\.\d{2}$/;

            // 형식에 맞지 않는 경우 경고 메시지 표시 및 숫자와 점(.) 이외의 문자 제거
            if (!pattern.test(inputValue)) {
                $j(this).val(inputValue.replace(/[^0-9.]/g, '')); 
            }
            // 네 자리 입력 시 점(.) 추가
            if (inputValue.length === 4 && inputValue.indexOf('.') === -1) {
                $j(this).val(inputValue + ".");
            }
	       });

		 $j(document).on("keyup", ".dateInput", function(event) {
	            var inputValue = $j(this).val();

	            // 점(.) 형식으로 포맷팅
	            var formattedValue = inputValue.replace(/(\d{4})(?=\d)/g, '$1.');
	            $j(this).val(formattedValue);

	            // 백스페이스 처리: 점(.) 삭제
	            if (event.keyCode === 8 && inputValue[inputValue.length - 1] === '.' && inputValue.length % 5 === 0) {
	                $j(this).val(inputValue.slice(0, -1));
	            }
	        });
        
		function validateForm() {
			// jQuery에서 사용하는 $j를 사용
			var userName = $j("#inputName").val().trim();
			var userPhone = $j("#inputPhone").val().trim();
			var userBirth = $j("#inputBirth").val().trim();
			var userAddr = $j("#inputAddr").val().trim();
			var userEmail = $j("#inputEmail").val().trim();

			var eduStartPeriod = $j("#eduStartPeriod").val().trim();
			var eduEndPeriod = $j("#eduEndPeriod").val().trim();
			var eduSchoolName = $j("#eduSchoolName").val().trim();
			var eduMajor = $j("#eduMajor").val().trim();
			var eduGrade = $j("#eduGrade").val().trim();

			// 유효성 검사
			if (!userName) {
			    alert("이름을 입력하세요.");
			    $j("#inputName").focus();
			    return false;
			}

			if (!userPhone) {
			    alert("전화번호를 입력하세요.");
			    $j("#inputPhone").focus();
			    return false;
			}
			/* else if (!/^\d{3}-\d{3,4}-\d{4}$/.test(userPhone)) { // 전화번호 형식 검사
			    alert("유효한 전화번호를 입력하세요. 예: 010-1234-5678");
			    $j("#inputPhone").focus();
			    return false;
			} */

			if (!userBirth) {
			    alert("생년월일을 입력하세요.");
			    $j("#inputBirth").focus();
			    return false;
			} 
			/* else if (!/^\d{4}\.\d{2}\.\d{2}$/.test(userBirth)) { // 생년월일 형식 검사
			    alert("유효한 생년월일을 입력하세요. 예: 1990.01.01");
			    $j("#inputBirth").focus();
			    return false;
			} */

			if (!userAddr) {
			    alert("주소를 입력하세요.");
			    $j("#inputAddr").focus();
			    return false;
			}

			if (!userEmail) {
			    alert("이메일을 입력하세요.");
			    $j("#inputEmail").focus();
			    return false;
			} else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(userEmail)) { // 이메일 형식 검사
			    alert("이메일 형식을 맞춰주세요 Ex)test@test.com");
			    $j("#inputEmail").focus();
			    return false;
			}

			if (!eduStartPeriod) {
			    alert("입학 날짜를 입력하세요.");
			    $j("#eduStartPeriod").focus();
			    return false;
			} else if (!/^\d{4}\.\d{2}$/.test(eduStartPeriod)) { // 날짜 형식 검사
			    alert("유효한 입학 날짜를 입력하세요. 예: 2022.03");
			    $j("#eduStartPeriod").focus();
			    return false;
			}

			if (!eduEndPeriod) {
			    alert("졸업 날짜를 입력하세요.");
			    $j("#eduEndPeriod").focus();
			    return false;
			} else if (!/^\d{4}\.\d{2}$/.test(eduEndPeriod)) { // 날짜 형식 검사
			    alert("유효한 졸업 날짜를 입력하세요. 예: 2026.02");
			    $j("#eduEndPeriod").focus();
			    return false;
			}

			if (!eduSchoolName) {
			    alert("학교명을 입력하세요.");
			    $j("#eduSchoolName").focus();
			    return false;
			}

			if (!eduMajor) {
			    alert("전공을 입력하세요.");
			    $j("#eduMajor").focus();
			    return false;
			}

			if (!eduGrade) {
			    alert("학점을 입력하세요.");
			    $j("#eduGrade").focus();
			    return false;
			}

			return true;
		}
		
		function formData() {
			var escape;
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
					$j(this).find('input:not([type="checkbox"]), select, textarea').each(function() {
						var fieldName = $j(this).attr('name');
						var fieldValue = $j(this).val();
						rowData[fieldName] = fieldValue;
					});
					
					 var startDate = rowData["startPeriod"];
		            var endDate = rowData["endPeriod"];
		            if (startDate && endDate) {
		                var startDateObj = new Date(startDate);
		                var endDateObj = new Date(endDate);
		                if (endDateObj < startDateObj) {
		                	escape =  false;
		                    alert("졸업연도는 입학연도보다 이후여야 합니다.");
		                    $j(this).find('input[name="startPeriod"]').focus();
		                    return false
		                    
		                }
		            }
			            
					sectionData.push(rowData);
				});

				boardData[tableId] = sectionData;
			});
			if(escape == false) {
				console.log("안")
				return escape
			}
			return boardData;
			
		}
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
			  // 복제된 행을 테이블에 직접 추가
		    var tbody = table.querySelector('tbody');
		    if (!tbody) {
		        tbody = document.createElement('tbody'); // tbody가 없다면 새로 생성
		        table.appendChild(tbody); // 테이블에 tbody 추가
		    }
		    tbody.appendChild(newRow); // tbody에 복제된 행 추가
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
			 if (!validateForm()) {
	                return;
	            }
			var boardData = formData();
			if(boardData == false) {
				return;
			}

			console.log(boardData);
			$j.ajax({
				type: "POST",
				url: "/recruit/save.do",
				contentType: "application/json",
				data: JSON.stringify(boardData),
				success: function(response) {
					alert("저장이 완료되었습니다")
					location.href = "/recruit/login.do"
				},
				error: function(error) {
					alert("Error saving data");
				}
			});
		});
		$j("#submitButton").on("click", function() {
			if(confirm("제출하면 더이상 수정할 수 없습니다 제출하시겠습니까?") == false){
				alert("취소되었습니다");
				return
			}
			var boardData = formData();

			boardData["recruitForm"][0]["submit"] = true
			
			console.log(boardData)

			$j.ajax({
				type: "POST",
				url: "/recruit/save.do",
				contentType: "application/json",
				data: JSON.stringify(boardData),
				success: function(response) {
					alert("제출이 완료되었습니다")
					location.href = "/recruit/login.do"
				},
				error: function(error) {
					alert("Error saving data");
				}
			});
		});
	});
</script>


<body>


	<table align="center" style="margin-bottom:100px">
		<tr>
			<td align="center">
				<h2>입사 지원서</h2>
			</td>
		</tr>
		<tr>
			<td>
				<table border="1" align="center" width="1000" >
					<tr>
						<td>
							<table border="1" align="center" style="margin-top: 10px" id="RecruitForm">
								<tr>
									<input type="hidden" name="submit" id="inputSubmit"
										value="false">
									<td width="80" align="center" >이름</td>
									<td><input name="name" id="inputName"
										value="${userInfo.name}" disabled></td>
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
										value="${userInfo.phone}" disabled></td>
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
							
							<div id="infoTable">
								 <c:if test="${not empty infoTable}">
							       <table border="1" align="center" id="">
										<tr align="center">
											<td width="180">학력사항</td>
											<td width="180">경력사항</td>
											<td width="180">희망연봉</td>
											<td width="260">희망근무지/근무형태</td>
										</tr>
										<tr>
											<td>${infoTable.education}</td>
											<td>${infoTable.career}</td>
											<td>${infoTable.salary}</td>
											<td>${infoTable.location}<br>${infoTable.workType}</td>
										</tr>
									</table>
							    </c:if>
							</div>
								
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
									<c:forEach items="${eduList}" var="list">
									    <tr data-idx="${list.eduSeq }">
									        <td><input type="checkbox" data-idx="0" name="??"></td>
									        <td><input name="startPeriod" type="text" value="${list.startPeriod}" class="dateInput" id="eduStartPeriod">~<input
									                name="endPeriod" type="text" value="${list.endPeriod}" class="dateInput" id="eduEndPeriod"></td>
									        <td><select name="division" id="lang">
									                <option value="재학" ${list.division == '재학' ? 'selected' : ''}>재학</option>
									                <option value="중퇴" ${list.division == '중퇴' ? 'selected' : ''}>중퇴</option>
									                <option value="졸업" ${list.division == '졸업' ? 'selected' : ''}>졸업</option>
									        </select></td>
									        <td><input name="schoolName" id="eduSchoolName" value="${list.schoolName}"> 
									            <select name="location">
									                <c:forEach items="${location}" var="locationItem">
									                    <option value="${locationItem}" ${locationItem == list.location ? 'selected' : ''}>${locationItem}</option>
									                </c:forEach>
									        </select></td>
									        <td><input name="major" type="text" id="eduMajor" value="${list.major}"></td>
									        <td><input name="grade" value="${list.grade}" id="eduGrade"></td>
									    </tr>
									</c:forEach>
									<c:if test="${empty eduList}">
									     <tr data-idx="0">
											<td><input type="checkbox" data-idx="0" name="??"></td>
											<td><input name="startPeriod" type="text" id="eduStartPeriod" class="dateInput" >~<input
												name="endPeriod" type="text" id="eduEndPeriod" class="dateInput" ></td>
											<td><select name="division" id="lang">
													<option value="재학">재학</option>
													<option value="중퇴">중퇴</option>
													<option value="졸업">졸업</option>
											</select></td>
											<td><input name="schoolName" id="eduSchoolName""> <select name="location">
													<c:forEach items="${location}" var="list">
														<option value="${list}">${list}</option>
													</c:forEach>
											</select></td>
											<td><input name="major" id="eduMajor" type="text"></td>
											<td><input name="grade" id="eduGrade"></td>
										</tr>
									</c:if>

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
									<c:forEach items="${creList}" var="list">
									    <tr data-idx="${list.carSeq }">
									        <td><input type="checkbox" data-idx="0" name="??"></td>
									        <td><input name="startPeriod" type="text" value="${list.startPeriod}">~<input
									                name="endPeriod" type="text" value="${list.endPeriod}"></td>
									        <td><input name="compName" type="text" value="${list.compName}"></td>
									        <td><input name="task" type="text" value="${list.task}"></td>
									        <td><input name="location" type="text" value="${list.location}"></td>
									    </tr>
									</c:forEach>
									<c:if test="${empty creList}">
										 <tr data-idx="0">
									        <td><input type="checkbox" data-idx="0" name="??"></td>
									        <td><input name="startPeriod" type="text" >~<input
									                name="endPeriod" type="text" ></td>
									        <td><input name="compName" type="text" ></td>
									        <td><input name="task" type="text" ></td>
									        <td><input name="location" type="text" ></td>
									    </tr>
									</c:if>
									
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
									<c:forEach items="${cerList}" var="list">
									    <tr data-idx="${list.certSeq }">
									        <td><input type="checkbox" data-idx="0" name="??"></td>
									        <td><input name="qualifiName" type="text" value="${list.qualifiName}"></td>
									        <td><input name="acquDate" type="text" value="${list.acquDate}"></td>
									        <td><input name="organizeName" type="text" value="${list.organizeName}"></td>
									    </tr>
									</c:forEach>
									<c:if test="${empty creList}">
										 <tr data-idx="0">
									       <td><input type="checkbox"></td>
											<td><input name="qualifiName"></td>
											<td><input name="acquDate"></td>
											<td><input name="organizeName"></td>
									    </tr>
									</c:if>
										
								</table>
							</div>
						</td>
					</tr>
				</table>
			</td>

		</tr>

		<tr align="center">
			<td>
			  <c:if test="${userInfo.submit != 'true'}">
                    <button id="saveButton">저장</button>
                    <button id="submitButton">제출</button>
                </c:if>
			 
					
			</td>
		</tr>


	</table>

</body>
</html>