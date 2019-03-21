package com.nomwork.file.dao;

import org.apache.ibatis.session.SqlSession;

import com.nomwork.board.dto.BoardDto;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.file.dto.FileDto;
import com.nomwork.map.dto.MapDto;
import com.nomwork.mybatis.SqlMapConfig;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.user.dto.UserDto;

public class FileDao extends SqlMapConfig{

private SqlSession session;
	
	//각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	private MapDto mdto;
	private BoardDto bdto;
	private FileDto fdto;
	
	public int insert_file(FileDto fdto) {
		int result = 0;
		
		session = getSqlSessionFactory().openSession(true);
		result = session.insert("insert_file", fdto);
		
		return result;
	}
	
	public int select() {
		int result = 0;
		
		session = getSqlSessionFactory().openSession(true);
		result = session.selectOne("select_recent_file");
		
		return result;
	}
	
	public FileDto select(int fno) {
		
		session = getSqlSessionFactory().openSession(true);
		fdto = session.selectOne("select_file", fno);
		
		return fdto;
	}
	
}
