<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>mbti Test</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<script type="text/javascript">
    $j(document).ready(function(){
    	 var currentPage = 0;
    	 var mbtiScores = {
    	            E: 0,
    	            I: 0,
    	            S: 0,
    	            N: 0,
    	            T: 0,
    	            F: 0,
    	            J: 0,
    	            P: 0
    	 	};
    	 
        $j.ajax({
            type: "GET",
            url: "/mbti/getQuestion.do",
            success: function(data, textStatus, jqXHR) {
                var questions = data.board;
                var tableContent = '';
                var questionCount = questions.length;
                var questionsPerSection = 5;

                for (var i = 0; i < questionCount; i++) {
                    if (i % questionsPerSection === 0) {
                        if (i !== 0) {
                            tableContent += '</table>'; // Close the previous table
                        }
                        tableContent += `<table border="1" class="questSection" id="questPage-\${i / questionsPerSection}">`; // Start a new table
                    }

                    var question = questions[i];
                    tableContent += '<tr>';
                    tableContent += '<td align="center" width="500">' + question.boardComment + '</td>';
                    tableContent += '</tr>';
                    tableContent += '<tr>';
                    tableContent += '<td align="center">';
                    tableContent += '동의 ';
                    for (var j = 1; j <= 7; j++) {
                        tableContent += '<input type="radio" name="question' + i + '" value="' + j + '" data-type="' + question.boardType + '"> ';
                    }
                    tableContent += '비동의';
                    tableContent += '</td>';
                    tableContent += '</tr>';
                }
                tableContent += '</table>'; // Close the last table

                $j('#questionSection').html(tableContent);
                
                $j('.questSection').hide();
                $j('#pagePrev').hide();
                $j('#pageSubmit').hide();
                $j('#questPage-0').show();
            },
            error: function(xhr, status, error) {
                console.error(xhr.responseText);
            }
        });
        
        $j('#pageNext').click(function() {
        	/* if (!validatePage(currentPage)) {
                alert("모든 질문에 답변해 주세요.");
                return;
            }  */
            $j('#pageSubmit').hide();
            var nextPage = currentPage + 1;
            if ($j('#questPage-' + nextPage).length > 0) {
                $j('#questPage-' + currentPage).hide();
                $j('#questPage-' + nextPage).show();
                currentPage = nextPage;
                $j('#pagePrev').show();
                $j('#pageInfo').text( currentPage+1 + "/4")
            }

            // 마지막 페이지일 때 다음 버튼 숨기기
            if ($j('#questPage-' + (currentPage + 1)).length === 0) {
                $j('#pageNext').hide();
                $j('#pageSubmit').show();
            }
        });

        function validatePage(page) {
            var valid = true;
            $j(`#questPage-\${page} input[type=radio]`).each(function() {
                var name = $j(this).attr('name');
                if ($j(`input[name='\${name}']:checked`).length === 0) {
                    valid = false;
                    return false; // break out of each loop
                }
            });
            return valid;
        }
        
        $j('#pagePrev').click(function() {
        	$j('#pageSubmit').hide();
        	
            var prevPage = currentPage - 1;
            if ($j('#questPage-' + prevPage).length > 0) {
                $j('#questPage-' + currentPage).hide();
                $j('#questPage-' + prevPage).show();
                currentPage = prevPage;
                $j('#pageNext').show();
                $j('#pageInfo').text(currentPage+1 + "/4")
            }

            // 첫 페이지일 때 이전 버튼 숨기기
            if (currentPage === 0) {
                $j('#pagePrev').hide();
            }
        });
        
      
        
        $j('#pageSubmit').click(function() { 
        	 var answers = []; // 사용자의 답변을 저장할 배열
        	$j('input[type=radio]:checked').each(function() {
                var value = parseInt($j(this).val());
                var type = $j(this).data('type');
                answers.push({ type: type, value: value }); // 답변을 배열에 추가
             
            });
        	

            $j.ajax({
                type: "POST",
                url: "/mbti/calculate.do",
                data: JSON.stringify(answers), // 답변 데이터를 JSON 형식으로 전송
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(data) {
                    // 서버에서 계산된 MBTI 결과를 받아옴
                    var mbtiResult = data.success;
                    
					console.log(mbtiResult)
                    window.location.href = "/mbti/resultPage.do?mbti=" + mbtiResult;
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
            <td id="">
                mbti Test <span id="pageInfo">1/4</span>
            </td> 
        </tr>
        <tr>
            <td id="questionSection">
                <!-- AJAX로 질문들을 가져와서 이곳에 테이블을 동적으로 생성 -->
            </td>
        </tr>
        <tr>
            <td align="center">
            	<span id="pagePrev">
            		이전
            	</span>
                <span id="pageNext">
                    다음
                </span>            
                <span id="pageSubmit">
                    제출
                </span>            
            </td>
        </tr>
    </table>
</body>
</html>
