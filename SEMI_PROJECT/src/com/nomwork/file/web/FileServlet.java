package com.nomwork.file.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.Map;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

import com.nomwork.NomworkInit;
import com.nomwork.board.dao.BoardDao;
import com.nomwork.board.dto.BoardDto;
import com.nomwork.channel.dao.ChannelDao;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.file.dao.FileDao;
import com.nomwork.file.dto.FileDto;
import com.nomwork.project.dao.ProjectDao;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.user.dao.UserDao;
import com.nomwork.user.dto.UserDto;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@WebServlet("/FileServlet")
public class FileServlet extends HttpServlet implements NomworkInit {
	private static final long serialVersionUID = 1L;
	
	// 각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	private BoardDto bdto;
	private FileDto fdto;

	//
	private HttpSession session;
	private PrintWriter out;

	public FileServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		String command = request.getParameter("command");
		System.out.println("[FileServlet - " + command + "]");
		//
		session = request.getSession();
		out = response.getWriter();
		
		if (command.equals("file_download")) {
	String ftitle = (request.getParameter("ftitle")).trim();
			
			System.out.println(ftitle);

		    String savePath = "uploadFile"; 
		    String sDownPath = request.getSession().getServletContext().getRealPath(savePath);
		     
		    System.out.println(sDownPath);
		    System.out.println("filetitle : " + ftitle);
		     
		    String sFilePath = sDownPath + "/" + ftitle;
		    System.out.println("sFilePath : " + sFilePath);

		    File outputFile = new File(sFilePath);
		    byte[] temp = new byte[1024*1024*15]; // 15MB
		    char[] tmp = new char[1024*1024*15]; 
		     
		    FileInputStream in = new FileInputStream(outputFile);
		     
		    String sMimeType = getServletContext().getMimeType(sFilePath);
		    System.out.println(sMimeType);

		    if ( sMimeType == null ){
		        sMimeType = "application.octec-stream"; 
		    }

		    response.setContentType(sMimeType); 

		    String sEncoding = new String(ftitle.getBytes("euc-kr"),"8859_1");

		    String AA = "Content-Disposition";
		    String BB = "attachment;filename="+sEncoding;
		    response.setHeader(AA,BB);

		    int numRead = 0;

		    while((numRead = in.read(temp,0,temp.length)) != -1){
		        out.write(tmp, 0, numRead);
		    	//out2.write(temp,0,numRead);
		    }

		    out.flush();
		    out.close();
		    in.close();	
		} // 파일 업로드
		else if(command.equals("file_upload")) {
			
			String uploadPath = null;
			String file = null;
			String originalName1 = null;
			
			uploadPath = request.getSession().getServletContext().getRealPath("uploadFile"); // uploadPath: 절대경로
			
			int maxSize = 1024 * 1024 * 15;
			long fileSize = 0;
			String fileType = "";
			     
			MultipartRequest multi = null;
			
			try{
				multi = new MultipartRequest(request,uploadPath,maxSize,"utf-8",new DefaultFileRenamePolicy());

		        Enumeration files = multi.getFileNames();
				
				while(files.hasMoreElements()){
		            String file1 = (String)files.nextElement(); 
		            originalName1 = multi.getOriginalFileName(file1);
		            file = multi.getFilesystemName(file1);
		            fileType = multi.getContentType(file1);
		            File f = multi.getFile(file1);
		            fileSize = f.length();
				}
			} catch(Exception e){
				e.printStackTrace();
			}
		
			JSONObject obj = new JSONObject();
			obj.put("filestream", uploadPath+"/"+file);
			obj.put("filetitle", originalName1);
			
			Set<Map.Entry<Integer, String>> mySet = obj.entrySet();
			String[] objs = null;
			for (Map.Entry<Integer,String> myEntry : mySet) {
				objs = myEntry.getValue().split("\n");
				for(int i=0;i<objs.length;i++) {
					out.println(objs[i]);
				}
			}
		} // 데이터베이스에 파일 입력
		else if(command.equals("insert_file")) {
			
			int insert_file_res = 0;
			
			String uploadPath = null;
			String file = null;
			String originalName1 = null;
			
			fdto = new FileDto();
			
			fdto.setFtitle(originalName1);
			fdto.setFstream(uploadPath+"\\"+file);
			
			insert_file_res = F_DAO.insert_file(fdto);
			
			if (insert_file_res > 0) {
				dispatch(request, response, "project/main_project.jsp");
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}
	
	private void dispatch(HttpServletRequest request, HttpServletResponse response, String url)
			throws ServletException, IOException {

		RequestDispatcher dispatcher = request.getRequestDispatcher(url);
		dispatcher.forward(request, response);

	}

}
