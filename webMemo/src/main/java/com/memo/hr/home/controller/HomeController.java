package com.memo.hr.home.controller;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.memo.hr.common.code.Code;
import com.memo.hr.home.service.HomeService;
import com.memo.hr.home.vo.MmbrVO;

@Controller
@RequestMapping("/home" )
public class HomeController {

	@Inject
	private HomeService service;
	private static final Logger logger = LoggerFactory.getLogger("HomeCotroller.class");

	//회원가입 화면
	@RequestMapping(value="/join.html", method=RequestMethod.GET)
	public void openJoin() throws Exception{
		logger.info("join.html..................");
	}

	//회원가입 기능 실행
	@RequestMapping(value="/join.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> join(@ModelAttribute("MmbrVO") MmbrVO vo) throws Exception{
		logger.info("join.ajax..................");
		return service.insertMmbr(vo);
	}

	//ID중복체크
	@RequestMapping(value="/idCheck.ajax", method=RequestMethod.POST)
	@ResponseBody
	public int idCheck(@ModelAttribute("MmbrVO") MmbrVO vo) throws Exception{
		logger.info("idCheck.ajax..................");

		 String check = vo.getLoginId();
		 int checkResult = service.idCheck(check);
		 return checkResult;
	}

	//이메일 중복체크
	@RequestMapping(value="/emailCheck.ajax", method=RequestMethod.POST)
	@ResponseBody
	public int emailCheck(@ModelAttribute("MmbrVO") MmbrVO vo) throws Exception{
		logger.info("emailCheck.ajax..................");

		 String check = vo.getMmbrEmail();
		 int checkResult = service.emailCheck(check);
		 return checkResult;
	}

	//승인상태(일반사용자 02)로 변경
	@RequestMapping(value="/approvalMmbr.hr", method=RequestMethod.POST)
	public void approvalMmbr(@ModelAttribute("MmbrVO") MmbrVO vo, HttpServletResponse response) throws Exception{
		logger.info("approvalMmbr.hr..................");
		service.approvalMmbr(vo,response);
	}

	//로그인 화면
	@RequestMapping(value="/login.html", method=RequestMethod.GET)
	public void openLogin() throws Exception{
		logger.info("login.html..................");
	}

	//로그인 기능 실행
	@RequestMapping(value="/login.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> login(HttpServletRequest request, @ModelAttribute("MmbrVO") MmbrVO vo) throws Exception{
		logger.info("login.ajax....................");
		return service.checkLoginInfo(vo, request.getSession());
	}

	//[ID찾기]회원 소유 ID리스트 조회
	@RequestMapping(value="/findId.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<Object,Object> findId(@ModelAttribute("MmbrVO") MmbrVO vo) throws Exception{
		logger.info("findId.ajax....................");
		return service.findIdList(vo);
	}

	//[PWD찾기]임시 비밀번호 이메일 전송
	@RequestMapping(value="/findPwd.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<Object,Object> findPwd(@ModelAttribute("MmbrVO") MmbrVO vo) throws Exception{
		logger.info("findPwd.ajax....................");
		return service.findPwd(vo);
	}

	//[정보수정]수정을 하기 위한 PWD 일치 여부 확인
	@RequestMapping(value="/access_myPage.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> accessMyPage(@ModelAttribute("MmbrVO") MmbrVO vo, HttpSession session) throws Exception{
		logger.info("access_myPage.ajax..................");

		String loginId = (String)session.getAttribute(Code.SESSION_KEY_LOGIN_ID);
		vo.setLoginId(loginId);

		return service.checkPwd(vo);
	}

	//[정보수정] 회원정보(이메일,비밀번호,기타정보) 수정 화면
	@RequestMapping(value= {"/modify_mmbr.html","/modify_pwd.html","/modify_email.html"}, method=RequestMethod.GET)
	public void OpenModifyMmbr(@ModelAttribute ("MmbrVO") MmbrVO vo,  Model model, HttpSession session) throws Exception {
		logger.info("modify_mmbrInfo.html..................");

		//로그인ID 세팅
		String loginId = (String)session.getAttribute(Code.SESSION_KEY_LOGIN_ID);
		vo.setLoginId(loginId);

		model.addAttribute("vo",service.readMmbr(vo)); //회원 정보 조회
	}

	//[정보수정] 회원정보(이메일,비밀번호,기타정보) 수정 실행
	@RequestMapping(value="/modify_mmbrInfo.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> ModifyMmbr(@ModelAttribute ("MmbrVO") MmbrVO vo) throws Exception {
		logger.info("modify_mmbrInfo.ajax.......................");

		Map<String, String> map = new HashMap<String, String>();

		if(vo.getPwd() != null) { // 비밀번호가 있을 경우 비밀번호 수정 실행
			map = service.modifyPwd(vo);
		}else if(vo.getMmbrEmail() !=null) { //이메일이 있을 경우 이메일 수정 실행
			map = service.modifyEmail(vo);
		}else { 							//기타 정보 수정 실행
			map = service.modifyMmbr(vo);
		}
		return map;
	}

	//[회원탈퇴] 회원 탈퇴여부 변경 & 회원 메모 삭제 & 로그아웃 처리
	@RequestMapping(value="/withdraw_mmbr.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> withdrawMmbr(@ModelAttribute ("MmbrVO") MmbrVO vo, HttpSession session) throws Exception {
		logger.info("withdraw_mmbr.ajax.......................");

		Map<String, String> map = new HashMap<String, String>();

		//회원 탈퇴여부 'Y' 세팅
		vo.setWthdrYn("Y");
		service.modifyMmbr(vo);

		//회원 소유 메모 삭제
		service.deleteMemo(vo);

		map.put("msg",Code.RESULT_MSG_SUCCESS);

		//로그아웃 처리
		session.invalidate();

		return map;
	}

	//로그아웃
	@RequestMapping(value="/logout.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> logout(HttpSession session) throws Exception {
		logger.info("logout.ajax....................");

		Map<String, String> map = new HashMap<String, String>();

		session.invalidate();

		map.put("msg",Code.RESULT_MSG_SUCCESS);
		return map;
	}


}
