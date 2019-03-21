package com.nomwork.text.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import com.nomwork.NomworkInit;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.map.dto.MapDto;
import com.nomwork.project.dao.ProjectDao;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.text.dao.TextDao;
import com.nomwork.text.dto.TextDto;
import com.nomwork.user.dto.UserDto;

@WebServlet("/TextServlet")
public class TextServlet extends HttpServlet implements NomworkInit {
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

	public TextServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		String command = request.getParameter("command");
		System.out.println("[TextServlet - " + command + "]");
		//
		session = request.getSession();
		out = response.getWriter();

		if (command.equals("text_link")) {

			// 링크 URL 변수값 설정
			String url = request.getParameter("url");
			System.out.println("[TextServlet - 파라미터로 전해받은 URL : " + url + "]");

			// 데이터 크롤링을 위한 JSOUP
			Document doc = Jsoup.connect(url).get();
			System.out.println("[TextServlet - DOC 변수에 담긴 TEXT : " + doc.text() + "]");
			out.println(doc.text());
			
		} // 채팅 쓰레드
		else if (command.equals("select_text_list")) {
			
			List<TextDto> tdtos = null;
			
			int tno = Integer.parseInt(request.getParameter("tno"));
			System.out.println("[TextServlet - 선택된 텍스트 번호 : " +  tno + "]");
			
			//선택된 해당 텍스트의 답글 조회
			tdtos = T_DAO.select(tno);

			System.out.println("[TextServlet - 조회된 답글 목록 : " +  tdtos + "]");
			
			JSONObject jObject = new JSONObject();
			JSONArray jArray = new JSONArray();
			
			//해당 답글 텍스트들을 전달하기 위한 JSON 처리
			for (TextDto tmp_tdto : tdtos) {
				//답글 텍스트 객체를 JSON OBJECT에 담기
				JSONObject tdto = new JSONObject();
				tdto.put("tno", tmp_tdto.getTno());
				tdto.put("userno", tmp_tdto.getUserno());
				tdto.put("cno", tmp_tdto.getCno());
				tdto.put("tcontent", tmp_tdto.getTcontent());
				tdto.put("answersq", tmp_tdto.getAnswersq());
				tdto.put("username", tmp_tdto.getUsername());
				tdto.put("userurl", tmp_tdto.getUserurl());
				tdto.put("fno", tmp_tdto.getFno());
				tdto.put("ttime", tmp_tdto.getTtime().toString());
				tdto.put("mno", tmp_tdto.getMno());
				
				//각각의 텍스트 객체들의 정보가 담긴 JSON OBJECT를 ARRAY에 담기
				jArray.add(tdto);
			}
			
			//클라이언트에게 전달하기 위한 작업
			jObject.put("tdto", jArray);
			System.out.println("[TextServlet - AJAX로 보낼 데이터 : " +  jObject.toJSONString() + "]");
			out.println(jObject.toJSONString());
			
		}if(command.equals("chattoboard")) {
			int textno = Integer.parseInt(request.getParameter("textno"));
			TextDao dao = new TextDao();
			int result = dao.insert_chattoboard(textno);
			
			PrintWriter out = response.getWriter();
			out.println(result);
			
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
