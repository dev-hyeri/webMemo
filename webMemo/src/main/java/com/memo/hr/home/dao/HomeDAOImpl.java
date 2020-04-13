package com.memo.hr.home.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.memo.hr.home.vo.MmbrVO;

@Repository
public class HomeDAOImpl implements HomeDAO{

	@Inject
	private SqlSession session;

	private static String namespace = "com.memo.hr.mapper.HomeMapper";

	@Override
	public int insertMmbr(MmbrVO vo) throws Exception {
			return session.insert(namespace+".insertMmbr",vo);
	}

	@Override
	public int idCheck(String loginId) throws Exception {
		return session.selectOne(namespace+".idCheck",loginId);
	}

	@Override
	public int emailCheck(String mmbrEmail) throws Exception {
		return session.selectOne(namespace+".emailCheck",mmbrEmail);
	}

	@Override
	public int updateApproval(MmbrVO vo) throws Exception {
		return session.update(namespace+".updateApproval",vo);
	}

	@Override
	public List<MmbrVO> selectIdList(MmbrVO vo) throws Exception {
		return session.selectList(namespace+".selectIdList",vo);
	}

	@Override
	public MmbrVO selectIdforPwd(MmbrVO vo) throws Exception {
		return session.selectOne(namespace+".selectIdforPwd",vo);
	}

	@Override
	public MmbrVO selectMmbr(MmbrVO vo) throws Exception {
		return session.selectOne(namespace+".selectMmbr",vo);
	}

	@Override
	public int updateMmbr(MmbrVO vo) throws Exception {
		return session.update(namespace+".updateMmbr",vo);
	}

	@Override
	public void updateMemoDeletion(MmbrVO vo) throws Exception {
		session.update(namespace+".updateMemoDeletion",vo);
	}

}
