package com.spring.user.dao;

import java.util.List;

import com.spring.common.vo.CodeVo;
import com.spring.user.vo.UserVo;

public interface UserDao {

	List<CodeVo> selectCodeList() throws Exception;

	int userJoin(UserVo userVo) throws Exception;

	UserVo userLogin(UserVo userVo) throws Exception;

	UserVo checkUserId(String userId) throws Exception;

}
