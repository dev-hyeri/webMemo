package com.memo.hr.common.interceptor;

import java.util.ArrayList;
import java.util.List;

public class NoSessionCheckURI {
	private List<String> nscul;

	public NoSessionCheckURI() {
		nscul = new ArrayList<String>();

		nscul.add("/hyeri/home/login.html");
		nscul.add("/hyeri/home/login.ajax");
		nscul.add("/hyeri/home/logout.ajax");
		nscul.add("/hyeri/home/join.html");
		nscul.add("/hyeri/home/join.ajax");
		nscul.add("/hyeri/home/idCheck.ajax");
		nscul.add("/hyeri/home/emailCheck.ajax");
		nscul.add("/hyeri/home/approvalMmbr.hr");
		nscul.add("/hyeri/home/findId.ajax");
		nscul.add("/hyeri/home/findPwd.ajax");
	}

	public List<String> getNscul(){
		return this.nscul;
	}
}
