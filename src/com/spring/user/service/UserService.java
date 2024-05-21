package com.spring.user.service;

import java.util.List;

import com.spring.common.vo.CodeVo;
import com.spring.user.vo.UserVo;

public interface UserService {

	List<CodeVo> selectCodeList() throws Exception;

	int userJoin(UserVo userVo) throws Exception;

	UserVo userLogin(UserVo userVo) throws Exception;

	UserVo userCheckId(String userId) throws Exception;

}
