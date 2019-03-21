package com.nomwork.todo.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.mybatis.SqlMapConfig;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.todo.dto.TodoDto;
import com.nomwork.user.dto.UserDto;

public class TodoDao extends SqlMapConfig {

	private SqlSession session;
	// 각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	private TodoDto tddto;

	public List<TodoDto> select_todo_view_list(int projectno, String yyyyMM) {

		List<TodoDto> list = null;

		tddto = new TodoDto();
		tddto.setProjectno(projectno);
		tddto.setTododate(yyyyMM);

		session = getSqlSessionFactory().openSession(true);
		list = session.selectList("select_todo_view_list", tddto);

		return list;
	}

	public List<TodoDto> select(int projectno, String yyyyMMdd) {

		List<TodoDto> list = null;

		tddto = new TodoDto();
		tddto.setProjectno(projectno);
		tddto.setTododate(yyyyMMdd);

		session = getSqlSessionFactory().openSession(true);
		list = session.selectList("select_todo_list", tddto);

		return list;
	}

	public TodoDto select(String tododate) {

		session = getSqlSessionFactory().openSession(true);
		tddto = session.selectOne("select_todo", tododate);
		
		session.close();
		return tddto;
	}

	public int insert(TodoDto tddto) {

		SqlSession session = null;
		int result = 0;

		session = getSqlSessionFactory().openSession(true);
		result = session.insert("insert_todo", tddto);
		session.close();

		return result;
	}

	public int delete(String[] todono) {
		int cnt = 0;
		Map<String, String[]> map = new HashMap<String, String[]>();
		map.put("todonos", todono);

		try {
			session = getSqlSessionFactory().openSession(false);
			cnt = session.delete("delete_todo_multi", map);
			if (cnt == todono.length) {
				session.commit();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return cnt;
	}

}
