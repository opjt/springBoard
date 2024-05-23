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