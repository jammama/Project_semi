package com.nomwork.todo.dao;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import com.nomwork.todo.dto.TodoDto;

public class Util {
	private String toDates;
	
	public String getToDates() {

		return toDates;
	}
	
	public void setToDates(String mDate) {
		//yyyyMMddhhmm
		//yyyy-MM-DD hh:mm:00
		String m=mDate.substring(0, 4)+"-"
				+mDate.substring(4,6)+"-"
				+mDate.substring(6,8)+" "
				+mDate.substring(8,10)+":"
				+mDate.substring(10)+":00";
		SimpleDateFormat sdf=new SimpleDateFormat(
				"yyyy년MM월dd일");
		Timestamp tm = Timestamp.valueOf(m);
		toDates=sdf.format(tm);
	}
	
	//한자리수를 두자리수로 변환
	public static String isTwo(String msg) {
		return (msg.length()<2)?"0"+msg:msg;
	}
	
	public static String fontColor(int date, int dayOfWeek) {
		String color="";
		// 토,일 폰트 : #8b898b
		if((dayOfWeek-1+date)%7==0||(dayOfWeek-1+date)%7==1) {
			color="#8b898b";
		}else {
			color="black";
		}
		return color;
	}
	public static String bgColor(int date, int dayOfWeek, int year, int month) {
		Calendar cal = Calendar.getInstance();
		int today = cal.get(Calendar.DAY_OF_MONTH);
		int thisyear = cal.get(Calendar.YEAR);
		int thismonth = cal.get(Calendar.MONTH)+1;
		
		String color="";
		// 토,일 배경컬러 : #efebf5
		if((dayOfWeek-1+date)%7==0||(dayOfWeek-1+date)%7==1) {
			color="white";
		// 오늘 날짜 배경컬러
		}else if(year==thisyear&&month==thismonth&&date==today) {
			color="#f0f0f0";
		}else {
			color="white";
		}
		return color;
	}
	public static String getCalView(int i,List<TodoDto> clist) {
	
		String res = "";
		String d=isTwo(i+"");
		
		for(TodoDto dto:clist) {
			if(dto.getTododate().substring(6, 8).equals(d)) {
				res+="<p>"+	((dto.getTodotitle().length()>6)?
								dto.getTodotitle().substring(0, 5)+"..."
								:dto.getTodotitle())+"</p>";								
			}
		}
		return res;
	}
}
