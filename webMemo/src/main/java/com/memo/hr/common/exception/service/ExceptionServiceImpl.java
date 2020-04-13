package com.memo.hr.common.exception.service;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.memo.hr.common.exception.dao.ExceptionDAO;
import com.memo.hr.common.exception.vo.ExceptionVO;

@Service
public class ExceptionServiceImpl implements ExceptionService {

	@Inject
	private ExceptionDAO dao;

	@Override
	public int insertExcptLog(ExceptionVO vo) throws Exception {
		return dao.insertExcptLog(vo);
	}


}
