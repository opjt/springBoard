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
                    alert("���ԿϷ�");
                    alert("�޼���:" + data.success);
                    location.href = "/board/boardList.do";
                },
                error : function(jqXHR, textStatus, errorThrown) {
                    alert("����");
                }
            });
        });
        
        $j("#checkDuplicate").on("click", function() {
            var userId = $j("#inputId").val();

            // userId�� �Էµ��� ���� ���
            if (!userId) {
                alert("����� ID�� �Է��ϼ���.");
                return;
            }

            // AJAX ��û���� �ߺ� üũ ����
            $j.ajax({
                url: "/user/checkIdAction.do",
                type: "GET",
                data: { userId: userId }, // userId ����
                success: function(data) {
                	console.log(data.result)
                    if (data.result === "N") {
                        alert("�̹� ��� ���� ID�Դϴ�.");
                    } else {
                        alert("��� ������ ID�Դϴ�.");
                        // �ߺ� üũ ���� �� ��ư ��Ȱ��ȭ
                        checkId = true;
                        $j("#checkDuplicate").prop("disabled", true);
                    }
                },
                error: function(xhr, status, error) {
                    alert("���� ������ �߻��߽��ϴ�.");
                }
            });
        });

        // ID �Է� �ʵ� �� ���� �̺�Ʈ
        $j("#inputId").on("input", function() {
            // ID �Է� ���� ����Ǹ� �ߺ� üũ ��ư Ȱ��ȭ
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
            alert("�ʼ� �Է°��� ��� �Է����ּ���.");
            return false;
        }
		if(!checkId) {
			alert("���̵� �ߺ��˻縦 Ȯ�����ּ���");
			return false
		}
        // ��й�ȣ Ȯ��
        if (userPw !== userPwCheck) {
            alert("��й�ȣ�� ��й�ȣ Ȯ���� ��ġ���� �ʽ��ϴ�.");
            return false;
        }

        // ��й�ȣ ���� Ȯ��
        if (userPw.length < 6 || userPw.length > 12) {
            alert("��й�ȣ�� 6�� �̻�, 12�� ���Ϸ� �Է����ּ���.");
            return false;
        }

        // ��ȭ��ȣ ���� Ȯ��
        if (userPhone2.length !== 4 || userPhone3.length !== 4) {
            alert("��ȭ��ȣ�� ��Ȯ�� �Է����ּ���.");
            return false;
        }

        // �����ȣ ���� Ȯ��
        if (!/^\d{3}-\d{3}$/.test(userAddr1)) {
            alert("�����ȣ�� xxx-xxx �������� �Է����ּ���.");
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
								type="text">  <button type="button" id="checkDuplicate">�ߺ� üũ</button></td>
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