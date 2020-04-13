package com.memo.hr.home.dao;

import java.util.List;

import com.memo.hr.home.vo.MmbrVO;

public interface HomeDAO {

		/**
		 * 회원 정보 추가
		 * @param MmbrVO vo
		 * @return int
		 * */
		public int insertMmbr(MmbrVO vo) throws Exception;

		/**
		 * ID 중복체크
		 * @param String loginId
		 * @return int
		 * */
		public int idCheck(String loginId) throws Exception;

		/**
		 * 이메일 중복체크
		 * @param String mmbrEmail
		 * @return int
		 * */
		public int emailCheck(String mmbrEmail) throws Exception;

		/**
		 * 승인상태(일반사용자 02)로 변경
		 * @param MmbrVO vo
		 * @return int
		 * */
		public int updateApproval(MmbrVO vo) throws Exception;

		/**
		 * 회원 소유 ID리스트 조회
		 * @paramMmbrVO vo
		 * @return  List<MmbrVO>
		 * */
		public List<MmbrVO> selectIdList(MmbrVO vo) throws Exception;

		/**
		 * pwd찾기 정보와 맞는 회원 ID 조회
		 * @param MmbrVO vo
		 * @return  MmbrVO
		 * */
		public MmbrVO selectIdforPwd(MmbrVO vo) throws Exception;

		/**
		 * 회원정보 조회
		 * @param MmbrVO vo
		 * @return  MmbrVO
		 * */
		public MmbrVO selectMmbr(MmbrVO vo) throws Exception;

		/**
		 * 회원정보 수정
		 * @param MmbrVO vo
		 * @return  int
		 * */
		public int updateMmbr(MmbrVO vo) throws Exception;

		/**
		 * 회원 메모 삭제
		 * @param MmbrVO vo
		 * @return
		 * */
		public void updateMemoDeletion(MmbrVO vo) throws Exception;
}
