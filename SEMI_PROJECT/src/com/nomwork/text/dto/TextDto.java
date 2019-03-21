package com.nomwork.text.dto;

import java.util.Date;

import com.nomwork.Dto;

public class TextDto extends Dto {

	private int tno;
	private Double userno;
	private int cno;
	private int answersq;
	private int gno;
	private String tcontent;
	private String tip;
	private Date ttime;
	private int mno;
	private int fno;
	private int cvno;
	private String vurl;

	// USERINFO 테이블과 조인을 위한 변수설정
	private String useremail;
	private String username;
	private String userurl;

	// MAPS 테이블과 조인을 위한 변수설정
	private Double latitude;
	private Double longitude;

	// FILES 테이블과 조인을 위한 변수설정
	private String fstream;
	private String ftitle;
	
	// CANVAS 테이블과 조인을 위한 변수설정
	private String cvurl;

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

	public TextDto() {
		super();
	}

	public TextDto(Double userno, int cno, String tcontent) {
		super();
		this.userno = userno;
		this.cno = cno;
		this.tcontent = tcontent;
	}

	public TextDto(Double userno, int cno, int mno) {
		super();
		this.userno = userno;
		this.cno = cno;
		this.mno = mno;
	}

	public TextDto(int tno, Double userno, int cno, int answersq, String tcontent, String tip, Date ttime, int mno,
			int fno) {
		super();
		this.tno = tno;
		this.userno = userno;
		this.cno = cno;
		this.answersq = answersq;
		this.tcontent = tcontent;
		this.tip = tip;
		this.ttime = ttime;
		this.mno = mno;
		this.fno = fno;
	}
	
	public TextDto(int tno, Double userno, int cno, int answersq, String tcontent, String tip, Date ttime, int mno,
			int fno, String vurl) {
		super();
		this.tno = tno;
		this.userno = userno;
		this.cno = cno;
		this.answersq = answersq;
		this.tcontent = tcontent;
		this.tip = tip;
		this.ttime = ttime;
		this.mno = mno;
		this.fno = fno;
		this.vurl = vurl;
	}

	public int getTno() {
		return tno;
	}

	public void setTno(int tno) {
		this.tno = tno;
	}

	public Double getUserno() {
		return userno;
	}

	public void setUserno(Double userno) {
		this.userno = userno;
	}

	public int getCno() {
		return cno;
	}

	public void setCno(int cno) {
		this.cno = cno;
	}

	public int getAnswersq() {
		return answersq;
	}

	public void setAnswersq(int answersq) {
		this.answersq = answersq;
	}

	public String getTcontent() {
		return tcontent;
	}

	public void setTcontent(String tcontent) {
		this.tcontent = tcontent;
	}

	public String getTip() {
		return tip;
	}

	public void setTip(String tip) {
		this.tip = tip;
	}

	public Date getTtime() {
		return ttime;
	}

	public void setTtime(Date ttime) {
		this.ttime = ttime;
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

	public int getGno() {
		return gno;
	}

	public void setGno(int gno) {
		this.gno = gno;
	}
	
	public String getVurl() {
		return vurl;
	}

	public void setVurl(String vurl) {
		this.vurl = vurl;
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

	@Override
	public String toString() {
		
		return "[" + tno + ", " + userno + ", " + cno + ", " + answersq + ", " + tcontent + ", " + tip + ", " + ttime
				+ ", " + mno + ", " + fno + "]";
	}

}
