package com.memo.hr.memo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.memo.hr.common.code.Code;
import com.memo.hr.common.paging.PageMaker;
import com.memo.hr.home.vo.MmbrVO;
import com.memo.hr.memo.service.MemoService;
import com.memo.hr.memo.vo.MemoVO;

@Controller
@RequestMapping("/memo")
public class MemoController {

	@Inject
	private MemoService service;

	private static final Logger logger = LoggerFactory.getLogger("MemoController.class");

	private static final String CLSF_PATH_INDVD = "indvd"; //개별 메모
	private static final String CLSF_PATH_SHRD = "shrd";   //공유 메모

	//메모 등록 화면
	@RequestMapping(value = "/{clsfPath}/register_memo.html", method=RequestMethod.GET)
	public ModelAndView OpenRegisterMemo(@PathVariable("clsfPath") String clsfPath, HttpSession session, ModelAndView mav) throws Exception {
		logger.info("registerMemo.html......................");

		MemoVO vo = new MemoVO();

		// 소유자 세팅
		String loginId = (String)session.getAttribute(Code.SESSION_KEY_LOGIN_ID);
		vo.setOwnerId(loginId);

		mav.addObject("otherMmbrList", service.listOtherMmbr(vo));  //로그인 ID 제외한 전체 회원 리스트
		mav.addObject("pageType" , clsfPath);					   	// 페이지타입 (indvd : 개인, shrd : 공유 )
		mav.setViewName("/memo/register_memo");

		return mav;
	}

	//메모 등록 기능 실행
	@RequestMapping(value = "/{clsfPath}/register_memo.ajax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> RegsiterMemo(@ModelAttribute("MemoVO") MemoVO vo, HttpSession session) throws Exception{
		logger.info("registerMemo.ajax......................");

		Map<String,String> map = new HashMap<String,String>();

		// 작성자 세팅
		String loginId = (String)session.getAttribute(Code.SESSION_KEY_LOGIN_ID);
		vo.setOwnerId(loginId);

		int rtn = service.registerMemo(vo);  //메모 등록
		if(1 == rtn) {
			if(vo.getShrdIds() !="" || !StringUtils.isEmpty(vo.getShrdIds() )) {  //공유ID 있는 경우
				String[] shrdIdArr = vo.getShrdIds().split(",");

				MemoVO memoVo = new MemoVO();     //공유ID저장용 객체 생성
				memoVo.setOwnerId(loginId);       //소유자 세팅
				memoVo.setMemoSn(vo.getMemoSn()); //메모번호 세팅
				for(String shrdId : shrdIdArr) {
					memoVo.setShrdId(shrdId);     	// 공유ID 저장
					service.insertShrdUser(memoVo); // 공유ID 추가
				}
			}
			map.put("msg", Code.RESULT_MSG_SUCCESS);
		}else {
			map.put("msg", Code.RESULT_MSG_FAIL);
		}
		return map;
	}

	//리스트 조회 화면
	@RequestMapping(value = "/{clsfPath}/list_memo.html", method=RequestMethod.GET)
	public ModelAndView listMemo(@PathVariable("clsfPath") String clsfPath, @ModelAttribute("MemoVO") MemoVO vo, ModelAndView mav, HttpSession session) throws Exception{
		logger.info("listMemo.html......................");

		List<MemoVO> fxdMemoList = new ArrayList<MemoVO>(); //고정메모 리스트
		List<MemoVO> memoList = new ArrayList<MemoVO>(); //일반메모 리스트

		// 소유자 세팅
		String loginId = (String)session.getAttribute(Code.SESSION_KEY_LOGIN_ID);
		vo.setOwnerId(loginId);

		// 페이지 초기화
		if( vo.getPage() == 0 ) vo.setPage(1);

		// 첫번째 페이지 메모인 경우 상단 고정 메모 조회(개인 메모만 해당)
		if( CLSF_PATH_INDVD.equals(clsfPath) && 1 == vo.getPage() ) {
			vo.setFxdYn("Y");   						// 고정여부 Y로 기본세팅
			fxdMemoList = service.listIndvdMemo(vo); 	//고정여부 Y인 리스트 조회
			vo.setPerPageNum(8 - fxdMemoList.size());
		}


		// 첫번째 페이지 아닌 경우 일반 메모 조회
		vo.setFxdYn("N"); // 고정여부 N으로 기본세팅

		if(CLSF_PATH_INDVD.equals(clsfPath)) {
			if( 1 < vo.getPage() ) vo.setFxdCnt(service.countIndvdFxd(vo));
			memoList = service.listIndvdMemo(vo);  //개별 일반메모 리스트 조회
		}else if(CLSF_PATH_SHRD.equals(clsfPath)) {
			memoList = service.listShrdMemo(vo);  //공유 일반메모 리스트 조회
		}

		// 페이징 태그 생성
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(vo);

		if(CLSF_PATH_INDVD.equals(clsfPath)) {
			pageMaker.setTotalCount(service.getIndvdMemoTotalCnt(vo));

		}else if(CLSF_PATH_SHRD.equals(clsfPath)) {
			pageMaker.setTotalCount(service.getShrdMemoTotalCnt(vo));
		}

		mav.addObject("fxdMemoList", fxdMemoList);		// 고정메모 리스트
		mav.addObject("memoList", memoList);			// 일반메모 리스트
		mav.addObject("pageMaker", pageMaker);			// 페이징 정보
		mav.addObject("requestVO", vo);					// 요청 파라미터
		mav.addObject("pageType" , clsfPath);			// 페이지타입 (indvd : 개인, shrd : 공유 )
		mav.setViewName("/memo/list_memo");

		return mav;
	}

	//메모 수정 화면
	@RequestMapping(value = "/{clsfPath}/modify_memo.html", method=RequestMethod.GET)
	public ModelAndView OpenModifyMemo(@PathVariable("clsfPath") String clsfPath, @ModelAttribute("MemoVO") MemoVO vo, ModelAndView mav, HttpSession session) throws Exception{
		logger.info("modify_memo.html......................");

		//로그인ID제외한 회원리스트 조회를 위한 로그인ID 세팅
		String ownerId = (String)session.getAttribute(Code.SESSION_KEY_LOGIN_ID);
		vo.setOwnerId(ownerId);

		//공유 ID 조회
		List<MemoVO> shrdIdList = service.listShrdUser(vo);
		String ShrdIds = "";
		for(int i=0; i<shrdIdList.size(); i++) {
			ShrdIds += shrdIdList.get(i).getShrdId().toString();
			ShrdIds += ",";
		}

		//공유ID 저장
		MemoVO shrdVo = new MemoVO();
		shrdVo.setShrdIds(ShrdIds);

		MemoVO memoVo = service.readMemo(vo); 	//메모상세 조회
		memoVo.setMailCntn(memoVo.getCntnt().replaceAll("\r", "").replaceAll("\n", "<br/>")); 	//메일 전송을 위한 확장문자 변경

		mav.addObject("shrdVO",shrdVo);								//공유ID
		mav.addObject("memoVO", memoVo);							//메모 정보
		mav.addObject("mmbrVO", service.readMmbr(vo));				//회원 정보 (메일전송을 위한)
		mav.addObject("otherMmbrList", service.listOtherMmbr(vo));	//로그인ID제외한 회원리스트
		mav.addObject("requestVO", vo);								//요청 파라미터
		mav.addObject("pageType" , clsfPath);						// 페이지타입 (indvd : 개인, shrd : 공유 )
		mav.setViewName("/memo/modify_memo");

		return mav;
	}


	//메모 수정 기능 실행
	@RequestMapping(value = "/{clsfPath}/modify_memo.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> modifyMemo(@ModelAttribute ("MemoVO") MemoVO vo, HttpSession session) throws Exception{
		logger.info("modify_memo.ajax......................");

		Map<String,String> map = new HashMap<String,String>();

		//ID 세팅
		String loginId = (String)session.getAttribute(Code.SESSION_KEY_LOGIN_ID);
		vo.setOwnerId(loginId);

		int rtn = service.modifyMemo(vo);	//메모 내용 수정

		if( rtn > 0 ) {
			if(vo.getShrdIds() == "" || StringUtils.isEmpty(vo.getShrdIds())) { 	// 공유ID 없을 경우
				service.deleteShrdUser(vo); 	//공유ID 전체 삭제

			}else {		// 공유 ID 있을 경우
				service.deleteShrdUser(vo);  						//공유ID 전체 삭제(삭제 후 다시 저장 예정)
				String[] shrdIdArr = vo.getShrdIds().split(","); 	//,로 분리하여 아이디 배열 저장

				MemoVO memoVo = new MemoVO();     //공유ID저장용 객체 생성
				memoVo.setOwnerId(loginId);       //소유자 세팅
				memoVo.setMemoSn(vo.getMemoSn()); //메모번호 세팅
				for(String shrdId : shrdIdArr) {
					memoVo.setShrdId(shrdId);     	// 공유ID 저장
					service.insertShrdUser(memoVo); // 공유ID 추가
				}
			}
			map.put("msg",Code.RESULT_MSG_SUCCESS);
		}else {
			map.put("msg",Code.RESULT_MSG_FAIL);
		}
		return map;
	}

	//메모 삭제
	@RequestMapping(value = "/{clsfPath}/delete_memo.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> deleteMemo(@RequestParam ("memoSn") String memoSn) throws Exception{
		logger.info("deleteMemo.html......................");

		Map<String,String> map = new HashMap<String,String>();
		int rtn = service.deleteMemo(memoSn);
		if(rtn>0) {
			map.put("msg",Code.RESULT_MSG_SUCCESS);
		}else {
			map.put("msg",Code.RESULT_MSG_FAIL);
		}
		return map;
	}

	//메모 내용 메일 전송
	@RequestMapping(value = "/{clsfPath}/sendMail_memo.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> sendMailMemo(@ModelAttribute ("MemoVO") MemoVO memoVo, @ModelAttribute ("MmbrVO") MmbrVO mmbrVo) throws Exception{
		logger.info("sendMail_memo.ajax......................");

		Map<String,String> map = new HashMap<String,String>();
		service.sendEmailMemo(mmbrVo,memoVo,"myEmail");
		map.put("msg",Code.RESULT_MSG_SUCCESS);
		return map;
	}

	// 메모 고정여부 수정(개인 메모에서만 사용)
	@RequestMapping(value = "/{clsfPath}/updateFxdYn.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> updateFxdYn(@PathVariable("clsfPath") String clsfPath, @ModelAttribute("MemoVO") MemoVO vo, HttpSession session) throws Exception{
		logger.info("updateFxdYn.ajax...............................");

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		List<MemoVO> fxdMemoList = new ArrayList<MemoVO>();  //고정 메모 리스트
		List<MemoVO> memoList = new ArrayList<MemoVO>();	//일반 메모 리스트

		//로그인ID 세팅
		String loginId = (String)session.getAttribute(Code.SESSION_KEY_LOGIN_ID);
		vo.setOwnerId(loginId);

		//고정 메모 개수 카운트
		int cntFxd = 0;
		cntFxd = service.countIndvdFxd(vo);


		// 고정여부 Y로 변경시 현재고정메모 4개 미만 or 고정여부 N으로 변경일 경우
		if( ("Y".equals(vo.getFxdYn()) && 4 > cntFxd)  || "N".equals(vo.getFxdYn())) {
			service.modifyMemo(vo);		// 메모 고정여부 수정

			// 첫번째 페이지인 경우 상단 고정 메모 조회
			if( 1 >= vo.getPage() ) {
				vo.setFxdYn("Y"); 							// 고정여부 Y로 기본세팅
				fxdMemoList = service.listIndvdMemo(vo);	//고정여부 Y인 리스트 조회
				vo.setPerPageNum(8 - fxdMemoList.size());
			}

			// 일반 메모 조회
			vo.setFxdYn("N"); 						// 고정여부 N로 기본세팅
			if( 1 < vo.getPage() ) vo.setFxdCnt(service.countIndvdFxd(vo));
			memoList = service.listIndvdMemo(vo); 	// 일반 메모 리스트 조회

			// 페이징 태그 생성
			PageMaker pageMaker = new PageMaker();
			pageMaker.setCri(vo);
			pageMaker.setTotalCount(service.getIndvdMemoTotalCnt(vo));

			rtnMap.put("fxdMemoList", fxdMemoList);		//고정 메모 리스트
			rtnMap.put("memoList", memoList);			//일반 메모 리스트
			rtnMap.put("pageMaker", pageMaker);			// 페이징 정보

		}else { // 고정갯수 초과로 인한 고정여부 수정 실패
			rtnMap.put("msg",Code.RESULT_MSG_FAIL);
		}
		return rtnMap;
	}

}
