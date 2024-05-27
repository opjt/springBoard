package com.spring.recruit.service.impl;

import java.time.LocalDate;
import java.time.Period;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.recruit.dao.RecruitDao;
import com.spring.recruit.service.RecruitService;
import com.spring.recruit.vo.CareerVo;
import com.spring.recruit.vo.CertificateVo;
import com.spring.recruit.vo.EducationVo;
import com.spring.recruit.vo.RecruitVo;

@Service
public class RecruitServiceImpl implements RecruitService{
	
	@Autowired
	RecruitDao recruitDao;
	
	private String findLongestEducation(List<EducationVo> eduList) {
	    EducationVo longestEducation = null;
	    int maxYears = 0;

	    for (EducationVo education : eduList) {
	    	String startDate = education.getStartPeriod();
	        String endDate = education.getEndPeriod();
	        
	        String[] startParts = startDate.split("\\.");
	        String[] endParts = endDate.split("\\.");

	        int startYear = Integer.parseInt(startParts[0]);
	        int endYear = Integer.parseInt(endParts[0]);
	        
	        // 연도 차이를 계산하여 교육 기간의 연 수를 구함
	        int years = endYear - startYear;
	        if(education.getSchoolName() == null) {
	        	continue;
	        }
	        if(education.getSchoolName().contains("고등") ) {
	        	years = years - 2;
	        }
	        if (years > maxYears) {
	            maxYears = years;
	            longestEducation = education;
	        }
	    }
	    System.out.println(maxYears);
	    if(longestEducation.getSchoolName() == null) {
	    	return "";
	    }
	    if (maxYears >= 4 && longestEducation.getSchoolName().contains("대학")) {
	        return "대학교(4년 ) " + longestEducation.getDivision();
	    } 
	    if (maxYears >= 2 && longestEducation.getSchoolName().contains("대학")) {
	        return "전문대(2년) " + longestEducation.getDivision();
	    } 
	    if (longestEducation.getSchoolName().contains("고등")) {
	        return "고등학교 " + longestEducation.getDivision();
	    }
	    return "";
	}
	
	private String calculateCareer(List<CareerVo> creList) {
		int totalYears = 0;
        int totalMonths = 0;

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM");

        for (CareerVo period : creList) {
        	if(period.getStartPeriod() == null || period.getEndPeriod() == null  ) {
				continue;
			}
            YearMonth start = YearMonth.parse(period.getStartPeriod(), formatter);
            YearMonth end = YearMonth.parse(period.getEndPeriod(), formatter);

            totalYears += end.getYear() - start.getYear();
            totalMonths += end.getMonthValue() - start.getMonthValue();
        }

        while (totalMonths < 0) {
            totalYears -= 1;
            totalMonths += 12;
        }

        totalYears += totalMonths / 12;
        totalMonths = totalMonths % 12;

        return totalYears + "년 " + totalMonths + "개월";
	}
    
	@Override
	public RecruitVo findUser(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return recruitDao.findUser(recruitVo);
	}

	@Override
	public int recruitUpdate(RecruitVo recruitVo) throws Exception {
		
		RecruitVo findUser = recruitDao.findUser(recruitVo);
		if(findUser == null) {
			return recruitDao.insertRecruit(recruitVo);
		}
		return recruitDao.updateRecruit(recruitVo);
	}

	@Override
	public int updateEducation(List<EducationVo> eduVoList) throws Exception {
		
		return recruitDao.updateEducation(eduVoList);
	}

	@Override
	public List<EducationVo> selectEducation(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return recruitDao.selectEducation(recruitVo);
	}

	@Override
	public int updateEducation(List<EducationVo> eduVoList, String seq) throws Exception {
		
		recruitDao.deleteEducation(seq);
		return recruitDao.updateEducation(eduVoList);
	}

	@Override
	public Map<String, String> setUserInfo(Map<String, Object> userInfoMap) throws Exception {
		// TODO Auto-generated method stub
		Map<String, String> infoTable = new HashMap<>();
		RecruitVo recruitVo =  (RecruitVo) userInfoMap.get("recruit");
		List<EducationVo> eduList = (List<EducationVo>) userInfoMap.get("eduList");//학력
		List<CareerVo> creList = (List<CareerVo>) userInfoMap.get("creList"); //경력 
		
		infoTable.put("salary", "회사내규에 따름");
		infoTable.put("location", recruitVo.getLocation());
		infoTable.put("workType", recruitVo.getWorkType());
		if(eduList.size() > 0) {
			infoTable.put("education", findLongestEducation(eduList));	
		}
		if(creList.size() > 0) {
			infoTable.put("career", calculateCareer(creList));	
		}
		
		return infoTable;
	}



	@Override
	public int updateCareer(List<CareerVo> creVoList, String seq) throws Exception {
		// TODO Auto-generated method stub
		recruitDao.deleteCareer(seq);
		return recruitDao.updateCareer(creVoList);
	}

	@Override
	public List<CareerVo> selectCareer(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return recruitDao.selectCareer(recruitVo);
	}

	@Override
	public int updateCertificate(List<CertificateVo> cerVoList, String seq) throws Exception {
		// TODO Auto-generated method stub
		recruitDao.deleteCertificate(seq);
		return recruitDao.updateCertificate(cerVoList);
	}

	@Override
	public List<CertificateVo> selectCertificate(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return recruitDao.selectCertificate(recruitVo);
	}

}
