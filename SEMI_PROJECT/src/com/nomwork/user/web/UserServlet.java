package com.nomwork.user.web;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Base64;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nomwork.NomworkInit;
import com.nomwork.channel.dao.ChannelDao;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.project.dao.ProjectDao;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.user.dao.UserDao;
import com.nomwork.user.dto.UserDto;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet implements NomworkInit{
	private static final long serialVersionUID = 1L;

	// 각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	//
	private HttpSession session;
	private PrintWriter out;

	public UserServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		String command = request.getParameter("command");
		System.out.println("[UserServlet - " + command + "]");

		// PrintWriter 객체 생성
		out = response.getWriter();
		session = request.getSession();

		//
		if (command.equals("login")) {
			//
			List<ProjectDto> pdtos = null;

			// 로그인시 필요한 파라미터 전해받기
			String useremail = request.getParameter("useremail");
			String userpw = request.getParameter("userpw");

			// 받아온 로그인 정보로 DTO 객체 생성
			udto = new UserDto();
			udto.setUseremail(useremail);
			udto.setUserpw(userpw);

			// 로그인 시도
			udto = U_DAO.login(udto);
			
			//로그인 실패 시
			if(udto == null) {
				out.print("<script type='text/javascript'>" + "alert('회원정보가 일치하지 않거나 없습니다.');" + "location.href='index.jsp';"
						+ "</script>");
			}
			else { // 로그인 성공시

			// 로그인에 성공한 유저정보를 토대로 프로젝트 목록 조회
			pdtos = P_DAO.select_project_list(udto);
			System.out.println("[UserServlet - 로그인한 유저의 프로젝트 목록 조회" + pdtos + "]");
			
			if (pdtos.size() == 0) {	// 참여하고 있는 프로젝트가 없는 경우
				// 세션에 로그인 정보 및 프로젝트 목록 등록
				session.setAttribute("udto", udto);
				session.setAttribute("pdtos", pdtos);
				dispatch(request, response, "project/index_project.jsp");
			} // 참여하고 있는 프로젝트가 있는 경우
			else {
				// 세션에 로그인 정보 및 프로젝트 목록 등록
				session.setAttribute("udto", udto);
				session.setAttribute("pdtos", pdtos);
				//유저가 참여하고 있는 프로젝트 중 프로젝트번호가 가장 작은 프로젝트로 이동하기 위한 작업
				out.print("<script type='text/javascript'>" + "location.href='Project.ho?command=project_detail';"
						+ "</script>");
				}
			}

		} // 회원가입시 아이디 중복 확인
		else if (command.equals("check_email_overlaped")) {

			String useremail = request.getParameter("useremail");
			int check_user_email_res = U_DAO.check_email_overlaped(useremail);

			out.print(check_user_email_res);

		} // 회원가입 정보 입력 후 인증 메일 전송
		else if (command.equals("regist_user")) {

			udto = new UserDto();
			udto.setUseremail(request.getParameter("useremail"));
			udto.setUserpw(request.getParameter("userpw"));
			udto.setUsername(request.getParameter("username"));
			udto.setUsergender(request.getParameter("usergender"));

			int appro = new Random().nextInt(9000) + 1000;

			request.setAttribute("appro", appro);
			request.setAttribute("udto", udto);
			dispatch(request, response, "user/confirm_user_email.jsp");

			// 인증 메일 보내기
			// 메일 입력값 받음
			String from = "boromir0105@naver.com";
			String to = udto.getUseremail();
			String subject = "Nomwork 가입을 승인해주세요";
			String content = "<html>" + "<div style=\"width: 600px; text-align: center; margin: auto; \">"
					+ "<div style=\"width: 600px; height: 60px; background-color: #494949; display: table;\">"
					+ "<img style=\"width: 200px; margin-top: 2px; float: left; margin-left: 5px;\" src=\"http://ai.esmplus.com/maron8050/%EC%9E%90%EB%B0%94%20%EC%9D%B4%EB%AF%B8%EC%A7%80%20%ED%98%B8%EC%8A%A4%ED%8C%85/Nomwork_logo.png\">"
					+ "</div>\r\n"
					+ "<p style=\"text-align: center; font-size: 14px; margin-bottom: 30px; margin-top: 20px; color: #393939;\">\r\n"
					+ "No More Work ! 안녕하세요 " + request.getParameter("username") + "님<br/>\r\n"
					+ "최고의 협업툴인 저희 서비스를 이용해주셔서 감사합니다. <br/>\r\n" + "아래 코드 4자리를 인증창에 써주시면 <br/>\r\n" + "가입이 완료됩니다 :)\r\n"
					+ "</p>"
					+ "<span style=\"font-size: 40px; color: #007bff; padding: 10px; padding-left: 15px; border: 1px solid #393939; border-radius: 1rem; letter-spacing: 5px;\">"
					+ appro + "</span>\r\n"
					+ "<img style=\"display: block; width: 600px; margin-top: 30px;\" src=\"https://a.slack-edge.com/e67b/img/email/ill_invite@2x.png\">\r\n"
					+ "</html>";

			Properties p = new Properties(); // 정보를 담을 객체

			p.put("mail.smtp.host", "smtp.naver.com"); // 네이버 SMTP
			// SMTP 서버에 접속하기 위한 정보들
			p.put("mail.smtp.port", "465");
			p.put("mail.smtp.starttls.enable", "true");
			p.put("mail.smtp.auth", "true");
			p.put("mail.smtp.debug", "true");
			p.put("mail.smtp.socketFactory.port", "465");
			p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			p.put("mail.smtp.socketFactory.fallback", "false");

			try {
				Authenticator auth = new SMTPAuthenticatior();
				Session ses = Session.getInstance(p, auth);

				ses.setDebug(true);

				MimeMessage msg = new MimeMessage(ses); // 메일의 내용을 담을 객체
				msg.setSubject(subject); // 제목

				Address fromAddr = new InternetAddress(from);
				msg.setFrom(fromAddr); // 보내는 사람

				Address toAddr = new InternetAddress(to);
				msg.addRecipient(Message.RecipientType.TO, toAddr); // 받는 사람

				msg.setContent(content, "text/html;charset=UTF-8"); // 내용과 인코딩

				Transport.send(msg); // 전송
			} catch (Exception e) {
				e.printStackTrace();
				// 오류 발생시 뒤로 돌아가도록
			}
			// 성공 시
			System.out.println("[UserServlet - 메일 인증 성공]");

		} // 메일 인증 후 회원가입 완료
		else if (command.equals("insert_user")) {

			udto = new UserDto();
			
			//구글, 카카오를 통한 회원가입을 대비한 USERNO, USERURL
			if(request.getParameter("userno") != null) {
				udto.setUserno(Double.valueOf(request.getParameter("userno")));
				}
			
			if(request.getParameter("userurl") != null) {
				udto.setuserurl(request.getParameter("userurl"));
			}
			
			udto.setUseremail(request.getParameter("useremail"));
			udto.setUserpw(request.getParameter("userpw"));
			udto.setUsername(request.getParameter("username"));
			udto.setUsergender(request.getParameter("usergender"));
			
			System.out.println("[UserServlet - 데이터베이스에 저장하려는 유저 정보 : " + udto + "]");
			
			int insert_user_res = U_DAO.insert(udto);

			if (insert_user_res > 0) { // 유저 정보 테이블 생성 성공시
				List<ProjectDto> pdtos = null;
				udto = U_DAO.select(udto.getUseremail());
				
				pdtos = pdtos = P_DAO.select_project_list(udto);
				
				session.setAttribute("udto", udto);
				session.setAttribute("pdtos", pdtos);
				dispatch(request, response, "project/index_project.jsp");
			} else { // 유저 정보 테이블 생성 실패시
				
				jsResponse(response, "index.jsp", "회원가입 실패");
			}

		} // 이메일을 통한 회원정보 조회
		else if (command.equals("search_user_by_email")) {

			String useremail = request.getParameter("useremail");
			//
			udto = U_DAO.select(useremail);
			//
			request.setAttribute("udto", udto);
			dispatch(request, response, "project/search_user_by_email.jsp");

		} // 비밀번호 찾기 기능
		else if (command.equals("search_userpw_by_email")) {
			String userpw = null;
			String useremail = request.getParameter("useremail");
			udto = U_DAO.select(useremail);
			
			// 잘못된 이메일을 입력했을 경우
			if(udto == null) {
				
				jsResponse(response, "user/forgot_password.jsp", "해당 이메일의 회원정보가 존재하지 않습니다.");

			} else {
				// 인증 메일 보내기
				// 메일 입력값 받음
				String from = "boromir0105@naver.com";
				String to = useremail;
				String subject = "Nomwork 비밀번호 찾기";
				String content = "<html>" + "<div style=\"width: 600px; text-align: center; margin: auto; \">"
						+ "<div style=\"width: 600px; height: 60px; background-color: #494949; display: table;\">"
						+ "<img style=\"width: 200px; margin-top: 2px; float: left; margin-left: 5px;\" src=\"http://ai.esmplus.com/maron8050/%EC%9E%90%EB%B0%94%20%EC%9D%B4%EB%AF%B8%EC%A7%80%20%ED%98%B8%EC%8A%A4%ED%8C%85/Nomwork_logo.png\">"
						+ "</div>\r\n"
						+ "<p style=\"text-align: center; font-size: 14px; margin-bottom: 30px; margin-top: 20px; color: #393939;\">\r\n"
						+ "고객님이 요청하신 비밀번호를 안내해드리겠습니다.<br/>\r\n" + "최고의 협업툴인 저희 서비스를 이용해주셔서 감사합니다. <br/>\r\n" + "</p>"
						+ "<span style=\"font-size: 40px; color: #007bff; padding: 10px; padding-left: 15px; border: 1px solid #393939; border-radius: 1rem; letter-spacing: 5px;\">"
						+ userpw + "</span>\r\n"
						+ "<img style=\"display: block; width: 600px; margin-top: 30px;\" src=\"https://a.slack-edge.com/e67b/img/email/ill_invite@2x.png\">\r\n"
						+ "</html>";

				Properties p = new Properties(); // 정보를 담을 객체

				p.put("mail.smtp.host", "smtp.naver.com"); // 네이버 SMTP
				// SMTP 서버에 접속하기 위한 정보들
				p.put("mail.smtp.port", "465");
				p.put("mail.smtp.starttls.enable", "true");
				p.put("mail.smtp.auth", "true");
				p.put("mail.smtp.debug", "true");
				p.put("mail.smtp.socketFactory.port", "465");
				p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
				p.put("mail.smtp.socketFactory.fallback", "false");

				try {
					Authenticator auth = new SMTPAuthenticatior();
					Session ses = Session.getInstance(p, auth);

					ses.setDebug(true);

					MimeMessage msg = new MimeMessage(ses); // 메일의 내용을 담을 객체
					msg.setSubject(subject); // 제목

					Address fromAddr = new InternetAddress(from);
					msg.setFrom(fromAddr); // 보내는 사람

					Address toAddr = new InternetAddress(to);
					msg.addRecipient(Message.RecipientType.TO, toAddr); // 받는 사람

					msg.setContent(content, "text/html;charset=UTF-8"); // 내용과 인코딩

					Transport.send(msg); // 전송
				} catch (Exception e) {
					e.printStackTrace();
					// 오류 발생시 뒤로 돌아가도록
				}
				// 성공 시
				jsResponse(response, "index.jsp", "비밀번호 이메일이 보내졌습니다.");
			}
		} // API를 통한 회원가입
		else if (command.equals("regist_user_by_api")) {

			List<ProjectDto> pdtos = null;

			Double userno = Double.valueOf(request.getParameter("userno"));
			String useremail = request.getParameter("useremail");
			String username = request.getParameter("username");
			String userurl = request.getParameter("userurl");

			//API를 통해 넘어온 고유번호로 회원가입 여부 확인
			udto = U_DAO.login_by_api(userno);
			System.out.println(udto + "dddd");
			if (udto == null) {// 최초 로그인 시, 회원가입하고 로그인
				
				System.out.println("[UserServlet - 최초 API 로그인 시도일 경우]");  
				System.out.println("[UserServlet - API를 통해 전달받은 유저 정보 : ]");
				System.out.println("[UserServlet - USERNO : " + userno +" USEREMAIL : " + useremail + " USERNAME : " + username + " USERURL : " + userurl + " ]");
				
				//API를 통해 전해 받은 유저 정보로 UDTO 객체 생성
				udto = new UserDto(userno, useremail, username, userurl);
				//SESSION에 객체 저장
				session.setAttribute("udto", udto);
				dispatch(request, response, "user/regist_user_by_api.jsp");

			}else if(udto.getUserenabled().equals("N")) {
				System.out.println("[UserServlet - API로 회원가입 후 탈퇴한 경우]");
				jsResponse(response, "index.jsp", "해당 계정은 탈퇴 된 계정입니다.");
			} // 최초 API로그인이 아닐 때
			else {
				System.out.println("[UserServlet - 최초 API 로그인 시도가 아닐 경우]");

				// 로그인 정보로 프로젝트 목록 조회
				pdtos = P_DAO.select_project_list(udto);

				session.setAttribute("udto", udto);
				session.setAttribute("pdtos", pdtos);
				dispatch(request, response, "Project.ho?command=project_detail");
			}
			
		} //회원 정보 수정
		else if(command.equals("update_userinfo")) {
			Double userno = Double.valueOf(request.getParameter("userno"));
			String useremail = request.getParameter("useremail");
			String userpw = request.getParameter("userpw");
			String username = request.getParameter("username");
			String usergender = request.getParameter("usergender");
			String userurl = request.getParameter("userurl");
			
			udto = new UserDto(userno, useremail, userpw, username, usergender, userurl);
			
			System.out.println(udto);
			int res = U_DAO.update(udto);
			
			session.setAttribute("udto", udto);
			dispatch(request, response, "Project.ho?command=project_detail");
		} //회원 정보 이메일 수정 인증
		else if(command.equals("change_user_email")) {
			String useremail = request.getParameter("useremail");
			int chk_num = new Random().nextInt(9000) + 1000;

			// 인증 메일 보내기
			// 메일 입력값 받음
			String from = "boromir0105@naver.com";
			String to = useremail;
			String subject = "Nomwork 이메일 변경을 승인해주세요";
			String content = "<html>" + "<div style=\"width: 600px; text-align: center; margin: auto; \">"
					+ "<div style=\"width: 600px; height: 60px; background-color: #494949; display: table;\">"
					+ "<img style=\"width: 200px; margin-top: 2px; float: left; margin-left: 5px;\" src=\"http://ai.esmplus.com/maron8050/%EC%9E%90%EB%B0%94%20%EC%9D%B4%EB%AF%B8%EC%A7%80%20%ED%98%B8%EC%8A%A4%ED%8C%85/Nomwork_logo.png\">"
					+ "</div>\r\n"
					+ "<p style=\"text-align: center; font-size: 14px; margin-bottom: 30px; margin-top: 20px; color: #393939;\">\r\n"
					+ "No More Work ! 안녕하세요! \r\n"
					+ "최고의 협업툴인 저희 서비스를 이용해주셔서 감사합니다. <br/>\r\n" + "아래 코드 4자리를 인증창에 써주시면 <br/>\r\n" + "이메일 수정이 완료됩니다 :)\r\n"
					+ "</p>"
					+ "<span style=\"font-size: 40px; color: #007bff; padding: 10px; padding-left: 15px; border: 1px solid #393939; border-radius: 1rem; letter-spacing: 5px;\">"
					+ chk_num + "</span>\r\n"
					+ "<img style=\"display: block; width: 600px; margin-top: 30px;\" src=\"https://a.slack-edge.com/e67b/img/email/ill_invite@2x.png\">\r\n"
					+ "</html>";

			Properties p = new Properties(); // 정보를 담을 객체

			p.put("mail.smtp.host", "smtp.naver.com"); // 네이버 SMTP
			// SMTP 서버에 접속하기 위한 정보들
			p.put("mail.smtp.port", "465");
			p.put("mail.smtp.starttls.enable", "true");
			p.put("mail.smtp.auth", "true");
			p.put("mail.smtp.debug", "true");
			p.put("mail.smtp.socketFactory.port", "465");
			p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			p.put("mail.smtp.socketFactory.fallback", "false");

			try {
				Authenticator auth = new SMTPAuthenticatior();
				Session ses = Session.getInstance(p, auth);

				ses.setDebug(true);

				MimeMessage msg = new MimeMessage(ses); // 메일의 내용을 담을 객체
				msg.setSubject(subject); // 제목

				Address fromAddr = new InternetAddress(from);
				msg.setFrom(fromAddr); // 보내는 사람

				Address toAddr = new InternetAddress(to);
				msg.addRecipient(Message.RecipientType.TO, toAddr); // 받는 사람

				msg.setContent(content, "text/html;charset=UTF-8"); // 내용과 인코딩

				Transport.send(msg); // 전송
			} catch (Exception e) {
				e.printStackTrace();
				// 오류 발생시 뒤로 돌아가도록
			}
			// 성공 시
			System.out.println("[UserServlet - 수정 이메일 전송 성공]");
			out.print(chk_num);
			
		}//회원 탈퇴
		else if(command.equals("drop_user")) {
			Double userno = Double.valueOf((request.getParameter("userno")));
			System.out.println("[UserServlet - 탈퇴할 유저 번호 : " + userno + "]");
			int drop_user_res = U_DAO.update(userno);
			
			if(drop_user_res == 1) {
				System.out.println("회원탈퇴 성공");
				jsResponse(response, "index.jsp", "회원탈퇴 성공");
				
			}else {
				System.out.println("회원탈퇴 실패");
				jsResponse(response, "user/userinfo.jsp", "회원탈퇴 실패");
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		PrintWriter out = response.getWriter(); 
	    
	    StringBuffer jb = new StringBuffer(); 
	    String line = null; 
	    BufferedReader reader = request.getReader(); 
	    
	    String command = request.getParameter("command");
	    System.out.println("[UserServlet_post - " + command + "]");
	    
	    if(command.equals("profile_save_server")) {
	    	System.out.println("들어오냐?");
	    	while ((line = reader.readLine()) != null) 
	   	     jb.append(line); 
	   	    
	   	    String img64 = jb.toString(); 
	   	    //base64로 잘 변환됬나 확인하기
	   	    if(img64 != null && img64.startsWith("data:image/png;base64,")){ 
	   	     //제거 Content-type declaration 
	   	     img64 = img64.substring(img64.indexOf(',') + 1);    
	   	    }else{ 
	   	     response.setStatus(403); 
	   	     out.print("Formato immagine non corretto!"); 
	   	     return; 
	   	    } 
	   	    try{ 
	   	     InputStream stream = new ByteArrayInputStream(Base64.getDecoder().decode(img64.getBytes())); 
	   	     BufferedImage bfi = ImageIO.read(stream); 
	   	     String path = getServletConfig().getServletContext().getRealPath("resources/image/profile/"); 
	   	     
	   	     String userno = request.getParameter("userno");
	   	     System.out.println("프로필 사진 저장 계정번호 : " + userno);
	   	     File outputfile = new File(path, userno+".png"); 
	   	     outputfile.createNewFile(); 
	   	     
	   	     ImageIO.write(bfi , "png", outputfile); 
	   	     bfi.flush(); 
	   	     response.setStatus(200); 
	   	    }catch(IOException e){ 
	   	     e.printStackTrace(); 
	   	     response.setStatus(500); 
	   	    } 
	    }
	}

	private void dispatch(HttpServletRequest request, HttpServletResponse response, String URL)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher(URL);
		dispatcher.forward(request, response);
	}

	private void jsResponse(HttpServletResponse response, String url, String msg) throws IOException {
		String tmp = "<script type='text/javascript'>" + "alert('" + msg + "');" + "location.href='" + url + "';"
				+ "</script>";
		PrintWriter out = response.getWriter();
		out.print(tmp);
	}

}
