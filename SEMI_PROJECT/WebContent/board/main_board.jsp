<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- 주요 클래스 IMPORT -->
<%@ page import="java.util.List"%>
<%@ page import="com.nomwork.user.dto.*"%>
<%@ page import="com.nomwork.project.dao.*"%>
<%@ page import="com.nomwork.project.dto.*"%>
<%@ page import="com.nomwork.channel.dto.*"%>
<%@ page import="com.nomwork.map.dto.*"%>
<%@ page import="com.nomwork.map.dao.*"%>
<%@ page import="com.nomwork.text.dto.*"%>
<%@ page import="com.nomwork.board.dto.*"%>

<!-- TAGLIB 정의 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!-- 웹소켓을 이용한 채팅 관련 스크립트 -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script type="application/javascript" src="resources/js/websocket_setting.js"></script>

<!-- 게시판 주요 스크립트 로드 -->
<script type="application/javascript" src="resources/js/board_setting.js"></script>	

<!-- 주요 클래스 객체 생성 -->
<%
	UserDto udto = (UserDto) session.getAttribute("udto");
	ProjectDto pdto = (ProjectDto) session.getAttribute("pdto");
	ChannelDto cdto = (ChannelDto) session.getAttribute("cdto");
	List<UserDto> udtos = (List<UserDto>) session.getAttribute("udtos");
	List<ChannelDto> cdtos = (List<ChannelDto>) session.getAttribute("cdtos");
	List<ProjectDto> pdtos = (List<ProjectDto>) session.getAttribute("pdtos");
	List<TextDto> tdtos = (List<TextDto>) session.getAttribute("tdtos");
	
	int pageno = Integer.parseInt(request.getAttribute("pageno")+"");
	List<BoardDto> bdtos = (List<BoardDto>) request.getAttribute("bdtos");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="resources/css/ChatTitle.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	$(function() {
	    
	    $("#search").click(function(){
	    	var bcontent = $("#search_input").val();
	    	var url = "Board.ho?command=search_board_by_content&pno="+<%=pdto.getPno()%>+"&pageno=1&bcontent="+bcontent;
	    	
	    	if (bcontent != "" && bcontent != null) {
	    	window.location.href = url;
	    	return false;
	    	} else {
	    		alert("검색할 내용을 입력해 주십시오.");
	    	}
	    });
	});

</script>

</head>

<body>
   
   
    <!-- sidebar:top -->
    <nav class="topsidebar">
    
    	<!-- 로고 이미지 및 링크 설정 -->
    	<div class=logo><img onclick="location.href='Project.ho?command=to_main_project'" src="resources/image/main/Nomwork_logo.png"></div>

		<!-- 해당 유저의 프로젝트 목록 표시 -->
		<div class="topside-1">
			<select class="select" onchange="javascript:handleSelect(this)">

				<%
					if (pdtos != null) {

						for (int i = 0; i < pdtos.size(); i++) {
							if(pdto.getPno()==pdtos.get(i).getPno()) {
%>
				<option value="<%=pdtos.get(i).getPno()%>" selected="selected"><%=pdtos.get(i).getPname()%></option>


<%								
							} else {
				%>
				<option value="<%=pdtos.get(i).getPno()%>"><%=pdtos.get(i).getPname()%></option>
				
				<%
							}
						}
					}
				%>
			</select>
		</div>
			<!-- SELECT 이벤트 설정 -->
			<script type="text/javascript">
			
				function handleSelect(pno) {
			window.location = "Project.ho?command=project_detail&pno=" + pno.value
			}
			</script>
   		<div class="topside-2"></div>
   		
		<!-- 프로필 관련 -->
		
		<!-- 프로필 이미지 가져오기 -->
		<!-- 프로필 이미지 가져오기 -->
		<div class="topside-3">
   			<div class="topprofile"><img src="<%=udto.getuserurl()%>"></div>
			<div class="top-dropmenu" style="display: none;">
           		<div onclick="location.href='user/update_user_profile.jsp?userno=<%=udto.getUserno()%>&useremail=<%=udto.getUseremail()%>&userpw=<%=udto.getUserpw()%>&username=<%=udto.getUsername()%>&usergender=<%=udto.getUsergender()%>&userurl=<%=udto.getuserurl()%>'">회원정보 수정</div>
				<div onclick="location.href='index.jsp'">로그아웃</div>
			</div>
		</div>
		<!-- 프로필 이름 가져오기 -->
		<div class="topside-4"><%=udto.getUsername()%>님</div>
		
		<!-- 미구현 -->
		<div class="topside-5"><img src=""></div>
		<div class="topside-6"><img src=""></div>
		<div class="topside-7"><img src=""></div>
    </nav>
    <!-- /sidebar:top -->
	<!-- sidebar:left -->
	<nav class="leftsidebar">
	
		<!-- 프로젝트 이름 가져오기 -->
		<div class="leftside-project"><%=pdto.getPname()%></div>
		<hr>
		<div class="myprofile">
			<div class="leftside-1">
				<div></div>
			</div>
			
			<!-- 프로필 이름 가져오기 -->
			<div class="leftside-2">
				<div><%=udto.getUsername()%> 님</div>
				<div><%=udto.getUseremail()%></div>
			</div>
		</div>
		
		<!-- 공유 캘린더 이미지 및 링크 설정 -->
		<div class="leftside-share" onclick="location.href='Todo.ho?command=Todo&projectno=<%=pdto.getPno() %>'">
			<img src="resources/image/main/board.png">
			<span>공유캘린더</span>
		</div>
		
		<!-- 공유 게시판 이미지 및 링크 설정 -->
		<div class="leftside-share" onclick="location.href='Board.ho?command=reflash_board_list'">
			<img src="resources/image/main/cal.png">
			<span>공유게시판</span>
		</div>
		<br>

		<div class="labels">
			<div>채널
				<div id="plus" onclick="location.href='Channel.ho?command=to_add_channel'"></div>
			</div>
		</div>
		<div class="channel_wrapper">
			<ul class="channel">
				<%
					if (cdtos != null) {

						for (int i = 0; i < cdtos.size(); i++) {
				%>
				<li><a href="Channel.ho?command=to_other_channel&cno=<%=cdtos.get(i).getCno()%>"> <%=cdtos.get(i).getCname()%></a></li>

				<%
						}
					}
				%>
			</ul>
		</div>
		<br>
		<div class="labels">
			<div>멤버
				<div id="plus" onclick="location.href='Project.ho?command=to_project_add_user'"></div>
			</div>
		</div>
		<div class="member_wrapper">
			<ul class="member">
				<%
					if (udtos != null) {

						for (int i = 0; i < udtos.size(); i++) {
				%>
				<li><a id="<%=udtos.get(i).getUserno()%>" href=""> <%=udtos.get(i).getUsername()%></a></li>

				<%
						}
					}
				%>
			</ul>
		</div>
	</nav>
	<!-- /sidebar:left -->
	
	<!-- inside wrapper -->
	<div class="inside-wrapper" style="overflow: auto">

		<!-- content:main -->
	    <div class="maincontent">
	    	<!-- boardwrapper -->
	    	<div class="boardwrapper">
	    		<!-- board-table -->
	    		<form action="Board.ho" method="post" id="board-table">
		    		<input type="hidden" name="command" value="delete_board_multi" />
		    		<table class="board-table">
		    			<col width="10px"/>
		    			<col width="100px"/>
	        			<col width="500px"/>
	        			<col width="100px"/>
	        			<col width="100px"/>
		    			<thead>
		    				<tr>
		    					<th><input type="checkbox" name="all" onclick="allChk(this.checked)" /></th>
		    					<th scope="col">작성자</th>
		    					<th scope="col">제목</th>
		    					<th scope="col">작성일</th>
		    					<th scope="col">첨부파일</th>
		    				</tr>
		    			</thead>
		    			
		    			<!-- 게시글 목록 -->
						<tbody class="titlelist">
		    				<c:forEach items="${bdtos }" var="bdto">
			    				<tr>
			    					<td><input type="checkbox" name="checkable_item" value="${bdto.bno }" /></td>
			    					<th scope="row">${bdto.username }</th>
			    					<td><a class="list_title" href="javascript:boardDetail(${bdto.bno });">${bdto.btitle}</a></td>
			    					<th scope="row"><fmt:formatDate pattern = "yy/MM/dd" value = "${bdto.regdate }" /></th>
			    					<c:choose>
			    						<c:when test="${empty bdto.ftitle }">
			    						</c:when>
			    						<c:otherwise>
			    						<td><a href="#" onclick=""><img src="resources/image/icon/clipicon.png" width="20px" height="auto"></a></td>
			    						</c:otherwise>
			    					</c:choose>
			    					<td></td>
			    				</tr>
		    				</c:forEach>

		    			</tbody>
		    			<tfoot>
		    				<tr>
		    					<td colspan="5">
									<input type="button" value="글쓰기" onclick="showBoardInsert(<%=udto.getUserno()%>, '<%=udto.getUsername()%>');" class="board-btn" />
									<input type="submit" value="삭제" class="board-btn2"/>
								</td>
		    				</tr>
		    			</tfoot>
		    		</table>
	    		</form>
	    		<!-- /board-table -->
	    		
	    		<!-- .paging -->
	    		<div class="paging">  
	    		<a href="Board.ho?command=reflash_board_list&pno=<%=pdto.getPno() %>&pageno=<%=pageno-1 %>" class="btn_arr prev"><span class="hide">◀</span></a>  
			    		<c:forEach items="${num_of_page }" var="page">
			    		<c:set var= "pageno" value="${pageno }"/>
			    		<c:choose>
			    			<c:when test = "${page==pageno}">
			    				<a class="on" href="Board.ho?command=reflash_board_list&pno=1&pageno=${page }">${page }</a>
			    			</c:when>
			    			<c:otherwise>
			    				<a href="Board.ho?command=reflash_board_list&pno=1&pageno=${page }">${page }</a>
			    			</c:otherwise>
			    		</c:choose>
			    		</c:forEach>
					<a href="Board.ho?command=reflash_board_list&pno=1&pageno=<%=pageno+1 %>" class="btn_arr next"><span class="hide">▶</span></a>            
				</div>
				<!-- /.paging -->
				
				<!-- .search -->
				<div class="search">
					<form action="" method="post">
						<input type="search" id="search_input" placeholder="내용을 입력하세요"/>
						<input type="submit" id="search" value="검색" class="board-btn2"/>
					</form>
				</div>
				<!-- /.search -->
	        </div>
	        <!-- /boardwrapper -->
		</div>
		<!-- /content:main -->
		
		
		<div class="thread-margin">
			<!-- thread wrapper -->
			<div class="thread-wrapper"">
			
				<!-- board-thread -->
				<!-- 게시글 작성하기 -->	
				<form action="../Board.ho" method="post" id="board-thread" enctype="multipart/form-data">
					<input type="hidden" name="command" value="insert_board"/>
					<input type="hidden" name="userno" id="detail_userno" value="<%=udto.getUsername()%>"/>
					<table>
						<tr>
							<th>작성자</th>
							<td><input type="text" name="username" id="detail_username" style="width:230px;" readonly="readonly"/></td>
							<th id="detail_date_">작성일</th>
							<td><input type="text" id="detail_date" style="width:269px;"/></td>
						</tr>
						<tr>
							<th>제목</th>
							<td colspan="3"><input type="text" name="btitle" id="detail_btitle" style="width:579px;"/></td>
						</tr>
						<tr>
							<th>내용</th>
							<td colspan="3"><textarea rows="40" cols="70" name="bcontent" id="detail_bcontent" style="overflow-x:hidden; overflow-y:auto;"></textarea></td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td id="binfile"><input type="file" name="file" id="detail_file" /></td>						
						</tr>
						<tr>
							<td colspan="4" align="right">
								<input type="button" value="작성 완료" class="board-btn" id="board_thread-insertbtn" onclick="boardInsert();"/>
							</td>
						</tr>
					</table>
				</form>
				<!-- /board-thread -->
		    </div>
			<!-- /.thread-wrapper -->
			</div>	
	</div>
	<!-- /inside-wrapper -->
	
</body>
</html>