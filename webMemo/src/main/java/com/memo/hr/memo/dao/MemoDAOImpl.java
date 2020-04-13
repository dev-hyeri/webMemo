package com.memo.hr.memo.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.memo.hr.home.vo.MmbrVO;
import com.memo.hr.memo.vo.MemoVO;

@Repository
public class MemoDAOImpl implements MemoDAO {

	@Inject
	private SqlSession session;

	private static String namespace = "com.memo.hr.mapper.MemoMapper";

	@Override
	public int insertMemo(MemoVO vo) throws Exception {
		return session.insert(namespace + ".insertMemo",vo);
	}

	@Override
	public List<MemoVO> listIndvdMemo(MemoVO vo) throws Exception {
		return session.selectList(namespace + ".listIndvdMemo",vo);
	}

	@Override
	public int countIndvdFxd(MemoVO vo) throws Exception {
		return session.selectOne(namespace+".countIndvdFxd",vo);
	}

	@Override
	public int countIndvdMemo(MemoVO vo) throws Exception {
		return session.selectOne(namespace+".countIndvdMemo", vo);
	}

	@Override
	public List<MemoVO> listShrdMemo(MemoVO vo) throws Exception {
		return session.selectList(namespace + ".listShrdMemo",vo);
	}

	@Override
	public int countShrdMemo(MemoVO vo) throws Exception {
		return session.selectOne(namespace+".countShrdMemo", vo);
	}

	@Override
	public MemoVO selectMemo(MemoVO vo) throws Exception {
		return session.selectOne(namespace + ".selectMemo", vo);
	}

	@Override
	public int updateMemoDeletion(String memoSn) throws Exception {
		return session.delete(namespace +".updateMemoDeletion", memoSn);
	}

	@Override
	public int updateMemo(MemoVO vo) throws Exception {
		return session.update(namespace +".updateMemo", vo);
	}

	@Override
	public List<MmbrVO> listOtherMmbr(MemoVO vo) throws Exception {
		return session.selectList(namespace+".listOtherMmbr", vo);
	}

	@Override
	public void insertShrdUser(MemoVO vo) throws Exception {
		session.insert(namespace+".insertShrdUser",vo);
	}

	@Override
	public List<MemoVO> listShrdUser(MemoVO vo) throws Exception {
		return session.selectList(namespace + ".listShrdUser",vo);
	}

	@Override
	public void deleteShrdUser(MemoVO vo) throws Exception {
		session.delete(namespace+".deleteShrdUser",vo);
	}

	@Override
	public MmbrVO selectMmbr(MemoVO vo) throws Exception {
		return session.selectOne(namespace+".selectMmbr", vo);
	}

}
