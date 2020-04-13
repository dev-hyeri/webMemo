package com.memo.hr.admin.controller;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.memo.hr.admin.service.adminService;
import com.memo.hr.common.code.Code;
import com.memo.hr.common.exception.vo.ExceptionVO;
import com.memo.hr.common.paging.PageMaker;
import com.memo.hr.home.vo.MmbrVO;

@Controller
@RequestMapping("/admin")
public class adminController {

	@Inject
	private adminService service;
	private static final Logger logger = LoggerFactory.getLogger("adminController.class");

	//회원 리스트 화면
	@RequestMapping(value="/list_mmbr.html", method=RequestMethod.GET)
	public void listMmbr(@ModelAttribute("MmbrVO") MmbrVO vo, Model model) throws Exception {
		logger.info("listMmbr.html..................");

		// 페이징 태그 생성
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(vo);
		pageMaker.setTotalCount(service.getMmbrTotalCnt(vo));

		model.addAttribute("countMmbr",service.getMmbrTotalCnt(vo));
		model.addAttribute("listMmbr",service.listMmbr(vo));	//회원 리스트
		model.addAttribute("pageMaker", pageMaker);	 			//페이징 정보
		model.addAttribute("requestVO", vo);					//요청 파라미터
	}

	//회원 상세 조회 화면
	@RequestMapping(value="/detail_mmbr.html", method=RequestMethod.GET)
	public void detailMmbr(@ModelAttribute("MmbrVO") MmbrVO vo,Model model) throws Exception {
		logger.info("DetailMmbr.html..................");

		model.addAttribute("vo",service.detailMmbr(vo));	//회원 정보
		model.addAttribute("requestVO", vo);				//요청 파라미터
	}

	//에러 리스트 조회 화면
	@RequestMapping(value="/list_error.html", method=RequestMethod.GET)
	public void listError(@ModelAttribute("ExceptionVO") ExceptionVO vo,Model model) throws Exception {
		logger.info("listError.html..................");

		//페이징태그 생성
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(vo);
		pageMaker.setTotalCount(service.getMmbrErrorCnt(vo));

		model.addAttribute("listError",service.listError(vo));	//에러 리스트
		model.addAttribute("pageMaker", pageMaker);				//페이징 정보
		model.addAttribute("requestVO", vo);					//요청 파라미터
	}

	//에러 상세 조회 화면
	@RequestMapping(value="/detail_error.html", method=RequestMethod.GET)
	public void detailError(@ModelAttribute("ExceptionVO") ExceptionVO vo,Model model) throws Exception {
		logger.info("DetailError.html..................");

		model.addAttribute("vo",service.detailError(vo));	//에러 정보
		model.addAttribute("requestVO", vo);				//요청 파라미터
	}

	//에러 내역 삭제
	@RequestMapping(value="/delete_error.ajax", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> deleteError(@ModelAttribute("ExceptionVO") ExceptionVO vo,Model model) throws Exception {
		logger.info("DeleteError.html..................");

		Map<String,String> map = new HashMap<String,String>();

		int rtn = service.deleteError(vo.getErrorSn()); //에러 내역 삭제
		if(rtn > 0) {
			map.put("msg",Code.RESULT_MSG_SUCCESS);
		}else {
			map.put("msg",Code.RESULT_MSG_FAIL);
		}
		return map;
	}

}