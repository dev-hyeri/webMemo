package com.memo.hr.home.service;

import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.memo.hr.home.vo.MmbrVO;

public interface HomeService {

	/**
	 * 회원 정보 추가
	 * @param MmbrVO vo
	 * @return Map<String,String>
	 * */
	public Map<String,String> insertMmbr(MmbrVO vo) throws Exception;

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
	 * 로그인정보 체크(로그인 가능 여부 체크)
	 * @param MmbrVO vo, HttpServletResponse session
	 * @return  Map<String,String>
	 * */
	public Map<String,String> checkLoginInfo(MmbrVO vo, HttpSession session) throws Exception;

	/**
	 * 승인상태(일반사용자 02)로 변경
	 * @param MmbrVO vo, HttpServletResponse response
	 * @return
	 * */
	public void approvalMmbr(MmbrVO vo, HttpServletResponse response) throws Exception;

	/**
	 * [ID찾기]회원 소유 ID리스트 조회
	 * @param MmbrVO vo
	 * @return  Map<Object,Object>
	 * */
	public Map<Object,Object> findIdList(MmbrVO vo) throws Exception;

	/**
	 * [PWD찾기]임시 비밀번호 이메일 전송
	 * @param MmbrVO vo
	 * @return  Map<Object,Object>
	 * */
	public Map<Object,Object> findPwd(MmbrVO vo) throws Exception;

	/**
	 * 회원정보 조회
	 * @param MmbrVO vo
	 * @return  MmbrVO
	 * */
	public MmbrVO readMmbr(MmbrVO vo) throws Exception;

	/**
	 * [정보수정]PWD 일치 여부 확인
	 * @param MmbrVO vo
	 * @return  Map<String,String>
	 * */
	public Map<String,String> checkPwd(MmbrVO vo) throws Exception;

	/**
	 *	회원 정보 수정
	 * @param MmbrVO vo
	 * @return  Map<String,String>
	 * */
	public Map<String, String> modifyMmbr(MmbrVO vo) throws Exception;

	/**
	 * 비밀번호 수정
	 * @param MmbrVO vo
	 * @return  Map<String,String>
	 * */
	public Map<String, String> modifyPwd(MmbrVO vo) throws Exception;

	/**
	 * 이메일 수정
	 * @param MmbrVO vo
	 * @return  Map<String,String>
	 * */
	public Map<String, String> modifyEmail(MmbrVO vo) throws Exception;

	/**
	 * [회원탈퇴]회원 메모 삭제
	 * @param MmbrVO
	 * @return
	 * */
	public void deleteMemo(MmbrVO vo) throws Exception;

	/**
	 * 메일전송
	 * @param MmbrVO vo, String div
	 * @return
	 * */
	public void sendEmail(MmbrVO vo,String div) throws Exception;

}
