<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- 주요 클래스 IMPORT -->
<%@ page import="java.util.List"%>
<%@ page import="com.nomwork.user.dto.*"%>
<%@ page import="com.nomwork.project.dao.*"%>
<%@ page import="com.nomwork.project.dto.*"%>
<%@ page import="com.nomwork.channel.dto.*"%>
<%@ page import="com.nomwork.text.dto.*"%>
<%@page import="com.nomwork.todo.dto.*"%>
<%@page import="com.nomwork.todo.dao.*"%>
<%@page import="java.util.Calendar"%>

<!-- TAGLIB 정의 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">

<!-- 페이지 CSS 로드 -->
<link rel="stylesheet" type="text/css" href="resources/css/ChatBoard.css">
<link rel="stylesheet" type="text/css" href="resources/css/Calendar.css">

<!-- JQUERY 로드 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!-- 카카오 지도 API 스크립트 -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bb2984f0bdf61397f855939afa894bbb&libraries=services"></script>

<!-- 반응형 페이지 관련 스크립트 -->
<script type="text/javascript" src="resources/js/react_setting.js"></script>

<!-- 웹소켓을 이용한 채팅 관련 스크립트 -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script type="application/javascript" src="resources/js/websocket_setting.js"></script>

</head>

<!-- calendar js, 객체생성 -->
<script type="text/javascript">
	// 웹소켓 연결성공 시 alert창 무효화
	window.alert = function() {};
	function isTwo(n) {
		return (n.length<2)?"0"+n:n;
	}
</script>
<%
	Calendar cal = Calendar.getInstance();

	int year = cal.get(Calendar.YEAR);
	int month = cal.get(Calendar.MONTH)+1;
	
	String paramYear = request.getParameter("year");
	String paramMonth = request.getParameter("month");

	if (paramYear != null) {
		year = Integer.parseInt(paramYear);
	}
	if (paramMonth != null) {
		month = Integer.parseInt(paramMonth);
	}

	if (month > 12) {
		month = 1;
		year++;
	}
	if (month < 1) {
		month = 12;
		year--;
	}

	// 현재년도, 현재월, 해당월의 1일
	cal.set(year, month-1, 1);

	// 1일의 요일
	int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
	
	// 현재 월의 마지막 일
	int lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
	
	session.setAttribute("dayOfWeeka", cal.get(Calendar.DAY_OF_WEEK));
	session.setAttribute("lastdaya", cal.getActualMaximum(Calendar.DAY_OF_MONTH));

	TodoDao dao = new TodoDao();
	String yyyyMM = year + Util.isTwo(String.valueOf(month));
	int projectno = Integer.parseInt(request.getParameter("projectno"));
	List<TodoDto> clist = dao.select_todo_view_list(projectno, yyyyMM);
	
	int date=Integer.parseInt(request.getParameter("date"));
	int hour= cal.get(Calendar.HOUR_OF_DAY);
	int min = cal.get(Calendar.MINUTE);
%>
<!-- calendar 관련 끝 -->


<body>

	<!-- 주요 클래스 객체 생성 -->
	<%
		UserDto udto = (UserDto) session.getAttribute("udto");
		ProjectDto pdto = (ProjectDto) session.getAttribute("pdto");
		ChannelDto cdto = (ChannelDto) session.getAttribute("cdto");
		List<UserDto> udtos = (List<UserDto>) session.getAttribute("udtos");
		List<ChannelDto> cdtos = (List<ChannelDto>) session.getAttribute("cdtos");
		List<ProjectDto> pdtos = (List<ProjectDto>) session.getAttribute("pdtos");
		List<TextDto> tdtos = (List<TextDto>) session.getAttribute("tdtos");
	%>

	<!-- sidebar:top -->
	<nav class="topsidebar">
		<div class=logo>
			<img src="resources/image/main/Nomwork_logo.png">
		</div>

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
			
			<!-- SELECT 이벤트 설정 -->
			<script type="text/javascript">
			
				function handleSelect(pno) {
			window.location = "Project.ho?command=project_detail&pno=" + pno.value
			}
			</script>
		</div>
		<div class="topside-2"></div>

		<!-- 프로필 관련 -->
		
		<!-- 프로필 이미지 가져오기 -->
		<div class="topside-3"><img src="<%=udto.getuserurl()%>"></div>
		
		<!-- 프로필 이름 가져오기 -->
		<div class="topside-4"><%=udto.getUsername()%></div>
		
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
		<div class="myprofile">
			<div class="leftside-1">
				<div></div>
			</div>
			
			<!-- 프로필 이름 가져오기 -->
			<div class="leftside-2">
				<div><%=udto.getUsername()%></div>
			</div>
		</div>
		
		<!-- 공유 캘린더 이미지 및 링크 설정 -->
		<div class="leftside-share" style="cursor:pointer" onclick="location.href='Todo.ho?command=Todo&projectno=<%=pdto.getPno() %>'">
			<img src="http://simpleicon.com/wp-content/uploads/Calendar-1.png">공유캘린더</div>
		
		<!-- 공유 게시판 이미지 및 링크 설정 -->
		<div class="leftside-share" onclick="location.href='Board.ho?command=to_main_board'">
			<img src="https://img.icons8.com/metro/50/000000/edit-property.png">공유게시판
		</div>
		<br>
		<hr>

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
				<li><a href=""> #<%=cdtos.get(i).getCname()%></a></li>

				<%
						}
					}
				%>
			</ul>
		</div>
		<br>
		<hr>
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
				<li><a id="<%=udtos.get(i).getUserno()%>" href=""> #<%=udtos.get(i).getUsername()%></a></li>

				<%
						}
					}
				%>
			</ul>
		</div>
	</nav>
	<!-- /sidebar:left -->
	
	<!-- calendar 시작 -->
	<div id="main_main">
		<div id="wrap">
			<!-- 캘린더 오늘날짜, 년월이동버튼 테이블 -->
			<table class="thead">
				<tr>
					<td style="text-align: left">
						<span>&nbsp;&nbsp; <%=year%></span>, <span><%=month%></span>월
					</td>
					<td style="text-align: right; vertical-align: super;">
						<a href="Todo.ho?command=change&year=<%=year - 1%>&month=<%=month%>&projectno=<%=projectno %>"><img src="resources/image/calendar/yL.png" /></a>
						<a href="Todo.ho?command=change&year=<%=year%>&month=<%=month - 1%>&projectno=<%=projectno %>"><img src="resources/image/calendar/MonL.png" /></a>
						<a href="Todo.ho?command=change&year=<%=year%>&month=<%=month + 1%>&projectno=<%=projectno %>"><img src="resources/image/calendar/MonR.png" /></a>
						<a href="Todo.ho?command=change&year=<%=year + 1%>&month=<%=month%>&projectno=<%=projectno %>"><img src="resources/image/calendar/yR.png" /></a>
					</td>
				</tr>
			</table>
			
			<table id="calendar">
				<tr class="weekdays">
					<th>Sun</th>
					<th>Mon</th>
					<th>Tue</th>
					<th>Wed</th>
					<th>Thu</th>
					<th>Fri</th>
					<th>Sat</th>
				</tr>

				<tr>
					<%
						//공백
						for (int i = 0; i < dayOfWeek - 1; i++) {
							out.print("<td> &nbsp; </td>");
						}
						for (int i = 1; i <= lastDay; i++) {
					%>
					<td style="background-color:<%=Util.bgColor(i, dayOfWeek, year, month)%> ">
						<a href="Todo.ho?command=todolist&year=<%=year%>&month=<%=month%>&date=<%=i%>&lastDay=<%=lastDay%>&projectno=<%=projectno %>"
						style="color:<%=Util.fontColor(i, dayOfWeek)%>"><%=i%></a>
						<a href="Todo.ho?command=insert&year=<%=year%>&month=<%=month%>&date=<%=i%>&lastDay=<%=lastDay%>&projectno=<%=projectno %>">
						<img alt="일정추가" src="resources/image/calendar/task.png" style="width: 13px; height: 13px;" />
						</a>

						<div class="clist">
							<%=Util.getCalView(i, clist)%>
						</div>
					</td>
					<%
						if ((dayOfWeek - 1 + i) % 7 == 0) {
					%>
				</tr>
				<tr>
					<%
						}
						}
						for (int i = 0; i < (7 - (dayOfWeek + lastDay - 1) % 7) % 7; i++) {
					%>
					<td></td>
					<%
						}
					%>
				</tr>
			</table>
		</div>
	</div>
	<!-- calendar 끝 -->
		<!-- 일정추가 -->
		<div class="insert_main">	
			<div class="insert_wrap">
				<h4 style="text-align: center">NEW EVENT</h4>
				<form action="Todo.ho" method="post">
					<input type="hidden" name="command" value="insertTodo">
					<table id="calInsert">
						<tr style="text-align: center">
							<td colspan="2"><input id="i2" type="text" value="&nbsp;ProjectNo." readonly="readonly"/>
							<input id="i2" type="text" name="projectno" value=<%=projectno %> readonly="readonly" />
							<input id="i2" type="text" name="todotitle" placeholder="&nbsp;&nbsp;Event Title"></td>
						</tr>
						<tr style="display: none">
							<td>
								<select name="year">
			<%
									for(int i=year-5;i<=year+5;i++){
			%>	
										<option value="<%=i%>" <%=(year==i)?"selected":"" %> ><%=i%></option>
			<%
									}
			%>
								</select>년
								 <select name="month">
			<%
									for(int i=1;i<13;i++){
			%>	
										<option value="<%=i%>" <%=(month==i)?"selected":"" %> ><%=i%></option>
			<%
									}
			%>
								 </select>월
								 <select name="date">
			<%
									for(int i=1;i<=lastDay;i++){
			%>	
										<option value="<%=i%>" <%=(date==i)?"selected":"" %> ><%=i%></option>
			<%
									}
			%>
								 </select>일
								 <select name="hour">
			<%
									for(int i=1;i<=24;i++){
			%>	
										<option value="<%=i%>" <%=(hour==i)?"selected":"" %> ><%=i%></option>
			<%
									}
			%>					 
								 </select>시
								 <select name="minute">
			<%
									for(int i=1;i<60;i++){
			%>	
										<option value="<%=i%>" <%=(min==i)?"selected":"" %> ><%=i%></option>
			<%
									}
			%>						 
								 </select>분
							</td>
						</tr>
						<tr style="text-align: left">
							<td rowspan="2">
							<textarea id="intext" name="todocontent" rows="5" cols="40" placeholder="Notes.."></textarea></td>
                        	
                        	<td>
                        		<input id="i3" type="submit" value="작성">
                        	</td>
                        </tr>
                        <tr>
                        	<td>
								<input id="i4" type="button" value="취소" onclick="location.href='Todo.ho?command=Todo&projectno=<%=projectno %>'">
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>

</body>
</html>