package com.memo.hr.common.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.memo.hr.common.code.Code;
import com.memo.hr.home.vo.MmbrVO;

public class CommonInterceptor extends HandlerInterceptorAdapter{

	private static final Logger logger = LoggerFactory.getLogger("CommonInterceptor.class");

	 static final List<String> noSessionCheckURIList = new NoSessionCheckURI().getNscul();	//세션체크 제외 URI리스트

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		String requestURI = request.getRequestURI();	//요청 URI
		MmbrVO loginSessionVO = (MmbrVO) request.getSession().getAttribute(Code.SESSION_KEY_LOGIN_INFO);

		if( !noSessionCheckURIList.contains(requestURI) ) {		//요청 URI가 제외 리스트가 아닌 경우

			if( loginSessionVO == null || StringUtils.isEmpty(loginSessionVO.getLoginId()) ) { 	//로그인 정보가 없는 경우 로그인 화면으로 전환
				response.sendRedirect("/hyeri/home/login.html");

			} else if ( requestURI.indexOf("/admin/") > -1 ) { 	// 로그인 정보가 있고 관리자 페이지 요청 시

				if( !Code.GRP_CMN_CD_00001_01.equals(loginSessionVO.getAuthCd()) ) { // 관리자가 아닌경우 개별 메모 리스트 화면으로 전환
					response.sendRedirect("/hyeri/memo/indvd/list_memo.html");
				}
			}
		} else {	//요청 URI가 제외 리스트인 경우

			if( loginSessionVO != null ) {	//로그인 정보가 있을 경우
				if( requestURI.indexOf("/login") > -1
					|| requestURI.indexOf("/join") > -1  ) { 	//로그인 or 회원가입 화면인 경우

					if( !Code.GRP_CMN_CD_00001_01.equals(loginSessionVO.getAuthCd()) ) { 	//관리자가 아닌 경우 개별 메모 리스트로 전환
						response.sendRedirect("/hyeri/memo/indvd/list_memo.html");
					} else {																//관리자인 경우 회원 관리로 전환
						response.sendRedirect("/hyeri/admin/list_mmbr.html");
					}
				}
			}
		}

		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		logger.debug("========== postHandle ==========");
		super.postHandle(request, response, handler, modelAndView);
	}
}
