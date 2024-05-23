<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>mbti Result</title>
</head>
<script type="text/javascript">
    $j(document).ready(function(){
    
        
    });
</script>

<body>
    <table align="center">
        <tr>
            <td id="">
                mbti Result
            </td> 
        </tr>
  		<tr>
  			<td>
  			${mbti}
  			</td>
  		</tr>
        <tr>
            <td align="center">
                        
                <a href="/board/boardList.do">boardList</a>            
            </td>
        </tr>
    </table>
</body>
</html>
