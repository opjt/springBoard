<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>boardWrite</title>
</head>
<script type="text/javascript">
	var checkId = false
	var lastFocusedInput = null; // 마지막으로 포커스를 받은 입력란을 저장할 변수
    $j(document).ready(function() {
    	$j("#inputId").focus();

    	// 각 입력란의 포커스 이벤트에 대한 처리
    	$j("input").on("focus", function() {
    	    lastFocusedInput = $j(this); // 현재 포커스를 받은 입력란을 저장
    	});

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
                    alert("가입 성공");
                    alert("MSG:" + data.success);
                    location.href = "/board/boardList.do";
                },
                error : function(jqXHR, textStatus, errorThrown) {
                    alert("Server Error");
                }
            });
        });
        
        $j("#checkDuplicate").on("click", function() {
        	
            var userId = $j("#inputId").val();

            if (!userId) {
                alert("아이디를 입력해주세요");
                return;
            }

            // AJAX 아이디 중복체크
            $j.ajax({
                url: "/user/checkIdAction.do",
                type: "GET",
                data: { userId: userId }, 
                success: function(data) {
                	console.log(data.result)
                    if (data.result === "N") {
                        alert("이미 사용중인 아이디입니다");
                    } else {
                        alert("사용가능한 아이디입니다");
                        checkId = true;
                        $j("#checkDuplicate").prop("disabled", true);
                    }
                },
                error: function(xhr, status, error) {
                    alert("server Error");
                }
            });
            if (lastFocusedInput) {
    	        lastFocusedInput.focus(); // 저장된 위치로 포커스 이동
    	    }
        });

        $j("#inputId").on("input", function() {
            checkId = false;
            $j("#checkDuplicate").prop("disabled", false);
        });
        $j("#inputId").on("input", function(event) {
            var inputValue = $j(this).val();
            var filteredValue;
            
            if (inputValue.length > 15) {
                $j("#errorMsg").text("최대 15글자까지 입력 가능합니다.");
                filteredValue = inputValue.slice(0, 15); // 최대 길이까지만 잘라냄
                $j(this).val(filteredValue);
            } else if (/[ㄱ-ㅎㅏ-ㅣ가-힣]/.test(inputValue)) {
                $j("#errorMsg").text("한글 입력은 사용할 수 없습니다.");
                filteredValue = inputValue.replace(/[ㄱ-ㅎㅏ-ㅣ가-힣]/g, ''); // 한글 제거
                $j(this).val(filteredValue);
            } else { // 한글 입력이 없으면서 기존 에러 메시지가 없는 경우에만 에러 메시지를 지움
                $j("#errorMsg").text("");
            }

        });
        $j("#inputName").on("input", function(event) {
            var inputValue = $j(this).val();

            if (/[^ㄱ-ㅎㅏ-ㅣ가-힣]/.test(inputValue)) {
                $j("#errorMsg").text("한글만 입력 가능합니다.");
                var filteredValue = inputValue.replace(/[^ㄱ-ㅎㅏ-ㅣ가-힣]/g, ''); // 한글만 남기고 제거
                $j(this).val(filteredValue);
            } else if (inputValue.length > 5) {
                $j("#errorMsg").text("이름은 최대 5자까지 입력 가능합니다.");
                $j(this).val(inputValue.slice(0, 5));
            } else {
            
                $j("#errorMsg").text(""); // 한글 입력이 없으면 에러 메시지를 지움
            }
        });
        //핸드폰 번호 
        $j("#inputPhone2, #inputPhone3").on("input", function(event) {
            var inputValue = $j(this).val();

            // 입력값이 4자리 이상이면 입력을 막습니다.
            if (inputValue.length > 4) {
                $j(this).val(inputValue.slice(0, 4));
            }
        });
        $j("#inputAddr2").on("input", function(event) {
            var inputValue = $j(this).val();

            if (inputValue.length > 50) {
                $j(this).val(inputValue.slice(0, 50));
                $j("#errorMsg").text("주소명은 최대 50글자까지 입력가능합니다 "); 
            } else {
            	$j("#errorMsg").text("");
            }
        });
        
        $j("#inputCompany").on("input", function(event) {
            var inputValue = $j(this).val();

            if (inputValue.length > 20) {
                $j(this).val(inputValue.slice(0, 20));
                $j("#errorMsg").text("회사명은 최대 20글자까지 입력가능합니다 "); 
            } else {
            	$j("#errorMsg").text("");
            }
        });
        
        $j("#inputAddr1").on("input", function(event) {
            var inputValue = $j(this).val();

            if (inputValue.length > 7) {
                $j(this).val(inputValue.slice(0, 7));
               return
            }
            var pattern = /^\d{3}-\d{3}$/;

            if (!pattern.test(inputValue)) {
                $j("#errorMsg").text("숫자와 하이픈(-)로만 된 xxx-xxx 형식으로 입력해주세요.");
                $j(this).val(inputValue.replace(/[^0-9-]/g, '')); // 숫자와 하이픈(-) 이외의 문자 제거
            } else {
                $j("#errorMsg").text(""); 
            }
            // 세 자리마다 하이픈(-) 붙이기            
			 if ( inputValue.length === 3 && inputValue.indexOf('-') === -1) {
		        $j(this).val(inputValue + "-");
		        autoHyp = true
		    } 
        });
        $j("#inputAddr1").on("keyup", function(event) {
            var inputValue = $j(this).val();
            
            var formattedValue = inputValue.replace(/(\d{3})(?=\d)/g, '$1-');
            $j(this).val(formattedValue);
            
            if (event.keyCode === 8 && inputValue[inputValue.length - 1] === '-' && inputValue.length % 4 === 0) {
                // Remove the hyphen
                $j(this).val(inputValue.slice(0, -1));
            }
        });
        
    });

	function validateForm() {
	    var userId = $j("#inputId").val().trim();
	    var userPw = $j("#inputPw").val().trim();
	    var userPwCheck = $j("#inputPwCheck").val().trim();
	    var userName = $j("#inputName").val().trim();
	    var userPhone1 = $j("#inputPhone1").val().trim();
	    var userPhone2 = $j("#inputPhone2").val().trim();
	    var userPhone3 = $j("#inputPhone3").val().trim();
	    var userAddr1 = $j("#inputAddr1").val().trim();
	    var userAddr2 = $j("#inputAddr2").val().trim();
	    var userCompany = $j("#inputCompany").val().trim();
	    console.log(userId);
	    if (!userId) {
	        alert("아이디를 입력하세요.");
	        $j("#inputId").focus();
	        return false;
	    }
	    if (!userPw) {
	        alert("비밀번호를 입력하세요.");
	        $j("#inputPw").focus();
	        return false;
	    }
	    if (!userPwCheck) {
	        alert("비밀번호 확인을 입력하세요.");
	        $j("#inputPwCheck").focus();
	        return false;
	    }
	    
	    // 비밀번호 확인
	    if (userPwCheck && userPw !== userPwCheck) {
	        alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
	        $j("#inputPwCheck").focus();
	        return false;
	    }

	    // 비밀번호 길이 확인
	    if (userPw.length < 6 || userPw.length > 12) {
	        alert("비밀번호는 6자 이상, 12자 이하로 입력해주세요.");
	        $j("#inputPw").focus();
	        return false;
	    }
	    
	    if (!userName) {
	        alert("이름을 입력하세요.");
	        $j("#inputName").focus();
	        return false;
	    }
	    if (!checkId) {
	        alert("아이디 중복검사를 확인해주세요.");
	        $j("#checkDuplicate").focus();
	        return false;
	    }
	    if(!userPhone2) {
	    	alert("가운데 전화번호를 입력하세요.")
	    	$j("#inputPhone2").focus();
	    	return false;
	    }
	    if(!userPhone3) {
	    	alert("마지막 전화번호를 입력하세요.")
	    	$j("#inputPhone3").focus();
	    	return false;
	    }
	   
	    // 전화번호 길이 확인
	    if (userPhone2.length !== 4 ) {
	        alert("전화번호를 정확히 입력해주세요. ex)010-1234-1234");
	        $j("#inputPhone2").focus();
	        return false;
	    }
	    if (userPhone3.length !== 4) {
	        alert("전화번호를 정확히 입력해주세요. ex)010-1234-1234");
	        $j("#inputPhone3").focus();
	        return false;
	    }


	    // 우편번호 형식 확인
	    if (userAddr1 && !/^\d{3}-\d{3}$/.test(userAddr1)) {
	        alert("우편번호를 xxx-xxx 형식으로 입력해주세요.");
	        $j("#inputAddr1").focus();
	        return false;
	    }
	    if (userAddr2.length > 30 ) {
	        alert("주소명은 최대 50글자로 입력해주세요");
	        $j("#inputAddr2").focus();
	        return false;
	    }
	    if (userCompany.length > 30 ) {
	        alert("회사명은 최대 20글자로 입력해주세요");
	        $j("#inputCompany").focus();
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
								type="text">  <button type="button" id="checkDuplicate">중복체크</button></td>
						</tr>
						<tr>
							<td align="center" width="80">pw</td>
							<td><input name="userPw" id="inputPw" type="password"></td>
						</tr>
						<tr>
							<td align="center" width="80">pw check</td>
							<td><input id="inputPwCheck" type="password"></td>
						</tr>
						<tr>
							<td align="center" width="80">name</td>
							<td><input name="userName" id="inputName" type="text"></td>
						</tr>
						<tr>
							<td align="center" width="80">phone</td>
							<td><select name="userPhone1" id="inputPhone1">
									<c:forEach items="${codeList}" var="list">
										<option value="${list.codeName}">${list.codeName}</option>
									</c:forEach>
							</select>-
							<input id="inputPhone2" style="width:70px;" type="number" name="userPhone2">-
							<input id="inputPhone3" style="width:70px;" type="number"  maxlength="4" name="userPhone3"></td>
						</tr>
						<tr>
							<td align="center" width="80">postNo</td>
							<td><input name="userAddr1" id="inputAddr1" type="text" placeholder="xxx-xxx"></td>
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
				<td><span id="errorMsg" style="color:red"></span>
				<span style="float:right" id="joinBtn">join</span>
				</td>
			</tr>
			


		</table>
	</form>

</body>
</html>