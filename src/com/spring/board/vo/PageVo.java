package com.spring.board.vo;

import java.util.List;

public class PageVo {
	
	private int pageNo = 0;
	private List<String> boardCodeList;
	
	public List<String> getBoardCodeList() {
		return boardCodeList;
	}

	public void setBoardCodeList(List<String> boardCodeList) {
		this.boardCodeList = boardCodeList;
	}

	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}
	
}
