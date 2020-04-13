package com.memo.hr.common.exception.vo;

import com.memo.hr.common.vo.CommonVO;

public class ExceptionVO extends CommonVO {
	private int errorSn;
	private String excpt;
	private String cntnt;
	private String loginId;
	private String rgstDttm;


	public int getErrorSn() {
		return errorSn;
	}
	public void setErrorSn(int errorSn) {
		this.errorSn = errorSn;
	}

	public String getExcpt() {
		return excpt;
	}
	public void setExcpt(String excpt) {
		this.excpt = excpt;
	}

	public String getCntnt() {
		return cntnt;
	}
	public void setCntnt(String cntnt) {
		this.cntnt = cntnt;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getRgstDttm() {
		return rgstDttm;
	}
	public void setRgstDttm(String rgstDttm) {
		this.rgstDttm = rgstDttm;
	}

	@Override
	public String toString() {
		return "ExceptionVO [errorSn=" + errorSn + ", excpt=" + excpt + ", cntnt=" + cntnt + ", loginId=" + loginId
				+ ", rgstDttm=" + rgstDttm + "]";
	}



}
