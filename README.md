# 일경험 스프링 게시판 프로젝트 



## Day1 24-05-20
- 프로젝트 구조 설명 및 설치
- 게시글 수정, 삭제 기능 추가(완료)



## Day2 24-05-21

### 게시판 타입 (완료)
- 글작성시 COM_CODE 테이블에서 CODE_TYPE이 'menu'인 값을 불러와 게시글타입으로 사용
- 글목록에서 게시판 타입 표시
- 게시판 타입 선택하여 조회 기능(Ajax,form)

### 유저 로그인 기능 (진행)
- 로그인, 회원가입 페이지 제작
- 회원가입시 유효성 검사, 아이디 중복확인 검사



## Day3 24-05-22

### 유저 로그인,회원가입 (완료)
- 회원가입시 db에 있는 전화번호 앞자리 연동
- 회원가입 유효성 검사 입력 안 되어 있는 부분 포커싱
- 글 작성시 유저 이름 creator로 표시
 
### 글 동시작성 (진행)
- 행추가 버튼 클릭하여 한번에 여러개 게시글 등록 가능
- 행 삭제 버튼으로 해당 행 삭제 가능
- 컨트롤러에서 List<BoardVo.> 형태로 변환하여 게시글 등록

### 트러블슈팅
- JSP내 js에서 백틱내 ${}로 변수 사용시 \를 앞에 붙여줘야 인식  
- Error class java.util.LinkedHashMap cannot be cast to class

```java
public String boardsAdd(@RequestBody List<BoardVo> boardList) throws Exception{
    for (BoardVo board : boardList) {
        logger.info(board.getBoardTitle());
    }
}
```
수정 
```java
public String boardsAdd(@RequestBody Map<String, Object>[] boardList) throws Exception {
    ObjectMapper mapper = new ObjectMapper();
    List<BoardVo> convertedList = new ArrayList<>();
    for (Map<String, Object> map : boardList) {
        BoardVo board = mapper.convertValue(map, BoardVo.class);
        convertedList.add(board);
    }
}
```

## Day4 24-05-23

### 글 동시작성 (완료)

### mbti 검사 만들기 (진행)
- [https://www.16personalities.com/ko/](https://www.16personalities.com/ko/)
- BOARD 테이블의 BOARD_TYPE을 사용하여 유형 생성 및 구분 문항은 BOARD_COMMENT를 사용하여 리스트 생성   
유형 - EI, IE, NS, SN, FT, TF, JP, PJ  
동의 비동의 선택은 radio버튼으로 구현
- 기존 pageVo에 showCount, checkBoardType 필드를 추가하여 기존 코드를 재활용함
- 유형별 페이지당 5문항씩 4페이지 생성  
선택 결과는 모든 질문의 유형점수를 더하여 각 지표에서 더 높은 점수를 받은 성격 유형이라고 판단
- Radio 선택 값은 1 - 7  
```
점수 배치 예)    
E 의 질문인 경우
매우 동의 – E : 3점
동의 – E : 2점
약갂 동의 – E : 1점
모르겠음 – 0점
약갂 비동의 – I : 1점
비동의 – I : 2점
매우 비동의 – I : 3점
합산 점수가 같거나 모두 0점인경우 사전순
으로 빠른 유형 출력
Radio버튼을 모두 선택한 후
다음 페이지로 이동
```
- 4페이지 답변을 모두 선택한 후 각 페이지에서 동의 비동의 radio 선택한 값을 통해 I 또는 E , S 또는 N, F 또는 T, P 또는 J 를 반환시켜 MBTI 결과 출력 페이지 구현

## Day5 24-05-24

### mbti 검사 만들기 (완료)
- 클라이언트에서 진행하던 점수 계산을 백단에서 진행하는 형식으로 변경
- CASE문 활용하여 점수계산 로직 직관성 있게 수정

### 입사지원 만들기 (진행)
- 로그인 프론트 페이지 개발(이름,휴대폰번호 입력)
- 입사지원서 폼 학력,경력,자격증 추가 버튼 클릭하여 행 추가 
```jsp
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
```        
- 저장 버튼 클릭시 입력한 값으로 하여 디비에 저장

### 트러블 슈팅
JSP에서 form로 데이터 보낼 때 한글 깨짐현상  

webapp/web.xml 수정 
```xml
<filter>
    <filter-name>encodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>	
        <param-value>UTF-8</param-value>
    </init-param>
</filter>	
<filter-mapping>	
    <filter-name>encodingFilter</filter-name>	
    <url-pattern>/*</url-pattern>
</filter-mapping>
```
servlet-context.xml
```xml
<beans:bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">		   
    <beans:property name="prefix" value="/WEB-INF/views/" />	
	<beans:property name="suffix" value=".jsp" />
    <beans:property name="contentType" value="text/html; charset=UTF-8"/>	<!-- 한글 utf-8 -->	
</beans:bean>
```

## Day6 24-05-27

### 입사지원 만들기 (진행)
- 학력,경력,자격증 저장 및 불러오기 기능 추가
- 이력서 제출 기능 추가 (제출시 더이상 수정 불가)
- 필수입력사항 유효성 검사 실시(기본정보,학력)
- 학력입력시 최고학력 정보 표출(ex 대학교 4년제 졸업)(수정필요)
- 경력입력시 경력종합하여 n년 n개월 정보 표출
- YYYY.MM 형식 날짜 입력시 자동으로 . 붙도록 기능 추가
```js
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
```


### 트러블 슈팅
행추가시 .dateInput 이벤트 작동 안하는 현상 document에 이벤트를 적용함으로서 동적으로 생성되는 요소에 대응함
```js
//기존 코드
$j(".dateInput").on("input", function(event) {
}
//수정 콛
$j(document).on("input", ".dateInput", function(event) {
}

```