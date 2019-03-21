package com.nomwork.canvas.dao;

import org.apache.ibatis.session.SqlSession;

import com.nomwork.canvas.dto.CanvasDto;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.map.dto.MapDto;
import com.nomwork.mybatis.SqlMapConfig;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.user.dto.UserDto;

public class CanvasDao extends SqlMapConfig{
	
	private SqlSession session;
	
	//각DTO선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	private MapDto mdto;
	private CanvasDto cvdto;
	
	public int insert(CanvasDto cvto) {
		
		int result;
		
		session = getSqlSessionFactory().openSession(true);
		System.out.println(cvto.getCvurl());
		result = session.insert("insert_canvas", cvto);
		
		session.commit();
		session.close();
		return result;
	}
	
	public CanvasDto select(int cvno) {
		
		CanvasDto cvdto = null;
		
		session = getSqlSessionFactory().openSession(true);
		mdto = session.selectOne("selectone_canvas", cvno);
		
		session.commit();
		session.close();
		return cvdto;
	}
}


















