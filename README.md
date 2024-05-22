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

