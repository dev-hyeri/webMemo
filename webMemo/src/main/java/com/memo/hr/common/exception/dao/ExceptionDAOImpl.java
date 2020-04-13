package com.memo.hr.common.exception.dao;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.memo.hr.common.exception.vo.ExceptionVO;

@Repository
public class ExceptionDAOImpl implements ExceptionDAO {

	@Inject
	private SqlSession session;

	private static String namespace = "com.memo.hr.mapper.ExceptionMapper";

	@Override
	public int insertExcptLog(ExceptionVO vo) {
		return session.insert(namespace + ".insertExcptLog",vo);
	}

}
