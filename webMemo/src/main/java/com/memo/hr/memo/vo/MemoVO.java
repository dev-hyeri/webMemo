package com.memo.hr.memo.vo;

import com.memo.hr.common.vo.CommonVO;

public class MemoVO extends CommonVO{
	private String memoSn;
	private String ownerId;
	private String cntnt;
	private String allShrdYn;
	private String prtShrdYn;
	private String fxdYn;
	private String delYn;
	private String rgstDttm;
	private String mdfDttm;
	private String shrdId;

	private String mailCntn;

	// 화면용
	private String shrdIds;

	public String getMemoSn() {
		return memoSn;
	}
	public void setMemoSn(String memoSn) {
		this.memoSn = memoSn;
	}
	public String getOwnerId() {
		return ownerId;
	}
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}
	public String getCntnt() {
		return cntnt;
	}
	public void setCntnt(String cntnt) {
		this.cntnt = cntnt;
	}
	public String getAllShrdYn() {
		return allShrdYn;
	}
	public void setAllShrdYn(String allShrdYn) {
		this.allShrdYn = allShrdYn;
	}
	public String getPrtShrdYn() {
		return prtShrdYn;
	}
	public void setPrtShrdYn(String prtShrdYn) {
		this.prtShrdYn = prtShrdYn;
	}
	public String getFxdYn() {
		return fxdYn;
	}
	public void setFxdYn(String fxdYn) {
		this.fxdYn = fxdYn;
	}
	public String getDelYn() {
		return delYn;
	}
	public void setDelYn(String delYn) {
		this.delYn = delYn;
	}
	public String getRgstDttm() {
		return rgstDttm;
	}
	public void setRgstDttm(String rgstDttm) {
		this.rgstDttm = rgstDttm;
	}

	public String getMdfDttm() {
		return mdfDttm;
	}
	public void setMdfDttm(String mdfDttm) {
		this.mdfDttm = mdfDttm;
	}
	public String getShrdIds() {
		return shrdIds;
	}
	public void setShrdIds(String shrdIds) {
		this.shrdIds = shrdIds;
	}
	public String getShrdId() {
		return shrdId;
	}
	public void setShrdId(String shrdId) {
		this.shrdId = shrdId;
	}
	public String getMailCntn() {
		return mailCntn;
	}
	public void setMailCntn(String mailCntn) {
		this.mailCntn = mailCntn;
	}
	@Override
	public String toString() {
		return "MemoVO [memoSn=" + memoSn + ", ownerId=" + ownerId + ", cntnt=" + cntnt + ", allShrdYn=" + allShrdYn
				+ ", prtShrdYn=" + prtShrdYn + ", fxdYn=" + fxdYn + ", delYn=" + delYn + ", rgstDttm=" + rgstDttm
				+ ", mdfDttm=" + mdfDttm + ", shrdId=" + shrdId + ", shrdIds=" + shrdIds + "]";
	}

}
