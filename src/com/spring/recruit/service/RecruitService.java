package com.spring.recruit.service;

import com.spring.recruit.vo.RecruitVo;

public interface RecruitService {

	RecruitVo findUser(RecruitVo recruitVo) throws Exception;

	int recruitUpdate(RecruitVo recruitVo) throws Exception;

}
