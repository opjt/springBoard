package com.spring.recruit.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.common.vo.CodeVo;
import com.spring.recruit.service.RecruitService;
import com.spring.recruit.vo.RecruitVo;

@Controller
public class RecruitController {
	@Autowired
	RecruitService recruitService;

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@RequestMapping(value = "/recruit/login.do", method = RequestMethod.GET)
	public String login(Locale locale, Model model) throws Exception {

		return "recruit/login";
	}

	@RequestMapping(value = "/recruit/form.do", method = RequestMethod.POST)
	public String recruitForm(Locale locale, Model model, RecruitVo recruitVo) throws Exception {
//		logger.info(recruitVo.getPhone());

		String location[] = { "서울", "부산", "대구", "인천", "광주", "대전", "울산", "세종", "경기", "강원", "충북", "충남", "전북", "전남", "경북",
				"경남", "제주" };
		logger.info(recruitVo.toString());
		RecruitVo findUser = recruitService.findUser(recruitVo);
		if (findUser != null) {
			logger.info(findUser.toString());
			recruitVo = findUser;
		} else {
			logger.info("??");
		}

		model.addAttribute("location", location);
		model.addAttribute("userInfo", recruitVo);
		return "recruit/form";
	}

	@RequestMapping(value = "/recruit/save.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveBoardData(@RequestBody Map<String, List<Map<String, String>>> boardData) throws Exception {

		ObjectMapper objectMapper = new ObjectMapper();

		List<Map<String, String>> recruitFormDataList = boardData.get("recruitForm");
		if (recruitFormDataList != null && !recruitFormDataList.isEmpty()) {
			Map<String, String> recruitFormData = recruitFormDataList.get(0); 
			RecruitVo recruitVo = objectMapper.convertValue(recruitFormData, RecruitVo.class);
			int updateState = recruitService.recruitUpdate(recruitVo); 
			
			System.out.println(updateState);
		}

		for (Map.Entry<String, List<Map<String, String>>> entry : boardData.entrySet()) {
			String tableId = entry.getKey();
			List<Map<String, String>> data = entry.getValue();

			System.out.println("Table ID: " + tableId);
			for (Map<String, String> row : data) {
				System.out.println("Row Data: " + row);
			}
		}
		return "Data saved successfully";
	}

}
