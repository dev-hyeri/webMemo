package com.memo.hr.memo.service;

import java.util.List;

import javax.inject.Inject;

import org.apache.commons.mail.HtmlEmail;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.memo.hr.home.vo.MmbrVO;
import com.memo.hr.memo.dao.MemoDAO;
import com.memo.hr.memo.vo.MemoVO;

@Service
public class MemoServiceImpl implements MemoService{

	@Inject
	private MemoDAO dao;

	//메모 등록
	@Override
	public int registerMemo(MemoVO vo) throws Exception {

		// 기본값 세팅
		if( StringUtils.isEmpty(vo.getFxdYn()) ) { //고정여부 비어있을 경우
			vo.setFxdYn("N");
		}

		if( StringUtils.isEmpty(vo.getAllShrdYn()) ) {//전체 공유여부 비어있을 경우
			vo.setAllShrdYn("N");
		}

		if( StringUtils.isEmpty(vo.getShrdIds())) {//공유ID 비어있을 경우
			vo.setPrtShrdYn("N");
		}else {
			vo.setPrtShrdYn("Y");
		}

		return dao.insertMemo(vo);
	}

	//개별 메모 리스트 조회
	@Override
	public List<MemoVO> listIndvdMemo(MemoVO vo) throws Exception {
		return dao.listIndvdMemo(vo);
	}

	//개별 메모 고정 개수 카운트
	@Override
	public int countIndvdFxd(MemoVO vo) throws Exception {
		return dao.countIndvdFxd(vo);
	}

	//공유 메모 리스트 조회
	@Override
	public List<MemoVO> listShrdMemo(MemoVO vo) throws Exception {
		return dao.listShrdMemo(vo);
	}

	//개별 메모 전체 카운트 조회
	@Override
	public int getIndvdMemoTotalCnt(MemoVO vo) throws Exception {
		return dao.countIndvdMemo(vo);
	}

	//공유 메모 전체 카운트 조회
	@Override
	public int getShrdMemoTotalCnt(MemoVO vo) throws Exception {
		return dao.countShrdMemo(vo);
	}

	//메모 상세 조회
	@Override
	public MemoVO readMemo(MemoVO vo) throws Exception {
		return dao.selectMemo(vo);
	}

	//메모 삭제(삭제여부 Y로변경)
	@Override
	public int deleteMemo(String memoSn) throws Exception {
		return dao.updateMemoDeletion(memoSn);
	}

	//메모 수정
	@Override
	public int modifyMemo(MemoVO vo) throws Exception {
		//기본값세팅
		if( StringUtils.isEmpty(vo.getFxdYn()) ) {//고정여부 비어있을 경우
			vo.setFxdYn("N");
		}

		if( StringUtils.isEmpty(vo.getAllShrdYn()) ) {//전체공유여부 비어있을 경우
			vo.setAllShrdYn("N");
		}

		if(vo.getShrdIds() == "" || StringUtils.isEmpty(vo.getShrdIds()) ) {//공유ID 비어있을 경우
			vo.setPrtShrdYn("N");
		}else {
			vo.setPrtShrdYn("Y");
		}

		return dao.updateMemo(vo);
	}

	//로그인 ID 제외한 전체 회원 리스트
	@Override
	public List<MmbrVO> listOtherMmbr(MemoVO vo) throws Exception {
		return dao.listOtherMmbr(vo);
	}

	//메모에 공유된 ID 추가
	@Override
	public void insertShrdUser(MemoVO vo) throws Exception {
		dao.insertShrdUser(vo);
	}

	//메모에 공유된 ID 리스트
	@Override
	public List<MemoVO> listShrdUser(MemoVO vo) throws Exception {
		return dao.listShrdUser(vo);
	}

	//메모에 공유된 ID 모두 삭제
	@Override
	public void deleteShrdUser(MemoVO vo) throws Exception {
		dao.deleteShrdUser(vo);
	}

	//회원 정보 조회
	@Override
	public MmbrVO readMmbr(MemoVO vo) throws Exception {
		return dao.selectMmbr(vo);
	}

	//메모 내용 메일 전송
	@Override
	public void sendEmailMemo(MmbrVO mmbrVo, MemoVO memoVo, String div) throws Exception {
		// Mail Server 설정
		String charSet = "utf-8";
		String hostSMTP = "smtp.gmail.com";
		String hostSMTPid = "hemohyeri";
		String hostSMTPpwd = "gpah1234";

		// 보내는 사람 Email, 제목, 내용
		String fromEmail = "hemohyeri@gmail.com";
		String fromName = "WebMemo";
		String subject = "";
		String msg = "";

		//받는 사람 Email
		String mail = mmbrVo.getMmbrEmail();
		String mmbrName = mmbrVo.getMmbrNm();

		if(div.equals("myEmail")) { //메모 사용자 메일주소로 전송
			subject = "[WebMemo] 전달 메모입니다.";
			msg = memoVo.getCntnt();
		}

		try {
			HtmlEmail email = new HtmlEmail();
			email.setDebug(true);
			 //문자설정
			email.setCharset(charSet);

			//SMTP 서버 연결 설정
			email.setHostName(hostSMTP);
			email.setSmtpPort(587);
			email.setAuthentication(hostSMTPid, hostSMTPpwd);

			//SMTP 보안 SSL,TLS설정
			email.setSSLOnConnect(true);
			email.setStartTLSEnabled(true);

			email.addTo(mail, mmbrName,charSet); //받는사람 설정
			email.setFrom(fromEmail, fromName, charSet); //보낸사람 설정
			email.setSubject(subject);
			email.setHtmlMsg(msg);
			email.send(); //메일 전송

		} catch (Exception e) {
			System.out.println("메일발송 실패");
			e.printStackTrace();
		}
	}

}
