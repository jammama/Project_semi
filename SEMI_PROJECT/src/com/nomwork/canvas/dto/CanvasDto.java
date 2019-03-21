package com.nomwork.canvas.dto;

public class CanvasDto {

	private int cvno;
	private String cvurl;
	
	public CanvasDto() {
	}

	public CanvasDto(String cvurl) {
		this.cvurl = cvurl;
	}

	public int getCvno() {
		return cvno;
	}

	public void setCvno(int cvno) {
		this.cvno = cvno;
	}

	public String getCvurl() {
		return cvurl;
	}

	public void setCvurl(String cvurl) {
		this.cvurl = cvurl;
	}

	
	
}
