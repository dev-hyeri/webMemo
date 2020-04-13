package com.memo.hr.home.vo;

import com.memo.hr.common.vo.CommonVO;

public class MmbrVO extends CommonVO {
	private String loginId;
	private String pwd;
	private String mmbrNm;
	private String mmbrSex;
	private String mmbrBirth;
	private String mmbrTel;
	private String mmbrEmail;
	private String joinDttm;
	private String authCd;
	private String wthdrYn;
	private String memoCnt;
	private String approvalKey;

	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getMmbrNm() {
		return mmbrNm;
	}
	public void setMmbrNm(String mmbrNm) {
		this.mmbrNm = mmbrNm;
	}
	public String getMmbrSex() {
		return mmbrSex;
	}
	public void setMmbrSex(String mmbrSex) {
		this.mmbrSex = mmbrSex;
	}
	public String getMmbrBirth() {
		return mmbrBirth;
	}
	public void setMmbrBirth(String mmbrBirth) {
		this.mmbrBirth = mmbrBirth;
	}
	public String getMmbrTel() {
		return mmbrTel;
	}
	public void setMmbrTel(String mmbrTel) {
		this.mmbrTel = mmbrTel;
	}
	public String getMmbrEmail() {
		return mmbrEmail;
	}
	public void setMmbrEmail(String mmbrEmail) {
		this.mmbrEmail = mmbrEmail;
	}
	public String getJoinDttm() {
		return joinDttm;
	}
	public void setJoinDttm(String joinDttm) {
		this.joinDttm = joinDttm;
	}
	public String getAuthCd() {
		return authCd;
	}
	public void setAuthCd(String authCd) {
		this.authCd = authCd;
	}
	public String getWthdrYn() {
		return wthdrYn;
	}
	public void setWthdrYn(String wthdrYn) {
		this.wthdrYn = wthdrYn;
	}
	public String getMemoCnt() {
		return memoCnt;
	}
	public void setMemoCnt(String memoCnt) {
		this.memoCnt = memoCnt;
	}

	public String getApprovalKey() {
		return approvalKey;
	}
	public void setApprovalKey(String approvalKey) {
		this.approvalKey = approvalKey;
	}
	@Override
	public String toString() {
		return "MmbrVO [loginId=" + loginId + ", pwd=" + pwd + ", mmbrNm=" + mmbrNm + ", mmbrSex=" + mmbrSex
				+ ", mmbrBirth=" + mmbrBirth + ", mmbrTel=" + mmbrTel + ", mmbrEmail=" + mmbrEmail + ", joinDttm="
				+ joinDttm + ", authCd=" + authCd + ", wthdrYn=" + wthdrYn + ", memoCnt=" + memoCnt + ", approvalKey=" + approvalKey + "]";
	}
}
