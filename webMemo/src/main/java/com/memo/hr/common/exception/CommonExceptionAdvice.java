package com.memo.hr.common.exception;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.memo.hr.common.code.Code;
import com.memo.hr.common.exception.service.ExceptionService;
import com.memo.hr.common.exception.vo.ExceptionVO;

@ControllerAdvice
public class CommonExceptionAdvice {

	@Inject
	ExceptionService service;

	/**
	 * 전체 exception 설정
	 * @param Exception ex ,Model model, HttpSession session , HttpServletResponse response
	 * @return String
	 * @throws Exception
	 */
	@ExceptionHandler(Exception.class)
	public String except(Exception ex ,Model model, HttpSession session , HttpServletResponse response) throws Exception {
		ExceptionVO vo = new ExceptionVO();

		// 예외내용 문자열로 변경
		String excpt = null;
		String excptCntnt = "";
		for( StackTraceElement tmp : ex.getStackTrace() ) {
			if( excpt == null ) excpt = tmp.toString(); 	//첫째줄 예외 대표로 세팅
			excptCntnt += (tmp.toString() + "\n");			//나머지 상세 내용으로 세팅
		}

		vo.setExcpt(excpt);			// 예외
		vo.setCntnt(excptCntnt);	//예외 상세 내용
		vo.setLoginId((String)session.getAttribute(Code.SESSION_KEY_LOGIN_ID));	// 로그인ID
		service.insertExcptLog(vo); //에러추가

		return "/error/error_page";
	}
}