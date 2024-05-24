package com.spring.recruit.dao;

import com.spring.recruit.vo.RecruitVo;

public interface RecruitDao {

	RecruitVo findUser(RecruitVo recruitVo) throws Exception;

	int insertRecruit(RecruitVo recruitVo) throws Exception;

	int updateRecruit(RecruitVo recruitVo) throws Exception;

}
