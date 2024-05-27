package com.spring.recruit.dao.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.recruit.dao.RecruitDao;
import com.spring.recruit.vo.CareerVo;
import com.spring.recruit.vo.CertificateVo;
import com.spring.recruit.vo.EducationVo;
import com.spring.recruit.vo.RecruitVo;

@Repository
public class RecruitDaoImpl implements RecruitDao{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public RecruitVo findUser(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("recruit.findByNameAndPhone", recruitVo);
	}

	@Override
	public int insertRecruit(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.recruitInsert", recruitVo);
	}

	@Override
	public int updateRecruit(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.update("recruit.recruitUpdate", recruitVo);
	}


	@Override
	public int updateEducation(List<EducationVo> eduVoList) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.insertEducation",eduVoList);
	}

	@Override
	public int deleteEducation(String seq) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("recruit.deleteEducation",seq);
	}

	@Override
	public List<EducationVo> selectEducation(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("recruit.selectEducation", recruitVo);
	}

	@Override
	public int deleteCareer(String seq) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("recruit.deleteCareer",seq);
	}

	@Override
	public int updateCareer(List<CareerVo> creVoList) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.insertCareer",creVoList);
	}

	@Override
	public List<CareerVo> selectCareer(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("recruit.selectCareer", recruitVo);
	}

	@Override
	public int deleteCertificate(String seq) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("recruit.deleteCertificate",seq);
	}

	@Override
	public int updateCertificate(List<CertificateVo> cerVoList) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.insertCertificate",cerVoList);
	}

	@Override
	public List<CertificateVo> selectCertificate(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("recruit.selectCertificate",recruitVo);
	}

}
