package com.spring.recruit.service;

import java.util.List;
import java.util.Map;

import com.spring.recruit.vo.CareerVo;
import com.spring.recruit.vo.CertificateVo;
import com.spring.recruit.vo.EducationVo;
import com.spring.recruit.vo.RecruitVo;

public interface RecruitService {

	RecruitVo findUser(RecruitVo recruitVo) throws Exception;

	int recruitUpdate(RecruitVo recruitVo) throws Exception;

	int updateEducation(List<EducationVo> eduVoList) throws Exception;

	List<EducationVo> selectEducation(RecruitVo recruitVo) throws Exception;

	int updateEducation(List<EducationVo> eduVoList, String seq) throws Exception;

	Map<String, String> setUserInfo(Map<String, Object> userInfoMap) throws Exception;

	int updateCareer(List<CareerVo> creVoList, String seq) throws Exception;

	List<CareerVo> selectCareer(RecruitVo recruitVo) throws Exception;

	int updateCertificate(List<CertificateVo> cerVoList, String seq) throws Exception;

	List<CertificateVo> selectCertificate(RecruitVo recruitVo) throws Exception;

}
