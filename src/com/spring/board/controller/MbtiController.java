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
	public String mbtiResult(Locale locale, Model model, @RequestParam(value = "mbti", required = false) String mbti)
			throws Exception {

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
	public String handleMbtiResult(@RequestBody List<Map<String, Object>> answers) throws Exception {
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
			String mbtiType = type.substring(0, 1); // ex) EI 일 경우 E 값 저장

			switch (value) {
			case 1: // 매우 동의
				value = 3;
				break;
			case 2: // 동의
				value = 2;
				break;
			case 3: // 약간 동의
				value = 1;
				break;
			case 5: // 약간 비동의
				mbtiType = type.substring(1, 2);
				value = 1;
				break;
			case 6: // 비동의
				mbtiType = type.substring(1, 2);
				value = 2;
				break;
			case 7: // 매우 비동의
				mbtiType = type.substring(1, 2);
				value = 3;
				break;
			default:
				break;
			}

			int setValue = mbtiScores.get(mbtiType) + value;
			mbtiScores.put(mbtiType, setValue);

		}

		// E/I, S/N, T/F, J/P 비교하여 MBTI 조합 만들기
		StringBuilder mbtiBuilder = new StringBuilder();

		String[] types = { "EI", "SN", "TF", "JP" };
		for (String pair : types) {
			String type1 = pair.substring(0, 1);
			String type2 = pair.substring(1, 2);
			int score1 = mbtiScores.get(type1);
			int score2 = mbtiScores.get(type2);

			if (score1 > score2) {
				mbtiBuilder.append(type1);
			} else if (score1 < score2) {
				mbtiBuilder.append(type2);
			} else {
				mbtiBuilder.append(type1.compareTo(type2) < 0 ? type1 : type2); //알파벳 순으로 지정
			}
		}

		String mbtiResult = mbtiBuilder.toString();

		result.put("success", mbtiResult);
		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
		System.err.println(mbtiScores.toString());
		System.out.println("callbackMsg::" + callbackMsg);

		return callbackMsg;
	}
}
