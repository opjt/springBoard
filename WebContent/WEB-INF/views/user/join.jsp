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
	var checkId = false
    $j(document).ready(function() {
        $j("#joinBtn").on("click", function() {
            if (!validateForm()) {
                return;
            }

            var $frm = $j('.joinForm :input');
            var param = $frm.serialize();
            console.log(param);
            $j.ajax({
                url : "/user/joinAction.do",
                dataType : "json",
                type : "POST",
                data : param,
                success : function(data, textStatus, jqXHR) {
                    alert("가입완료");
                    alert("메세지:" + data.success);
                    location.href = "/board/boardList.do";
                },
                error : function(jqXHR, textStatus, errorThrown) {
                    alert("실패");
                }
            });
        });
        
        $j("#checkDuplicate").on("click", function() {
            var userId = $j("#inputId").val();

            // userId가 입력되지 않은 경우
            if (!userId) {
                alert("사용자 ID를 입력하세요.");
                return;
            }

            // AJAX 요청으로 중복 체크 수행
            $j.ajax({
                url: "/user/checkIdAction.do",
                type: "GET",
                data: { userId: userId }, // userId 전달
                success: function(data) {
                	console.log(data.result)
                    if (data.result === "N") {
                        alert("이미 사용 중인 ID입니다.");
                    } else {
                        alert("사용 가능한 ID입니다.");
                        // 중복 체크 성공 후 버튼 비활성화
                        checkId = true;
                        $j("#checkDuplicate").prop("disabled", true);
                    }
                },
                error: function(xhr, status, error) {
                    alert("서버 오류가 발생했습니다.");
                }
            });
        });

        // ID 입력 필드 값 변경 이벤트
        $j("#inputId").on("input", function() {
            // ID 입력 값이 변경되면 중복 체크 버튼 활성화
            checkId = false;
            $j("#checkDuplicate").prop("disabled", false);
        });
    });

    function validateForm() {
        var userId = $j("#inputId").val();
        var userPw = $j("#inputPw").val();
        var userPwCheck = $j("#inputPwCheck").val();
        var userName = $j("#inputName").val();
        var userPhone1 = $j("#inputPhone1").val();
        var userPhone2 = $j("#inputPhone2").val();
        var userPhone3 = $j("#inputPhone3").val();
        var userAddr1 = $j("#inputAddr1").val();

        if (!userId || !userPw || !userPwCheck || !userName || !userPhone1 || !userPhone2 || !userPhone3 || !userAddr1) {
            alert("필수 입력값을 모두 입력해주세요.");
            return false;
        }
		if(!checkId) {
			alert("아이디 중복검사를 확인해주세요");
			return false
		}
        // 비밀번호 확인
        if (userPw !== userPwCheck) {
            alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            return false;
        }

        // 비밀번호 길이 확인
        if (userPw.length < 6 || userPw.length > 12) {
            alert("비밀번호는 6자 이상, 12자 이하로 입력해주세요.");
            return false;
        }

        // 전화번호 길이 확인
        if (userPhone2.length !== 4 || userPhone3.length !== 4) {
            alert("전화번호를 정확히 입력해주세요.");
            return false;
        }

        // 우편번호 형식 확인
        if (!/^\d{3}-\d{3}$/.test(userAddr1)) {
            alert("우편번호를 xxx-xxx 형식으로 입력해주세요.");
            return false;
        }

        return true;
    }
</script>

<body>
	<form class="joinForm">
		<table align="center">
			<tr>
				<th align="left"><a href="/board/boardList.do">List</a></th>
			</tr>
			<tr>
				<td>

					<table border="1">

						<tr>
							<td align="center" width="100">id</td>
							<td width="300"><input name="userId" id="inputId"
								type="text">  <button type="button" id="checkDuplicate">중복 체크</button></td>
						</tr>
						<tr>
							<td align="center" width="80">pw</td>
							<td><input name="userPw" id="inputPw" type="password"></td>
						</tr>
						<tr>
							<td align="center" width="80">pw check</td>
							<td><input id="inputPw" type="password"></td>
						</tr>
						<tr>
							<td align="center" width="80">name</td>
							<td><input name="userName" id="inputPwCheck" type="text"></td>
						</tr>
						<tr>
							<td align="center" width="80">phone</td>
							<td><select name="userPhone1" id="inputPhone1">
									<c:forEach items="${codeList}" var="list">
										<option value="${list.codeName}">${list.codeName}</option>
									</c:forEach>
							</select>-
							<input id="inputPhone2" size="4" type="number" name="userPhone2">-
							<input id="inputPhone3" size="4" type="number"  maxlength="4" name="userPhone3"></td>
						</tr>
						<tr>
							<td align="center" width="80">postNo</td>
							<td><input name="userAddr1" id="inputAddr1" type="text"></td>
						</tr>
						<tr>
							<td align="center" width="80">address</td>
							<td><input name="userAddr2" id="inputAddr2" type="text"></td>
						</tr>
						<tr>
							<td align="center" width="80">company</td>
							<td><input name="userCompany" id="inputCompany" type="text"></td>
						</tr>


					</table>
				</td>
			</tr>
			<tr>
				<td align="right" id="joinBtn">join</td>
			</tr>


		</table>
	</form>

</body>
</html>