package com.memo.hr.home.service;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.mail.HtmlEmail;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.memo.hr.common.code.Code;
import com.memo.hr.home.dao.HomeDAO;
import com.memo.hr.home.vo.MmbrVO;

@Service
public class HomeServiceImpl implements HomeService {

	@Inject
	private HomeDAO dao;

	//회원 정보 추가
	@Override
	public Map<String,String> insertMmbr(MmbrVO vo) throws Exception {

		// 기본값 세팅 - GRP_CD : 00001(권한코드), CMN_CD : 03(승인 대기)
		vo.setAuthCd(Code.GRP_CMN_CD_00001_03);

		// 비밀번호 암호화
		BCryptPasswordEncoder bcryptPasswordEncoder = new BCryptPasswordEncoder();
		vo.setPwd(bcryptPasswordEncoder.encode(vo.getPwd()));

		//승인코드 생성
		String key = "";
		for (int i = 0; i < 8; i++) {
			key += (char)((Math.random())*7)+2;
		}
		vo.setApprovalKey(key);

		int rtn = dao.insertMmbr(vo);
		Map<String,String> map = new HashMap<String,String>();

		if(1 == rtn) {
			sendEmail(vo,"join"); //가입 메일 전송
			map.put("msg", Code.RESULT_MSG_SUCCESS);
		}else {
			map.put("msg", Code.RESULT_MSG_FAIL);
		}
		return map;
	}

	//ID중복체크
	@Override
	public int idCheck(String loginId) throws Exception {
		return dao.idCheck(loginId);
	}

	//이메일 중복체크
	@Override
	public int emailCheck(String mmbrEmail) throws Exception {
		return dao.emailCheck(mmbrEmail);
	}

	//로그인정보 체크(로그인 가능 여부 체크)
	@Override
	public Map<String,String> checkLoginInfo(MmbrVO vo, HttpSession session) throws Exception {

		Map<String,String> map = new HashMap<String,String>();

		MmbrVO mmbrVo = dao.selectMmbr(vo);

		if(mmbrVo==null) { //전달된 ID와 같은 객체가 없을 경우
			map.put("msg",Code.RESULT_MSG_FAIL);

		}else if( "03".equals(mmbrVo.getAuthCd()) ){ //승인 대기 상태일 경우
			map.put("msg","disapproval");

		}else if( "Y".equals(mmbrVo.getWthdrYn()) ){ //탈퇴여부 Y일 경우
			map.put("msg","loginWthdr");

		}else{
			BCryptPasswordEncoder bcryptPasswordEncoder = new BCryptPasswordEncoder();

			// 비밀번호 비교
			if( bcryptPasswordEncoder.matches(vo.getPwd(), mmbrVo.getPwd()) ) {
				// 세션 세팅
				session.setAttribute(Code.SESSION_KEY_LOGIN_ID, mmbrVo.getLoginId());
				session.setAttribute(Code.SESSION_KEY_LOGIN_INFO, mmbrVo);

				map.put("msg",Code.RESULT_MSG_SUCCESS);
				map.put("authCd", mmbrVo.getAuthCd());	// 권한코드

			// 로그인 실패
			} else {
				map.put("msg",Code.RESULT_MSG_FAIL);
			}
		}
		return map;
	}

	//승인상태(일반사용자 02)로 변경
	@Override
	public void approvalMmbr(MmbrVO vo, HttpServletResponse response) throws Exception {

		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();

		int rtn = dao.updateApproval(vo); //CMN_CD : 02(일반 사용자)로 변경

		if (rtn > 0) { // 이메일 인증에 성공하였을 경우
			out.println("<script>");
			out.println("alert('인증이 완료되었습니다. 로그인 후 이용바랍니다.');");
			out.println("history.go(-1);");
			out.println("</script>");
			out.close();

		} else { // 이메일 인증을 실패하였을 경우
			out.println("<script>");
			out.println("alert('잘못된 접근입니다. 관리자에게 문의 부탁드립니다.');");
			out.println("history.go(-1);");
			out.println("</script>");
			out.close();
		}
	}

	//[ID찾기]회원 소유 ID리스트 조회
	@Override
	public Map<Object,Object> findIdList(MmbrVO vo) throws Exception {

		Map<Object, Object> map = new HashMap<Object, Object>();

		List<MmbrVO> idList = dao.selectIdList(vo);

		if(idList==null || idList.size() <= 0) { //존재하는 id가 없을 경우
			map.put("msg",Code.RESULT_MSG_FAIL);

		}else{                                   //존재하는 id가 있을 겨우
			map.put("msg",Code.RESULT_MSG_SUCCESS);
			map.put("idList",idList);
		}
		return map;
	}

	//[PWD찾기]임시 비밀번호 이메일 전송
	@Override
	public Map<Object,Object> findPwd(MmbrVO vo) throws Exception {

		Map<Object, Object> map = new HashMap<Object, Object>();

		MmbrVO mmbrVo = vo;
		MmbrVO findPwVo  = dao.selectIdforPwd(vo);

		if(findPwVo == null) { //존재하는 회원이 없는 경우
			map.put("msg",Code.RESULT_MSG_FAIL);

		}else{
				//임시 비밀번호 생성
				String pwd ="";
				for(int i=0; i<12; i++) {
					pwd+=(char)((Math.random()*26)+97);
				}

				//임시 비밀번호로 비밀번호 변경
				mmbrVo.setPwd(pwd);
				dao.updateMmbr(mmbrVo);

				sendEmail(mmbrVo,"findPwd"); // 임시 비밀번호 메일 전송

				//전송 후 임시 비밀번호 암호화(로그인 시 복호화하기때문에 암호화하여 다시 저장 필요)
				BCryptPasswordEncoder bcryptPasswordEncoder = new BCryptPasswordEncoder();
				mmbrVo.setPwd(bcryptPasswordEncoder.encode(pwd));
				dao.updateMmbr(mmbrVo);

				map.put("msg",Code.RESULT_MSG_SUCCESS);
			}
		return map;
	}

	//회원정보 조회
	@Override
	public MmbrVO readMmbr(MmbrVO vo) throws Exception {
		return dao.selectMmbr(vo);
	}

	//[정보수정]PWD 일치 여부 확인
	@Override
	public Map<String, String> checkPwd(MmbrVO vo) throws Exception {

		Map<String, String> map = new HashMap<String,String>();

		MmbrVO mmbrVo = dao.selectMmbr(vo);

		BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();

		// 비밀번호 비교
		if(bCryptPasswordEncoder.matches(vo.getPwd(),mmbrVo.getPwd())){
			map.put("msg",Code.RESULT_MSG_SUCCESS);
		}else {
			map.put("msg",Code.RESULT_MSG_FAIL);
		}
		return map;
	}

	//회원 정보 수정
	@Override
	public Map<String, String> modifyMmbr(MmbrVO vo) throws Exception {

		Map<String, String> map = new HashMap<String,String>();

		int rtn=dao.updateMmbr(vo);

		if(rtn>0) {
			map.put("msg",Code.RESULT_MSG_SUCCESS);
		}else {
			map.put("msg",Code.RESULT_MSG_FAIL);
		}
		return map;
	}

	//비밀번호 수정
	@Override
	public Map<String, String> modifyPwd(MmbrVO vo) throws Exception {

		Map<String, String> map = new HashMap<String,String>();

		// 비밀번호 암호화
		BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
		vo.setPwd(bCryptPasswordEncoder.encode(vo.getPwd()));

		int rtn = dao.updateMmbr(vo);
		if(rtn>0) {
			map.put("msg",Code.RESULT_MSG_SUCCESS);
		}else {
			map.put("msg",Code.RESULT_MSG_FAIL);
		}
		return map;
	}

	//이메일 수정
	@Override
	public Map<String, String> modifyEmail(MmbrVO vo) throws Exception {

			Map<String, String> map = new HashMap<String,String>();

			//권한 변경 - GRP_CD : 00001(권한코드), CMN_CD : 03(승인 대기)
			vo.setAuthCd(Code.GRP_CMN_CD_00001_03);

			//승인코드 생성
			String key = "";
			for (int i = 0; i < 8; i++) {
				key += (char)((Math.random())*7)+2;
			}
			vo.setApprovalKey(key);

			int rtn = dao.updateMmbr(vo);
			sendEmail(vo,"changeEmail"); //승인확인을 위해 변경 이메일 주소로 전송

			if(rtn>0) {
				map.put("msg",Code.RESULT_MSG_SUCCESS);
			}else {
				map.put("msg",Code.RESULT_MSG_FAIL);
			}
			return map;
	}

	//[회원탈퇴]회원 메모 삭제
	@Override
	public void deleteMemo(MmbrVO vo) throws Exception {
		dao.updateMemoDeletion(vo);
	}

	//메일 전송
	@Override
	public void sendEmail(MmbrVO vo, String div) throws Exception {

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
		String mail = vo.getMmbrEmail();
		String mmbrName = vo.getMmbrNm();

		if(div.equals("join")) { //회원가입 메일 내용
			subject = "[WebMeme] 회원가입 인증 메일입니다.";
			msg += "<div align='center' style='border:1px solid black; font-family:verdana'>";
			msg += "<h3 style='color: blue;'>";
			msg += vo.getLoginId() + "님 회원가입을 환영합니다!</h3>";
			msg += "<div style='font-size: 130%'>";
			msg += "하단의 인증 버튼 클릭 시 정상적으로 회원가입이 완료됩니다.</div><br/>";
			msg += "<form method='post' action='http://localhost:8080/hyeri/home/approvalMmbr.hr'>";
			msg += "<input type='hidden' name='mmbrEmail' value='" + vo.getMmbrEmail() + "'>";
			msg += "<input type='hidden' name='approvalKey' value='" + vo.getApprovalKey() + "'>";
			msg += "<input type='submit' value='인증'></form><br/></div>";

		}else if(div.equals("findPwd")) { //비밀번호찾기 메일 내용
			subject = "[WebMeme] 임시 비밀번호입니다.";
			msg += "<div align='center' style='border:1px solid black; font-family:verdana'>";
			msg += "<h3 style='color: blue;'>";
			msg += vo.getLoginId() + "님의 임시 비밀번호 입니다. <br>비밀번호를 변경하여 사용바랍니다.</h3>";
			msg += "<p>임시 비밀번호 : ";
			msg += vo.getPwd() + "</p></div>";

		}else if(div.equals("changeEmail")) { //이메일 변경 승인 확인 메일 내용
			subject = "[WebMeme] 정보 변경 인증 메일입니다.";
			msg += "<div align='center' style='border:1px solid black; font-family:verdana'>";
			msg += "<h3 style='color: blue;'>";
			msg += vo.getLoginId() + "님 email정보 변경으로 인한 인증 확인 메일입니다.</h3>";
			msg += "<div style='font-size: 130%'>";
			msg += "하단의 인증 버튼 클릭 시 정상적으로 정보 변경 및 사용 가능합니다.</div><br/>";
			msg += "<form method='post' action='http://localhost:8080/hyeri/home/approvalMmbr.hr'>";
			msg += "<input type='hidden' name='mmbrEmail' value='" + vo.getMmbrEmail() + "'>";
			msg += "<input type='hidden' name='approvalKey' value='" + vo.getApprovalKey() + "'>";
			msg += "<input type='submit' value='인증'></form><br/></div>";
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

				email.addTo(mail,mmbrName, charSet); //받는사람 설정
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
