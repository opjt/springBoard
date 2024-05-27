package com.spring.recruit.dao;

import java.util.List;

import com.spring.recruit.vo.CareerVo;
import com.spring.recruit.vo.CertificateVo;
import com.spring.recruit.vo.EducationVo;
import com.spring.recruit.vo.RecruitVo;

public interface RecruitDao {

	RecruitVo findUser(RecruitVo recruitVo) throws Exception;

	int insertRecruit(RecruitVo recruitVo) throws Exception;

	int updateRecruit(RecruitVo recruitVo) throws Exception;

	int deleteEducation(String seq) throws Exception;

	int deleteCareer(String seq) throws Exception;

	int updateEducation(List<EducationVo> eduVoList) throws Exception;

	int updateCareer(List<CareerVo> creVoList) throws Exception;

	List<EducationVo> selectEducation(RecruitVo recruitVo) throws Exception;

	List<CareerVo> selectCareer(RecruitVo recruitVo) throws Exception;

	int deleteCertificate(String seq) throws Exception;

	int updateCertificate(List<CertificateVo> cerVoList) throws Exception;;

	List<CertificateVo> selectCertificate(RecruitVo recruitVo) throws Exception;;

}
