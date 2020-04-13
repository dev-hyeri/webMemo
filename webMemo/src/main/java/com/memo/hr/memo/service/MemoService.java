package com.memo.hr.memo.service;

import java.util.List;

import com.memo.hr.home.vo.MmbrVO;
import com.memo.hr.memo.vo.MemoVO;

public interface MemoService {
	/**
	 * 메모 등록
	 * @param MemoVO vo
	 * @return int
	 * */
	public int registerMemo(MemoVO vo) throws Exception;

	/**
	 * 개별 메모 리스트 조회
	 * @param MemoVO vo
	 * @return List<MemoVO>
	 * */
	public List<MemoVO> listIndvdMemo(MemoVO vo) throws Exception;

	/**
	 * 개별 메모 고정 개수 카운트
	 * @param MemoVO vo
	 * @return int
	 * */
	public int countIndvdFxd(MemoVO vo) throws Exception;

	/**
	 * 공유 메모 리스트 조회
	 * @param MMemoVO vo
	 * @return List<MemoVO>
	 * */
	public List<MemoVO> listShrdMemo(MemoVO vo) throws Exception;

	/**
	 * 개별 메모 전체 카운트 조회
	 * @param MemoVO vo
	 * @return int
	 */
	public int getIndvdMemoTotalCnt(MemoVO vo) throws Exception;

	/**
	 * 공유 메모 전체 카운트 조회
	 * @param MemoVO vo
	 * @return int
	 */
	public int getShrdMemoTotalCnt(MemoVO vo) throws Exception;

	/**
	 * 메모 상세 조회
	 * @param MemoVO vo
	 * @return MemoVO
	 * */
	public MemoVO readMemo(MemoVO vo) throws Exception;

	/**
	 * 메모 삭제(삭제여부 Y로변경)
	 * @param String memoSn
	 * @return int
	 * */
	public int deleteMemo(String memoSn) throws Exception;

	/**
	 * 메모 수정
	 * @param MemoVO vo
	 * @return int
	 * */
	public int modifyMemo(MemoVO vo) throws Exception;

	/**
	 * 로그인 ID 제외한 전체 회원 리스트
	 * @param MmbrVO mmbrVo
	 * @return List<MmbrVO>
	 * */
	public List<MmbrVO> listOtherMmbr(MemoVO vo) throws Exception;

	/**
	 * 메모에 공유된 ID 추가
	 * @param MemoVO vo
	 * @return
	*/
	public void insertShrdUser(MemoVO vo) throws Exception;

	/**
	 * 메모에 공유된 ID 리스트
	 * @param MemoVO vo
	 * @return List<MemoVO>
	*/
	public List<MemoVO> listShrdUser(MemoVO vo) throws Exception;

	/**
	 * 메모에 공유된 ID 모두 삭제
	 * @param MemoVO vo
	 * @return
	*/
	public void deleteShrdUser(MemoVO vo) throws Exception;

	/**
	 * 회원 정보 조회
	 * @param MemoVO vo
	 * @return MmbrVO
	*/
	public MmbrVO readMmbr(MemoVO vo) throws Exception;

	/**
	 * 메모 내용 메일 전송
	 * @param MmbrVO mmbrVo, MemoVO memoVo, String div
	 * @return
	*/
	public void sendEmailMemo(MmbrVO mmbrVo, MemoVO memoVo, String div) throws Exception;
}
