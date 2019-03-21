package com.nomwork;

import com.nomwork.board.dao.BoardDao;
import com.nomwork.board.dto.BoardDto;
import com.nomwork.canvas.dao.CanvasDao;
import com.nomwork.channel.dao.ChannelDao;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.file.dao.FileDao;
import com.nomwork.file.dto.FileDto;
import com.nomwork.map.dao.MapDao;
import com.nomwork.map.dto.MapDto;
import com.nomwork.project.dao.ProjectDao;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.text.dao.TextDao;
import com.nomwork.text.dto.TextDto;
import com.nomwork.todo.dao.TodoDao;
import com.nomwork.user.dao.UserDao;
import com.nomwork.user.dto.UserDto;

public interface NomworkInit {
	
	// 각 DAO 객체 공유
	public static final ProjectDao P_DAO = new ProjectDao();
	public static final UserDao U_DAO = new UserDao();
	public static final ChannelDao C_DAO = new ChannelDao();
	public static final BoardDao B_DAO = new BoardDao();
	public static final FileDao F_DAO = new FileDao();
	public static final TextDao T_DAO = new TextDao();
	public static final MapDao M_DAO = new MapDao();
	public static final TodoDao TD_DAO = new TodoDao();
	public static final CanvasDao CV_DAO = new CanvasDao();
	
	public static final TypeDtoFactory DTO_FACTORY = new TypeDtoFactory();

}
