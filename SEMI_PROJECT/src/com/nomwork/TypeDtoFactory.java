package com.nomwork;

import com.nomwork.board.dto.BoardDto;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.file.dto.FileDto;
import com.nomwork.map.dto.MapDto;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.text.dto.TextDto;
import com.nomwork.user.dto.UserDto;

public class TypeDtoFactory extends DtoFactory{

	@Override
	public Dto createDto(String type) {
		
		Dto dto = null;
		
		switch (type) {
		
		case "tdto":
			dto = new TextDto();
			break;
			
		case "udto":
			dto = new UserDto();
			break;	
			
		case "pdto":
			dto = new ProjectDto();
			break;
			
		case "p_cdto":
			dto = new Project_CreateDto();
			break;
			
		case "cdto":
			dto = new ChannelDto();
			break;
			
		case "c_cdto":
			dto = new Channel_CreateDto();
			break;
			
		case "mdto":
			dto = new MapDto();
			break;
			
		case "fdto":
			dto = new FileDto();
			break;
			
		case "bdto":
			dto = new BoardDto();
			break;
			
		default:
			System.out.println("[TypeDtoFactory - 해당 TYPE은 존재하지 않는 DTO ]");
			return null;
		}
		
		return dto;
	}

}
