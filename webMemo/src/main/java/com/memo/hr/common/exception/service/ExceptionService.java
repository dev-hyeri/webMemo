package com.memo.hr.common.exception.service;

import com.memo.hr.common.exception.vo.ExceptionVO;

public interface ExceptionService {
	/**
	 * 에러내역 추가
	 * @param ExceptionVO vo
	 * @return int
	 * */
	public int insertExcptLog(ExceptionVO vo) throws Exception;
}
