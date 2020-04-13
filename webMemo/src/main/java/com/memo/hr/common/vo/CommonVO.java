package com.memo.hr.common.vo;

import com.memo.hr.common.paging.vo.Criteria;

public class CommonVO extends Criteria {

	private String searchType;		// 검색 타입
	private String searchText;		// 검색어

	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	public String getSearchText() {
		return searchText;
	}
	public void setSearchText(String searchText) {
		this.searchText = searchText;
	}
}
