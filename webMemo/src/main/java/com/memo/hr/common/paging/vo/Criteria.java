package com.memo.hr.common.paging.vo;

public class Criteria {

		private int page;
		private int perPageNum;

		private int fxdCnt;

		public Criteria() {
			this.page=1;
			this.perPageNum=8;
		}

		public void setPage(int page) {
			if(page<=0) {
				this.page=1;
				return;
			}
			this.page = page;
		}

		public void setPerPageNum(int perPageNum) {

			if(perPageNum<=0||perPageNum > 100) {
				this.perPageNum = 8;
				return;
			}
			this.perPageNum = perPageNum;
		}

		public int getPage() {
			return page;
		}

		public int getPageStart() {
			int rslt = 0;

			if( this.fxdCnt > 0 ) {
				rslt = (this.page-1)*perPageNum - fxdCnt;
			} else {
				rslt = (this.page-1)*perPageNum;
			}

			return rslt;
		}

		public int getPerPageNum() {
			return perPageNum;
		}

		public int getFxdCnt() {
			return fxdCnt;
		}

		public void setFxdCnt(int fxdCnt) {
			this.fxdCnt = fxdCnt;
		}

		public String toString() {
			return "Criteria [page=" + page + ", " + "perPageNum=" + perPageNum + "]";
		}

}