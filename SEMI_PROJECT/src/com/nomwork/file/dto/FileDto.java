package com.nomwork.file.dto;

import com.nomwork.Dto;

public class FileDto extends Dto {

	private int fno;
	private String fstream;
	private String ftitle;

	public FileDto() {
		super();
	}

	public FileDto(int fno, String fstream, String ftitle) {
		super();
		this.fno = fno;
		this.fstream = fstream;
		this.ftitle = ftitle;
	}
	
	public FileDto(String fstream, String ftitle) {
		super();
		this.fstream = fstream;
		this.ftitle = ftitle;
	}

	public int getFno() {
		return fno;
	}

	public void setFno(int fno) {
		this.fno = fno;
	}

	public String getFstream() {
		return fstream;
	}

	public void setFstream(String fstream) {
		this.fstream = fstream;
	}

	public String getFtitle() {
		return ftitle;
	}

	public void setFtitle(String ftitle) {
		this.ftitle = ftitle;
	}

	@Override
	public String toString() {

		return "[ " + fno + " , " + fstream + " , " + ftitle + " ]";
	}

}
