package com.nomwork.board.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

import com.nomwork.Dto;
import com.nomwork.DtoFactory;
import com.nomwork.NomworkInit;
import com.nomwork.TypeDtoFactory;
import com.nomwork.board.dao.BoardDao;
import com.nomwork.board.dto.BoardDto;
import com.nomwork.channel.dao.ChannelDao;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.file.dao.FileDao;
import com.nomwork.file.dto.FileDto;
import com.nomwork.map.dto.MapDto;
import com.nomwork.project.dao.ProjectDao;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.text.dto.TextDto;
import com.nomwork.user.dao.UserDao;
import com.nomwork.user.dto.UserDto;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@WebServlet("/BoardServlet")
public class BoardServlet extends HttpServlet implements NomworkInit {
	private static final long serialVersionUID = 1L;
	
	// 각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	private MapDto mdto;
	private TextDto tdto;
	private BoardDto bdto;
	private FileDto fdto;
	
	//
	private HttpSession session;
	private PrintWriter out;

	public BoardServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		String command = request.getParameter("command");
		System.out.println("[BoardServlet - " + command + "]");

		// PrintWriter 객체 생성
		out = response.getWriter();
		session = request.getSession();
		
		if (command.equals("inserttext")) {

			String inputtext = request.getParameter("inputtext");

			bdto = new BoardDto();
			bdto.setUserno(1.0);
			bdto.setBcontent(inputtext);
			int result = B_DAO.insert(bdto);
			out.println(inputtext + result);

		} else if (command.equals("reflash_board_list")) {
			
			List<BoardDto> bdtos = null;
			int pageno = 0;
			
			ProjectDto pdto = (ProjectDto) session.getAttribute("pdto");
			
			try { //파라미터로 전해받은 페이지 번호가 있는 경우
				pageno = Integer.parseInt(request.getParameter("pageno"));
				System.out.println("[BoardServlet - 파라미터로 전해받은 페이지 번호가 있는 경우, 선택 페이지 번호 :" + pageno + "]");
				
			} // 파라미터로 전해받은 페이지 번호가 없는 경우
			catch (Exception e) {
				System.out.println("[BoardServlet - 파라미터로 전해받은 페이지 번호가 없는 경우 ]");
				pageno = 1;
			}

			// 페이지 숫자 정하는 파트
			int count_all = B_DAO.select_board_count(pdto.getPno());
			int remain = 0;

			if (count_all % 10 > 0) {
				remain = 1;
			}
			
			int num_of_pages = (count_all / 10) + remain;
			int indexno = Math.min(10, num_of_pages - 10 * ((pageno - 1) / 10));
			int[] num_of_page = new int[indexno];
			System.out.println("[BoardServlet - MIN NUMBER : " + indexno + "]");
			
			for (int i = 0; i < indexno; i++) {
				num_of_page[i] = i + 1 + 10 * ((pageno - 1) / 10);
			}
			
			// 페이지에 맞는 게시물 10개만 가져오는 파트
			bdtos = B_DAO.select(pdto.getPno(), pageno);
			System.out.println("[BoardServlet - 게시글 목록 " + bdtos + " ]");
			
			request.setAttribute("num_of_page", num_of_page);
			request.setAttribute("bdtos", bdtos);
			request.setAttribute("pageno", pageno);
			dispatch(request, response, "board/main_board.jsp");


		}
		else if (command.equals("search_board_by_content")) {
			
			List<BoardDto> bdtos = null;

			int pno = Integer.parseInt(request.getParameter("pno"));
			int pageno = Integer.parseInt(request.getParameter("pageno"));
			String bcontent = "%" + request.getParameter("bcontent") + "%";
			System.out.println("[BoardServlet - PROJECTNO : " + pno  + " PAGENO : " + pageno + " BCONTENT : " + bcontent + " ]");
			
			// 페이지에 맞는 게시물 10개만 가져오는 파트
			bdtos = B_DAO.select(pno, pageno, bcontent);
			System.out.println("[BoardServlet - 검색된 게시글 목록 " + bdtos + " ]");
			
			// 페이지 숫자 정하는 파트
			int count_all = bdtos.size();
			int remain = 0;
			
			if (count_all % 10 > 0) {
				remain = 1;
			}
			
			int num_of_pages = (count_all / 10) + remain;
			int indexno = Math.min(10, num_of_pages - 10 * ((pageno - 1) / 10));
			System.out.println("[BoardServlet - MIN NUMBER : " + indexno + "]");
			
			int[] num_of_page = new int[indexno];
			
			for (int i = 0; i < indexno; i++) {
				num_of_page[i] = i + 1 + 10 * ((pageno - 1) / 10);
			}
			
			request.setAttribute("num_of_page", num_of_page);
			request.setAttribute("bdtos", bdtos);
			request.setAttribute("pageno", pageno);

			dispatch(request, response, "board/main_board.jsp");
		}

		/*
		 * if(command.equals("boardlist")) { List<ChatBoardDto> list =
		 * dao.selectBoardlist(); request.setAttribute("list", list); dispatch(request,
		 * response, "LayoutBoard.jsp"); }
		 */ 
		else if (command.equals("board_detail")) {

			int bno = Integer.parseInt(request.getParameter("bno"));
			bdto = B_DAO.select_board(bno);
			System.out.println("[BoardServlet - 선택한 게시물 정보 : " + bdto + " ]");
			
			JSONObject obj = new JSONObject();

			//일반 게시글, 파일, 지도 처리 분류하기
			//BDTO에 조인 변수설정으로 처리하기 (미구현)
			if(bdto.getMno()!=0) {
				System.out.println("[BoardServlet - 첨부된 지도가 있는 게시물 ]");
				obj.put("mno", bdto.getMno());
				obj.put("latitude", bdto.getLatitude());
				obj.put("logitude", bdto.getLongitude());
			}
			
			if(bdto.getFno()!=0) {
				System.out.println("[BoardServlet - 첨부된 파일이 있는 게시물 ]");
				obj.put("fno", bdto.getFno());
				obj.put("ftitle", bdto.getFtitle());
				obj.put("fstream", bdto.getFstream());
			}
			
			//회원 정보 설정
			obj.put("userno", bdto.getUserno());
			obj.put("username", bdto.getUsername());
			obj.put("userurl", bdto.getUserurl());
			
			//게시글 설정
			obj.put("bno", bdto.getBno());
			obj.put("regdate", bdto.getRegdate().toString());
			obj.put("bcontent", bdto.getBcontent());
			obj.put("btitle", bdto.getBtitle());

			out.println(obj.toJSONString());

		} else if (command.equals("insert_board")) {
			
			pdto = (ProjectDto) session.getAttribute("pdto");
			
			String uploadPath = request.getSession().getServletContext().getRealPath("uploadFile"); // uploadPath: 절대경로

			int maxSize = 1024 * 1024 * 15; // 한번에 올릴 수 있는 파일 용량 : 15MB로 제한

			String file = ""; // 중복처리된 이름
			String originalName1 = ""; // 중복 처리전 실제 원본 이름
			long fileSize = 0;
			String fileType = "";

			String btitle = null;
			String bcontent = null;
			int userno = 0;

			MultipartRequest multi = null;

			try {
				multi = new MultipartRequest(request, uploadPath, maxSize, "utf-8", new DefaultFileRenamePolicy());

				userno = Integer.parseInt(URLDecoder.decode(multi.getParameter("userno").trim(), "UTF-8"));
				btitle = (URLDecoder.decode(multi.getParameter("btitle").trim(), "UTF-8"));
				bcontent = (URLDecoder.decode(multi.getParameter("bcontent").trim(), "UTF-8"));
				Enumeration files = multi.getFileNames();

				while (files.hasMoreElements()) {
					String file1 = (String) files.nextElement();
					originalName1 = multi.getOriginalFileName(file1);
					file = multi.getFilesystemName(file1);
					fileType = multi.getContentType(file1);
					File f = multi.getFile(file1);
					fileSize = f.length();
				}

				// 데이터베이스에 파일 저장
				int insert_file_res = 0;
				int select_file_res = 0;
				fdto = new FileDto();

				if (!(originalName1.equals(""))) {
					fdto.setFstream(uploadPath + "\\" + file);
					fdto.setFtitle(originalName1);

					insert_file_res = F_DAO.insert_file(fdto);
				}
				
				bdto = new BoardDto();
				bdto.setPno(pdto.getPno());
				bdto.setUserno(userno);
				bdto.setBtitle(btitle);
				bdto.setBcontent(bcontent);
				bdto.setFno(0);
				
				if (insert_file_res > 0) {
					select_file_res = F_DAO.select();
					bdto.setFno(select_file_res);
				}

				int insert_board_res = B_DAO.insert(bdto);

				JSONObject obj = new JSONObject();
				obj.put("insert_board_res", insert_board_res);

				out.println(obj.toJSONString());

			} catch (Exception e) {
				e.printStackTrace();
			}

		} else if (command.equals("delete_board_multi")) {
			String[] checked_list = request.getParameterValues("checkable_item");
			System.out.println("[BoardServlet - 삭제할 게시글 번호 목록 " + Arrays.toString(checked_list) + "]");
			
			int delete_board_res = B_DAO.delete(checked_list);

			if (delete_board_res > 0) {
				System.out.println("[BoardServlet - 삭제 성공 ]");
				jsResponse(response, "Board.ho?command=reflash_board_list", "삭제 성공");
			} else {
				System.out.println("[BoardServlet - 삭제 실패 ]");
				jsResponse(response, "Board.ho?command=reflash_board_list", "삭제 실패");
			}
		}
	}

	private void dispatch(HttpServletRequest request, HttpServletResponse response, String url)
			throws ServletException, IOException {

		RequestDispatcher dispatcher = request.getRequestDispatcher(url);
		dispatcher.forward(request, response);

	}

	public void jsResponse(HttpServletResponse response, String url, String msg) throws IOException {
		String tmp = "<script type='text/javascript'>" + "alert('" + msg + "');" + "location.href='" + url + "';"
				+ "</script>";
		out.print(tmp);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		doGet(request, response);
	}

}
