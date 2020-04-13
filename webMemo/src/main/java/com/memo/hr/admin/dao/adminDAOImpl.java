package com.memo.hr.admin.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.memo.hr.common.exception.vo.ExceptionVO;
import com.memo.hr.home.vo.MmbrVO;

@Repository
public class adminDAOImpl implements adminDAO {

	@Inject
	private SqlSession session;
	private static String namespace ="com.memo.hr.mapper.AdminMapper";

	@Override
	public List<MmbrVO> listMmbr(MmbrVO vo) throws Exception {
		return session.selectList(namespace+".listMmbr",vo);
	}

	@Override
	public int countMmbr(MmbrVO vo) throws Exception {
		return session.selectOne(namespace+".countMmbr",vo);
	}

	@Override
	public MmbrVO selectMmbr(MmbrVO vo) throws Exception {
		return session.selectOne(namespace+".selectMmbr",vo);
	}

	@Override
	public List<ExceptionVO> listError(ExceptionVO vo) throws Exception {
		return session.selectList(namespace+".listError", vo);
	}

	@Override
	public ExceptionVO selectError(ExceptionVO vo) throws Exception {
		return session.selectOne(namespace+".selectError",vo);
	}

	@Override
	public int countError(ExceptionVO vo) throws Exception {
		return session.selectOne(namespace+".countError",vo);
	}

	@Override
	public int deleteError(int errorSn) throws Exception {
		 return session.delete(namespace +".deleteError",errorSn);
	}

}
