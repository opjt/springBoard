package com.spring.board.vo;

import java.util.List;

public class PageVo {
	
	private int pageNo = 0;
	private int showCount = 10; //한번에 보여지는 게시글 수 
	private boolean checkBoardType = true; //boardType 존재여부 
	
	public boolean isCheckBoardType() {
		return checkBoardType;
	}

	public void setCheckBoardType(boolean checkBoardType) {
		this.checkBoardType = checkBoardType;
	}

	public int getShowCount() {
		return showCount;
	}

	public void setShowCount(int showCount) {
		this.showCount = showCount;
	}

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
