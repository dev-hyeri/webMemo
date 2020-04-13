package com.memo.hr.admin.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.memo.hr.admin.dao.adminDAO;
import com.memo.hr.common.exception.vo.ExceptionVO;
import com.memo.hr.home.vo.MmbrVO;

@Service
public class adminServiceImpl implements adminService{

	@Inject
	private adminDAO dao;

	@Override
	public List<MmbrVO> listMmbr(MmbrVO vo) throws Exception {
		return dao.listMmbr(vo);
	}

	@Override
	public int getMmbrTotalCnt(MmbrVO vo) throws Exception {
		return dao.countMmbr(vo);
	}

	@Override
	public MmbrVO detailMmbr(MmbrVO vo) throws Exception {
		return dao.selectMmbr(vo);
	}

	@Override
	public List<ExceptionVO> listError(ExceptionVO vo) throws Exception {
		return dao.listError(vo);
	}

	@Override
	public ExceptionVO detailError(ExceptionVO vo) throws Exception {
		return dao.selectError(vo);
	}

	@Override
	public int getMmbrErrorCnt(ExceptionVO vo) throws Exception {
		return dao.countError(vo);
	}

	@Override
	public int deleteError(int errorSn) throws Exception {
		return dao.deleteError(errorSn);
	}
}
