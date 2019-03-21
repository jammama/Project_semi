package com.nomwork.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

public class BoardDao extends SqlMapConfig {

	private SqlSession session;

	// 각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	private MapDto mdto;
	private BoardDto bdto;

	public List<BoardDto> select() {
		List<BoardDto> bdtos = null;

		session = getSqlSessionFactory().openSession(true);

		bdtos = session.selectList("selectBoardlist");

		return bdtos;
	}

	public List<BoardDto> select(int pno) {

		List<BoardDto> bdtos = null;

		session = getSqlSessionFactory().openSession(true);

		bdtos = session.selectList("select_board_list", pno);
		return bdtos;
	}

	// 게시판 게시물 10개
	public List<BoardDto> select(int pno, int pageno) {

		List<BoardDto> bdtos = null;

		session = getSqlSessionFactory().openSession(true);
		
		bdto = new BoardDto();
		bdto.setPno(pno);
		bdto.setBno(pageno);
		bdtos = session.selectList("select_board_list", bdto);
		return bdtos;
	}

	// 검색 후 게시물 10개씩
	public List<BoardDto> select(int pno, int pageno, String bcontent) {

		List<BoardDto> bdtos = null;

		session = getSqlSessionFactory().openSession(true);

		bdto = new BoardDto();
		bdto.setPno(pno);
		bdto.setBno(pageno);
		bdto.setBcontent(bcontent);

		bdtos = session.selectList("select_board_searched_list", bdto);
		return bdtos;
	}

	// 게시판 페이징
	public int select_board_count(int pno) {

		int count_all = 0;

		session = getSqlSessionFactory().openSession(true);
		count_all = session.selectOne("select_board_count", pno);

		return count_all;

	}

	// 검색 후 페이징
	public int select_board_count(int pno, String bcontent) {

		int count_all = 0;

		session = getSqlSessionFactory().openSession(true);

		bdto.setPno(pno);
		bdto.setBcontent(bcontent);

		count_all = session.selectOne("select_board_count_searching", bdto);

		return count_all;

	}

	public BoardDto select_board(int bno) {

		session = getSqlSessionFactory().openSession(true);
		bdto = session.selectOne("select_board", bno);

		return bdto;
	}

	public int insert(BoardDto dto) {

		int result = 0;

		session = getSqlSessionFactory().openSession(true);
		result = session.insert("insert_board", dto);
		return result;

	}

	public int delete(String[] bno) {
		int count = 0;

		Map<String, String[]> map = new HashMap<String, String[]>();
		map.put("bnos", bno);

		try {
			session = getSqlSessionFactory().openSession(true);
			count = session.delete("delete_board_multi", map);

			if (count == bno.length) {
				session.commit();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return count;
	}

}
