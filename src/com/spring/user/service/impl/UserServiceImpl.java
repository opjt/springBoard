package com.spring.user.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.board.dao.BoardDao;
import com.spring.common.vo.CodeVo;
import com.spring.user.dao.UserDao;
import com.spring.user.service.UserService;
import com.spring.user.vo.UserVo;

@Service
public class UserServiceImpl implements UserService{

	@Autowired
	UserDao userDao;
	
	@Override
	public List<CodeVo> selectCodeList() throws Exception {
		// TODO Auto-generated method stub
		return userDao.selectCodeList();
	}

	@Override
	public int userJoin(UserVo userVo) throws Exception {
		// TODO Auto-generated method stub
		return userDao.userJoin(userVo);
	}

	@Override
	public UserVo userLogin(UserVo userVo) throws Exception {
		// TODO Auto-generated method stub
		return userDao.userLogin(userVo);
	}

	@Override
	public UserVo userCheckId(String userId) throws Exception {
		// TODO Auto-generated method stub
		return userDao.checkUserId(userId);
	}

}
