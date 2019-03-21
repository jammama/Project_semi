package com.nomwork.todo.dto;

import java.util.Date;

public class TodoDto {

	private int todono;
	private int projectno;
	private String todotitle;
	private String todocontent;
	private String tododate;
	private Date todoregdate;
	
	public TodoDto() {
	}
	public TodoDto(int todono, int projectno, String todotitle, String todocontent, String tododate,
			Date todoregdate) {
		super();
		this.todono = todono;
		this.projectno = projectno;
		this.todotitle = todotitle;
		this.todocontent = todocontent;
		this.tododate = tododate;
		this.todoregdate = todoregdate;
	}
	public int getTodono() {
		return todono;
	}
	public void setTodono(int todono) {
		this.todono = todono;
	}
	public int getProjectno() {
		return projectno;
	}
	public void setProjectno(int projectno) {
		this.projectno = projectno;
	}
	public String getTodotitle() {
		return todotitle;
	}
	public void setTodotitle(String todotitle) {
		this.todotitle = todotitle;
	}
	public String getTodocontent() {
		return todocontent;
	}
	public void setTodocontent(String todocontent) {
		this.todocontent = todocontent;
	}
	public String getTododate() {
		return tododate;
	}
	public void setTododate(String tododate) {
		this.tododate = tododate;
	}
	public Date getTodoregdate() {
		return todoregdate;
	}
	public void setTodoregdate(Date todoregdate) {
		this.todoregdate = todoregdate;
	}
	
	
}
