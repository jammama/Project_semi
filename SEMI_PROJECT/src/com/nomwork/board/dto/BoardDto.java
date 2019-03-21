package com.nomwork.board.dto;

import java.util.Date;

import com.nomwork.Dto;

public class BoardDto extends Dto {
	
	private int bno;
	private double userno;
	private int pno;
	private String btitle;
	private String bcontent;
	private String delflag;
	private Date regdate;
	private int mno;
	private int fno;
	
    //USERINFO 테이블과 조인을 위한 변수설정
    private String useremail;
    private String username;
    private String userurl;
    
    //MAPS 테이블과 조인을 위한 변수설정
    private Double latitude;
    private Double longitude;
    
    //FILES 테이블과 조인을 위한 변수설정
	private String fstream;
	private String ftitle;
	
	public BoardDto() {
		super();
	}

	public BoardDto(int bno, int userno, int pno, String btitle, String bcontent, String delflag, Date regdate, int mno,
			int fno) {
		super();
		this.bno = bno;
		this.userno = userno;
		this.pno = pno;
		this.btitle = btitle;
		this.bcontent = bcontent;
		this.delflag = delflag;
		this.regdate = regdate;
		this.mno = mno;
		this.fno = fno;
	}

	public int getBno() {
		return bno;
	}

	public void setBno(int bno) {
		this.bno = bno;
	}

	public double getUserno() {
		return userno;
	}

	public void setUserno(double userno) {
		this.userno = userno;
	}

	public int getPno() {
		return pno;
	}

	public void setPno(int pno) {
		this.pno = pno;
	}

	public String getBtitle() {
		return btitle;
	}

	public void setBtitle(String btitle) {
		this.btitle = btitle;
	}

	public String getBcontent() {
		return bcontent;
	}

	public void setBcontent(String bcontent) {
		this.bcontent = bcontent;
	}

	public String getDelflag() {
		return delflag;
	}

	public void setDelflag(String delflag) {
		this.delflag = delflag;
	}

	public Date getRegdate() {
		return regdate;
	}

	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

	public int getMno() {
		return mno;
	}

	public void setMno(int mno) {
		this.mno = mno;
	}

	public int getFno() {
		return fno;
	}

	public void setFno(int fno) {
		this.fno = fno;
	}
	
	
	public String getUseremail() {
		return useremail;
	}

	public void setUseremail(String useremail) {
		this.useremail = useremail;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getUserurl() {
		return userurl;
	}

	public void setUserurl(String userurl) {
		this.userurl = userurl;
	}

	public Double getLatitude() {
		return latitude;
	}

	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}

	public Double getLongitude() {
		return longitude;
	}

	public void setLongitude(Double longitude) {
		this.longitude = longitude;
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

		return "[ " + bno + " , " + userno + " , " + pno + " , " + btitle + " , " + bcontent + " , " +
		delflag + " , " + regdate + " , " + mno + " , " + fno + " ]";
	}
}
