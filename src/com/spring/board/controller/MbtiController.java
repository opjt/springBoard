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
import com.spring.common.CommonUtil;
import com.spring.common.vo.CodeVo;

@Controller
public class MbtiController {
	@Autowired
	boardService boardService;

	@RequestMapping(value = "/mbti/test.do", method = RequestMethod.GET)
	public String mbtiTest(Locale locale, Model model) throws Exception {

		List<CodeVo> codeList = boardService.selectCodeList();

		Map<String, String> codeMap = new HashMap<>();
		for (CodeVo code : codeList) {
			codeMap.put(code.getCodeId(), code.getCodeName());

		}
		model.addAttribute("codeMap", codeMap);

		return "board/mbtiTest";
	}
	@RequestMapping(value = "/mbti/resultPage.do", method = RequestMethod.GET)
	public String mbtiResult(Locale locale, Model model,@RequestParam(value = "mbti", required = false) String mbti) throws Exception {


		model.addAttribute("mbti", mbti);

		return "board/mbtiResult";
	}

	@RequestMapping(value = "/mbti/getQuestion.do", method = RequestMethod.GET)
	@ResponseBody //
	public Map<String, Object> boardList(Locale locale) throws Exception {

		Map<String, Object> resultMap = new HashMap<>(); // 리턴Map

		PageVo pageVo = new PageVo();
		List<BoardVo> boardList = new ArrayList<BoardVo>();

		ArrayList<String> mbtiList = new ArrayList<>();
		mbtiList.add("EI");
		mbtiList.add("IE");
		mbtiList.add("SN");
		mbtiList.add("NS");
		mbtiList.add("TF");
		mbtiList.add("FT");
		mbtiList.add("JP");
		mbtiList.add("PJ");

		pageVo.setBoardCodeList(mbtiList);
		pageVo.setPageNo(1);
		pageVo.setShowCount(20); // 5문항식 4페이지
		pageVo.setCheckBoardType(false);

		boardList = boardService.SelectBoardList(pageVo);

		resultMap.put("board", boardList);

		return resultMap;
	}

	@RequestMapping(value = "/mbti/calculate.do", method = RequestMethod.POST)
	@ResponseBody
	public String handleMbtiResult(@RequestBody List<Map<String, Object>> answers) throws Exception{
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		Map<String, Integer> mbtiScores = new HashMap<>();
		mbtiScores.put("E", 0);
		mbtiScores.put("I", 0);
		mbtiScores.put("S", 0);
		mbtiScores.put("N", 0);
		mbtiScores.put("T", 0);
		mbtiScores.put("F", 0);
		mbtiScores.put("J", 0);
		mbtiScores.put("P", 0);

		// 각 질문 유형에 따른 점수 누적
		for (Map<String, Object> answer : answers) {
			String type = (String) answer.get("type");
			int value = (int) answer.get("value");

			if (value <= 3) { //3보다 같거나 작을경우 1:매우동의 2:동의 3:약간동의 
				int agree = (4 - value);
				mbtiScores.put(type.substring(0, 1), mbtiScores.get(type.substring(0, 1)) + (agree));
			} else if (value >= 5) { //5보다 클경우 7:매우비동의 6:비동의 5:야간비동의 
				int disagree = (value - 4);
				mbtiScores.put(type.substring(1, 2), mbtiScores.get(type.substring(1, 2)) + (disagree));
			}
		}

		// E/I, S/N, T/F, J/P 비교하여 MBTI 조합 만들기
		StringBuilder mbtiBuilder = new StringBuilder();

		// E/I 유형 비교
		if (mbtiScores.get("E") >= mbtiScores.get("I")) {
		    mbtiBuilder.append("E");
		} else {
		    mbtiBuilder.append("I");
		}

		// S/N 유형 비교
		if (mbtiScores.get("N") >= mbtiScores.get("S")) {
		    mbtiBuilder.append("N");
		} else {
		    mbtiBuilder.append("S");
		}

		// T/F 유형 비교
		if (mbtiScores.get("F") >= mbtiScores.get("T")) {
		    mbtiBuilder.append("F");
		} else {
		    mbtiBuilder.append("T");
		}

		// J/P 유형 비교
		if (mbtiScores.get("J") >= mbtiScores.get("P")) {
		    mbtiBuilder.append("J");
		} else {
		    mbtiBuilder.append("P");
		}

		String mbtiResult = mbtiBuilder.toString();
		
		result.put("success", mbtiResult);
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
}
