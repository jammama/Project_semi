package com.nomwork.canvas.web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nomwork.NomworkInit;
import com.nomwork.canvas.dao.CanvasDao;
import com.nomwork.canvas.dto.CanvasDto;
import com.nomwork.channel.dao.ChannelDao;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.map.dao.MapDao;
import com.nomwork.map.dto.MapDto;
import com.nomwork.project.dao.ProjectDao;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.text.dto.TextDto;
import com.nomwork.user.dao.UserDao;
import com.nomwork.user.dto.UserDto;

@WebServlet("/CanvasServlet")
public class CanvasServlet extends HttpServlet implements NomworkInit {
	private static final long serialVersionUID = 1L;

		// 각 DTO 선언
		private ProjectDto pdto;
		private Project_CreateDto p_cdto;
		private ChannelDto cdto;
		private Channel_CreateDto c_cdto;
		private UserDto udto;
		private MapDto mdto;
		private CanvasDto cvdto;
		private TextDto tdto;
		//
		private HttpSession session;
		private PrintWriter out;

       
    public CanvasServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String command = request.getParameter("command");
		System.out.println("[CanvasServlet - " + command + "]");
		
		session = request.getSession();
		out = response.getWriter();
		
		int insert_canvas_res = 0;
		
		if(command.equals("insert_canvas")) {
			
			String canvasURL=request.getParameter("canvasURL");
			System.out.println("[CanvasServlet - 파라미터로 전해받은 캔버스 경로 " + canvasURL + "]");
			
			// 텍스트 객체를 생성하기 위한 유저 정보와 채널 정보
			udto = (UserDto) session.getAttribute("udto");
			cdto = (ChannelDto) session.getAttribute("cdto");
			
			//파라미터로 전해받은 캔버스 경로를 가지는 캔버스 객체 생성
			cvdto = new CanvasDto(canvasURL);
			
			// 데이터 베이스에 입력
			insert_canvas_res = CV_DAO.insert(cvdto);
			
			if (insert_canvas_res > 0) { // INSERT 성공시
				
				// 캔버스 번호를 가지는 텍스트 객체 생성
				tdto = new TextDto();
				tdto.setUserno(udto.getUserno());
				tdto.setCno(cdto.getCno());
				tdto.setCvno(cvdto.getCvno());
				
				int insert_text_res = T_DAO.insert(tdto);
				
				if(insert_text_res > 0) { // INSERT 성공시
					
					String str="";
					   str = "<script language='javascript'>";
					   str += "opener.window.location.reload();";  //오프너 새로고침
					   str += "self.close();";   // 창닫기
					   str += "</script>";
					   out.print(str);
					
				}   
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}
	
	public void dispatch(HttpServletRequest request, HttpServletResponse response, String URL)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher(URL);
		dispatcher.forward(request, response);
	}

}
