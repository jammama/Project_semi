package com.nomwork.text.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.map.dto.MapDto;
import com.nomwork.mybatis.SqlMapConfig;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.text.dto.TextDto;
import com.nomwork.user.dto.UserDto;

public class TextDao extends SqlMapConfig {
	
	private SqlSession session;
	//각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	private MapDto mdto;
	
	public int insert(TextDto tdto) {

		int result;

		session = getSqlSessionFactory().openSession(true);
		result = session.insert("insert_text", tdto);

		session.commit();
		session.close();
		return result;
	}
	
	public int insert_text_answer(TextDto tdto) {

		int result;

		session = getSqlSessionFactory().openSession(true);
		result = session.insert("insert_text_answer", tdto);

		session.commit();
		session.close();
		return result;
	}
	
	public List<TextDto> select(TextDto tdto) {
		
		List<TextDto> tdtos = null;
		
		session = getSqlSessionFactory().openSession(true);
		tdtos = session.selectList("select_text_list", tdto);
		
		session.close();
		return tdtos;
	}
	
	public List<TextDto> select(int tno) {
		
		List<TextDto> tdtos = null;
		
		session = getSqlSessionFactory().openSession(true);
		tdtos = session.selectList("select_text_answer",tno);
		
		return tdtos;
	}
	
	public int select() {
		
		int last_tno = 0;
		
		session = getSqlSessionFactory().openSession(true);
		last_tno = session.selectOne("select_last_text");
		
		return last_tno;
	}
		public int insert_chattoboard(int textno) {
		
		int result=0;
		session = getSqlSessionFactory().openSession(true);
		result = session.insert("chattoboard", textno);
		
		return result;
	}

}
