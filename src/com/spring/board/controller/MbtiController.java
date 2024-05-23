package com.spring.board.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.board.service.boardService;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.PageVo;
import com.spring.common.vo.CodeVo;

@Controller
public class MbtiController {
	@Autowired
	boardService boardService;
	
	@RequestMapping(value = "/mbti/test.do", method = RequestMethod.GET)
	public String mbtiTest(Locale locale, Model model) throws Exception{
		
		List<CodeVo> codeList = boardService.selectCodeList();
		
		Map<String, String> codeMap = new HashMap<>();
		for (CodeVo code : codeList) {
		    codeMap.put( code.getCodeId(), code.getCodeName());
		
		}
		model.addAttribute("codeMap", codeMap);
		
		return "board/mbtiTest";
	}
	
	@RequestMapping(value = "/mbti/getQuestion.do", method = RequestMethod.GET)
	@ResponseBody // 
	public Map<String, Object> boardList(Locale locale) throws Exception {
	   
		Map<String, Object> resultMap = new HashMap<>(); //리턴Map
		
		PageVo pageVo = new PageVo();
		List<BoardVo> boardList = new ArrayList<BoardVo>();
		List<String> pageCodeList = new ArrayList<>();
		List<CodeVo> codeList = boardService.selectCodeList();
		
		for(CodeVo code : codeList) {
			if(code.getCodeType().equals("menu") && code.getCodeId().contains("mbti")) {
				pageCodeList.add(code.getCodeId());
			}
		}
		
		pageVo.setBoardCodeList(pageCodeList);
		pageVo.setPageNo(1); 
		pageVo.setShowCount(20); //5문항식 4페이지 
		
		//codeList를 map형식으로 반환 key:codeId, value:codeName
		Map<String, String> codeMap = new HashMap<>();
		for (CodeVo code : codeList) {
		    codeMap.put( code.getCodeId(), code.getCodeName());
		
		}
		
		boardList = boardService.SelectBoardList(pageVo);
		
		
		resultMap.put("code", codeMap);
	    resultMap.put("board", boardList);
		
	    return resultMap;
	}
	
	
	
	
	@RequestMapping(value = "/mbti/result.do", method = RequestMethod.POST)
    public String handleMbtiResult(Model model, @RequestParam(value = "E") int E,
                                   @RequestParam(value = "I") int I,
                                   @RequestParam(value = "S") int S,
                                   @RequestParam(value = "N") int N,
                                   @RequestParam(value = "T") int T,
                                   @RequestParam(value = "F") int F,
                                   @RequestParam(value = "J") int J,
                                   @RequestParam(value = "P") int P) {
		System.out.println("E:" + E);
		System.out.println("I:" + I);
        String eiDimension = (E >= I) ? "E" : "I";
        String snDimension = (N >= S) ? "N" : "S";
        String tfDimension = (F >= T) ? "F" : "T";
        String jpDimension = (J >= P) ? "J" : "P";
        
        // MBTI 유형 결정
        String mbtiType = eiDimension + snDimension + tfDimension + jpDimension;
        
        System.out.println("MBTI 유형: " + mbtiType);
        model.addAttribute("mbti",mbtiType);
        
        return "board/mbtiResult"; // 결과 페이지로 리다이렉트
    }
}
