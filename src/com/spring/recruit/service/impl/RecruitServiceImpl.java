package com.spring.recruit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.recruit.dao.RecruitDao;
import com.spring.recruit.service.RecruitService;
import com.spring.recruit.vo.RecruitVo;

@Service
public class RecruitServiceImpl implements RecruitService{
	
	@Autowired
	RecruitDao recruitDao;
	
	@Override
	public RecruitVo findUser(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return recruitDao.findUser(recruitVo);
	}

	@Override
	public int recruitUpdate(RecruitVo recruitVo) throws Exception {
		
		RecruitVo findUser = recruitDao.findUser(recruitVo);
		if(findUser == null) {
			return recruitDao.insertRecruit(recruitVo);
		}
		return recruitDao.updateRecruit(recruitVo);
	}

}
