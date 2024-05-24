package com.spring.recruit.dao.impl;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.recruit.dao.RecruitDao;
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

}
