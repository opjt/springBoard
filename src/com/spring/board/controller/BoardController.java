package com.spring.board.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.ibatis.type.TypeReference;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.board.service.boardService;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.PageVo;
import com.spring.common.CommonUtil;
import com.spring.common.vo.CodeVo;

@Controller
public class BoardController {
	
	@Autowired 
	boardService boardService;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/board/boardList.do", method = RequestMethod.GET)
	public String boardList(Locale locale, Model model,PageVo pageVo,
			@RequestParam(value = "codes", required = false) String codes) throws Exception{
		
		List<BoardVo> boardList = new ArrayList<BoardVo>();
		int page = 1;
		int totalCnt = 0;
		if(pageVo.getPageNo() == 0){
			pageVo.setPageNo(page);;
		}
		if (codes != null && codes.length() != 0) {
	        // codes 파라미터 값을 ","로 분리하여 List<String>으로 변환
	        List<String> codeList = Arrays.asList(codes.split(","));
	        pageVo.setBoardCodeList(codeList);
	    }
		
		boardList = boardService.SelectBoardList(pageVo);
		totalCnt = boardService.selectBoardCnt();
		//codeList를 map형식으로 반환 key:codeId, value:codeName
		List<CodeVo> codeList = boardService.selectCodeList();
		Map<String, String> codeMap = new HashMap<>();
		for (CodeVo code : codeList) {
		    codeMap.put( code.getCodeId(), code.getCodeName());
		}
		
		model.addAttribute("codeList", codeList);
		model.addAttribute("codeMap", codeMap);
		model.addAttribute("boardList", boardList);
		model.addAttribute("totalCnt", totalCnt);
		model.addAttribute("pageNo", page);
		
		return "board/boardList";
	}
	
	@RequestMapping(value = "/board/getBoards.do", method = RequestMethod.GET)
	@ResponseBody // 반환되는 데이터를 HTTP 응답 본문으로 사용
	public Map<String, Object> boardList(Locale locale, PageVo pageVo,
	        @RequestParam(value = "codes", required = false) String codes) throws Exception {
	   
		Map<String, Object> resultMap = new HashMap<>();
	    List<BoardVo> boardList = new ArrayList<BoardVo>();
	    int page = 1;
	    
	    if (pageVo.getPageNo() == 0) {
	        pageVo.setPageNo(page);
	    }
	    
	    if (codes != null && codes.length() != 0) {
	    	 List<String> paramCodeList = Arrays.asList(codes.split(","));
		     pageVo.setBoardCodeList(paramCodeList);
		         
	    }
	    
	    List<CodeVo> codeList = boardService.selectCodeList();
        Map<String, String> codeMap = new HashMap<>();
        for (CodeVo code : codeList) {
            codeMap.put((String)code.getCodeId(), code.getCodeName());
        }
        
	    boardList = boardService.SelectBoardList(pageVo);
	    resultMap.put("code", codeMap);
	    resultMap.put("board", boardList);
	    return resultMap;
	}

	
	@RequestMapping(value = "/board/{boardType}/{boardNum}/boardView.do", method = RequestMethod.GET)
	public String boardView(Locale locale, Model model
			,@PathVariable("boardType")String boardType
			,@PathVariable("boardNum")int boardNum) throws Exception{
		
		BoardVo boardVo = new BoardVo();
		
		
		boardVo = boardService.selectBoard(boardType,boardNum);
		List<CodeVo> codeList = new ArrayList<CodeVo>();
		codeList = boardService.selectCodeList(); //코드 목록 불러오
		Map<String, String> codeMap = new HashMap<>();
		for (CodeVo code : codeList) {
		    codeMap.put(code.getCodeId(), code.getCodeName());
		}
		
		model.addAttribute("codeList", codeList);
		model.addAttribute("codeMap", codeMap);
		model.addAttribute("boardType", boardType);
		model.addAttribute("boardNum", boardNum);
		model.addAttribute("board", boardVo);
		
		return "board/boardView";
	}
	
	//게시판 수정
	@RequestMapping(value = "/board/{boardType}/{boardNum}/boardModify.do", method = RequestMethod.GET)
	public String boardModify(Locale locale, Model model
			,@PathVariable("boardType")String boardType
			,@PathVariable("boardNum")int boardNum) throws Exception{
		
		BoardVo boardVo = new BoardVo();
		
		boardVo = boardService.selectBoard(boardType,boardNum);
		List<CodeVo> codeList = new ArrayList<CodeVo>();
		codeList = boardService.selectCodeList(); //코드 목록 불러오
		Map<String, String> codeMap = new HashMap<>();
		for (CodeVo code : codeList) {
		    codeMap.put(code.getCodeId(), code.getCodeName());
		}
		
		model.addAttribute("codeMap", codeMap);
		model.addAttribute("codeList", codeList);
		model.addAttribute("boardType", boardType);
		model.addAttribute("boardNum", boardNum);
		model.addAttribute("board", boardVo);

		return "board/boardModify";
	}
	@RequestMapping(value = "/board/boardModifyAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String boardModifyAction(Locale locale,BoardVo boardVo) throws Exception{
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		int resultCnt = boardService.boardModify(boardVo);
		
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	@RequestMapping(value = "/board/{boardType}/{boardNum}/boardDeleteAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String boardDeleteAction(Locale locale,@PathVariable("boardType")String boardType
			,@PathVariable("boardNum")int boardNum) throws Exception{
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		BoardVo boardVo = new BoardVo();
		boardVo.setBoardNum(boardNum);
		boardVo.setBoardType(boardType);
		
		int resultCnt = boardService.boardDelete(boardVo);
		
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	//글 작성 
	@RequestMapping(value = "/board/boardWrite.do", method = RequestMethod.GET)
	public String boardWrite(Locale locale, Model model) throws Exception{
		
		List<CodeVo> codeList = new ArrayList<CodeVo>();
		codeList = boardService.selectCodeList(); //코드 목록 불러오
		model.addAttribute("codeList", codeList);
		
		return "board/boardWrite";
	}
	
	
	@RequestMapping(value = "/board/boardWriteAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String boardsAdd(@RequestBody Map<String, Object>[] boardList) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        List<BoardVo> convertedList = new ArrayList<>();
        HashMap<String, String> result = new HashMap<String, String>();
        CommonUtil commonUtil = new CommonUtil();

        for (Map<String, Object> map : boardList) {
            BoardVo board = mapper.convertValue(map, BoardVo.class);
            convertedList.add(board);
        }
        int resultCnt = 0;
        for (BoardVo board : convertedList) {
        	int returnCount = boardService.boardInsert(board);
        	resultCnt+= returnCount;
        }
        
        result.put("success", (resultCnt == convertedList.size())?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	

	
}
