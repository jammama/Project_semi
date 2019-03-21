package com.nomwork.todo.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nomwork.NomworkInit;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.map.dto.MapDto;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.text.dto.TextDto;
import com.nomwork.todo.dao.TodoDao;
import com.nomwork.todo.dao.Util;
import com.nomwork.todo.dto.TodoDto;
import com.nomwork.user.dto.UserDto;

@WebServlet("/TodoServlet")
public class TodoServlet extends HttpServlet implements NomworkInit {
	private static final long serialVersionUID = 1L;

	// 각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	private MapDto mdto;
	private TextDto tdto;
	//
	private HttpSession session;
	private PrintWriter out;

	public TodoServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		String command = request.getParameter("command");
		System.out.println("[TodoServlet - " + command + "]");
		//
		session = request.getSession();
		out = response.getWriter();

		if (command.equals("Todo")) {

			int projectno = Integer.parseInt(request.getParameter("projectno"));

			request.setAttribute("projectno", projectno);
			dispatch(request, response, "calendar/todo.jsp");

		} 
		else if (command.equals("change")) {

			dispatch(request, response, "calendar/todo.jsp");

		} 
		else if (command.equals("todolist")) {

			String year = request.getParameter("year");
			String month = request.getParameter("month");
			String date = request.getParameter("date");

			String yyyyMMdd = year + Util.isTwo(month) + Util.isTwo(date);
			int projectno = Integer.parseInt(request.getParameter("projectno"));

			List<TodoDto> list = TD_DAO.select(projectno, yyyyMMdd);
			request.setAttribute("projectno", projectno);
			request.setAttribute("list", list);
			dispatch(request, response, "calendar/todoList.jsp");

		} 
		else if (command.equals("selectone")) {

			String tododate = request.getParameter("tododate");

			TodoDto dto = TD_DAO.select(tododate);
			request.setAttribute("dto", dto);
			dispatch(request, response, "calendar/selectOne.jsp");

		} 
		else if (command.equals("insert")) {

			dispatch(request, response, "calendar/insertTodo.jsp");

		} 
		else if (command.equals("insertTodo")) {

			String year = request.getParameter("year");
			String month = request.getParameter("month");
			String date = request.getParameter("date");
			String hour = request.getParameter("hour");
			String minute = request.getParameter("minute");

			String tododate = year + Util.isTwo(month) + Util.isTwo(date) + Util.isTwo(hour) + Util.isTwo(minute);

			int projectno = Integer.parseInt(request.getParameter("projectno"));
			String todotitle = request.getParameter("todotitle");
			String todocontent = request.getParameter("todocontent");

			int res = TD_DAO.insert(new TodoDto(0, projectno, todotitle, todocontent, tododate, null));

			if (res > 0) {
				request.setAttribute("projectno", projectno);
				dispatch(request, response, "calendar/todo.jsp");

			} else {
				PrintWriter out = response.getWriter();
				out.println("<script>alert('일정 작성 실패'); history.back(-1);</script>");
				out.close();
			}

		} 
		else if (command.equals("muldel")) {
			String[] todono = request.getParameterValues("chk");

			int res = TD_DAO.delete(todono);
			
			if (res == todono.length) {
				
				int projectno = Integer.parseInt(request.getParameter("projectno"));
				request.setAttribute("projectno", projectno);
				dispatch(request, response, "calendar/todo.jsp");
				
			} 
			else {
				
				PrintWriter out = response.getWriter();
				out.println("<script>alert('일정 삭제 실패'); history.back(-1);</script>");
				out.close();
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		doGet(request, response);
	}

	private void dispatch(HttpServletRequest request, HttpServletResponse response, String url)
			throws ServletException, IOException {
		RequestDispatcher dispatch = request.getRequestDispatcher(url);
		dispatch.forward(request, response);
	}
}
