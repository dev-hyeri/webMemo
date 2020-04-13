package com.memo.hr.admin.dao;

import java.util.List;

import com.memo.hr.common.exception.vo.ExceptionVO;
import com.memo.hr.home.vo.MmbrVO;

public interface adminDAO {
	/**
	 * 회원 리스트 조회
	 * @param MmbrVO vo
	 * @return List<MmbrVO>
	 * */
	public List<MmbrVO> listMmbr(MmbrVO vo) throws Exception;

	/**
	 * 회원 전체 수 카운트
	 * @param MmbrVO vo
	 * @return int
	 * */
	public int countMmbr(MmbrVO vo) throws Exception;

	/**
	 * 회원 상세 조회
	 * @param MmbrVO vo
	 * @return MmbrVO
	 * */
	public MmbrVO selectMmbr(MmbrVO vo) throws Exception;

	/**
	 * 에러 리스트 조회
	 * @param ExceptionVO vo
	 * @return  List<ExceptionVO>
	 * */
	public List<ExceptionVO> listError(ExceptionVO vo) throws Exception;

	/**
	 * 에러 전체 개수 카운트
	 * @param ExceptionVO vo
	 * @return  int
	 * */
	public int countError(ExceptionVO vo) throws Exception;

	/**
	 * 에러 상세 조회
	 * @param ExceptionVO vo
	 * @return ExceptionVO
	 * */
	public ExceptionVO selectError(ExceptionVO vo) throws Exception;

	/**
	 * 에러 삭제
	 * @param int errorSn
	 * @return int
	 * */
	public int deleteError(int errorSn) throws Exception;
}
