package com.nomwork.channel.dao;

import java.util.List;

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

public class ChannelDao extends SqlMapConfig{
	
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
	
	public List<ChannelDto> select(Channel_CreateDto c_cdto) {
		//
		session = getSqlSessionFactory().openSession(true);
		List<ChannelDto> cdtos = session.selectList("select_channel_list", c_cdto);
		//
		session.commit();
		session.close();
		return cdtos;
		
	}
	
	public ChannelDto select(int cno) {
		//
		session = getSqlSessionFactory().openSession(true);
		cdto = session.selectOne("select_channel", cno);
		
		session.close();
		return cdto;
	}
	
	public ChannelDto select_channel_main(int pno) {
		
		session = getSqlSessionFactory().openSession(true);
		cdto = session.selectOne("select_channel_main", pno);
		
		session.close();
		return cdto;
	}
	
	//채널 테이블 생성
	public int insert(ChannelDto cdto) {
		
		int result;
		//
		session = getSqlSessionFactory().openSession(true);
		result = session.insert("insert_channel", cdto);
		//
		session.commit();
		session.close();
		return result;
	}
	
	public int insert(Channel_CreateDto c_cdto) {
		
		//if(c_cdto.getCno()==null)일 경우를 생각해볼것.
		int result;
		//
		session = getSqlSessionFactory().openSession(true);
		result = session.insert("insert_channel_create", c_cdto);
		//
		session.commit();
		session.close();
		return result;
		
	}

}
