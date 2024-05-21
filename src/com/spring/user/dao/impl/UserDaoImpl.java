package com.spring.user.dao.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.common.vo.CodeVo;
import com.spring.user.dao.UserDao;
import com.spring.user.vo.UserVo;

@Repository
public class UserDaoImpl implements UserDao{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<CodeVo> selectCodeList() throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("user.codeList");
	}

	@Override
	public int userJoin(UserVo userVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("user.userJoin", userVo);
		
	}

	@Override
	public UserVo userLogin(UserVo userVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("user.userLogin", userVo);
	}

	@Override
	public UserVo checkUserId(String userId) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("user.checkUserId", userId);
	}
}
