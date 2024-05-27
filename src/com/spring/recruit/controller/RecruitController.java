package com.spring.recruit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.management.RuntimeErrorException;

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
import com.spring.recruit.vo.CareerVo;
import com.spring.recruit.vo.CertificateVo;
import com.spring.recruit.vo.EducationVo;
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

		Map<String, String> infoTable = new HashMap<>();
		String location[] = { "서울", "부산", "대구", "인천", "광주", "대전", "울산", "세종", "경기", "강원", "충북", "충남", "전북", "전남", "경북",
				"경남", "제주" };
		logger.info(recruitVo.toString());
		RecruitVo findUser = recruitService.findUser(recruitVo);
		if (findUser != null) {
			logger.info(findUser.toString());
			recruitVo = findUser;
			
			List<EducationVo> eduList = recruitService.selectEducation(recruitVo);
			List<CareerVo> creList = recruitService.selectCareer(recruitVo);
			List<CertificateVo> cerList = recruitService.selectCertificate(recruitVo);
			Map<String, Object> userInfoMap = new HashMap<>();
			
			userInfoMap.put("eduList", eduList);
	        userInfoMap.put("creList", creList);
	        userInfoMap.put("recruit", recruitVo);
	        
	        infoTable = recruitService.setUserInfo(userInfoMap);
	        model.addAttribute("infoTable", infoTable); //유저 요약정보 
			model.addAttribute("eduList", eduList); // 학력 정
			model.addAttribute("creList", creList); // 경력 정보 
			model.addAttribute("cerList", cerList); // 경력 정보 
		} 
		
		model.addAttribute("location", location); //전국 select
		model.addAttribute("userInfo", recruitVo); 
		return "recruit/form";
	}

	@RequestMapping(value = "/recruit/save.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveBoardData(@RequestBody Map<String, List<Map<String, String>>> boardData) throws Exception {

		ObjectMapper objectMapper = new ObjectMapper();

		Map<String, String> recruitFormData = boardData.get("recruitForm").get(0);
		RecruitVo recruitVo = objectMapper.convertValue(recruitFormData, RecruitVo.class);
		System.out.println(recruitVo.toString());
		int updateState = recruitService.recruitUpdate(recruitVo);

		System.out.println(updateState);
		RecruitVo userInfo = recruitService.findUser(recruitVo);

		List<EducationVo> eduVoList = new ArrayList<EducationVo>();
		List<CareerVo> creVoList = new ArrayList<CareerVo>();
		List<CertificateVo> cerVoList = new ArrayList<CertificateVo>();

		//학력
		int eduSeq = 1; 
		for (Map<String, String> row : boardData.get("formEducation")) {
			EducationVo eduVo = objectMapper.convertValue(row, EducationVo.class);
			eduVo.setSeq(userInfo.getSeq());
			eduVo.setEduSeq(String.valueOf(eduSeq++)); // 반복 인덱스로 EDU_SEQ 값을 설정하고, 인덱스 증가
			eduVoList.add(eduVo);
			System.out.println(eduVo.toString());
		}
		recruitService.updateEducation(eduVoList, userInfo.getSeq());
		
		// 경력
		int creSeq = 1; 
		for (Map<String, String> row : boardData.get("formCareer")) {
			CareerVo creVo = objectMapper.convertValue(row, CareerVo.class);
			
			creVo.setSeq(userInfo.getSeq());
			creVo.setCarSeq(String.valueOf(creSeq++)); // 
			creVoList.add(creVo);
			
		}
		recruitService.updateCareer(creVoList, userInfo.getSeq());
		
		// 자격증
		int cerSeq = 1; 
		for (Map<String, String> row : boardData.get("formCertificate")) {
			CertificateVo cerVo = objectMapper.convertValue(row, CertificateVo.class);
			cerVo.setSeq(userInfo.getSeq());
			cerVo.setCertSeq(String.valueOf(cerSeq++)); // 
			cerVoList.add(cerVo);
			
		}
		recruitService.updateCertificate(cerVoList, userInfo.getSeq());

//		for (Map.Entry<String, List<Map<String, String>>> entry : boardData.entrySet()) {
//			String tableId = entry.getKey();
//			List<Map<String, String>> data = entry.getValue();
//
//			System.out.println("Table ID: " + tableId);
//			for (Map<String, String> row : data) {
//				System.out.println("Row Data: " + row);
//			}
//		}
		return "Data saved successfully";
	}

}
