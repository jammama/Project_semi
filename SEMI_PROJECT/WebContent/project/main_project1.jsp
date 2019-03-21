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

<!-- TAGLIB 정의 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link rel="shortcut icon" href="resources/image/favicon.ico"/>
<!-- 페이지 CSS 로드 -->
<link rel="stylesheet" type="text/css" href="resources/css/ChatBoard.css">

<!-- JQUERY 로드 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!-- 카카오 지도 API 스크립트 -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bb2984f0bdf61397f855939afa894bbb&libraries=services"></script>

<!-- 반응형 페이지 관련 스크립트 -->
<script type="text/javascript" src="resources/js/project_setting.js"></script>

<!-- 웹소켓을 이용한 채팅 관련 스크립트 -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script type="application/javascript" src="resources/js/websocket_setting.js"></script>

<!-- 동영상 관련 스크립트 -->
<script type="text/javascript" src="resources/js/video_setting.js"></script>

<!-- 파일 관련 스크립트 -->
<script type="text/javascript" src="resources/js/file_setting.js"></script>
</head>
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
			<img onclick="location.href='Project.ho?command=to_main_project'" src="resources/image/main/Nomwork_logo.png">
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
		<div class="leftside-share" onclick="location.href='Board.ho?command=reflash_board_list'">
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
				<li><a href="Channel.ho?command=to_other_channel&cno=<%=cdtos.get(i).getCno()%>"> #<%=cdtos.get(i).getCname()%></a></li>

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

	<!-- inside wrapper -->
	<div class="inside-cover" style="display: none"></div>
	<div class="inside-wrapper">

		<!-- display:none 모음 다른 창들을 무시하고 뜨는 postion: absolute 입력창들-->

		<!-- link 가져오기 -->
		<div class="insert-link-text" style="display: none">
			<div class="attach-title">링크 내 텍스트 가져오기</div>
			<div class="attach-label">링크주소</div>
			<div class="link-input-wrapper">
				<div class="link-input" contentEditable="true"></div>
				<div class="link-ok">가져오기</div>
			</div>
			<div class="attach-label">텍스트</div>
			<div class="link-output" contenteditable="true"></div>
			<div class="attach-submit">입력</div>
			<div class="attach-cancel">취소</div>
		</div>
		<!-- /link 가져오기 -->

		<!-- 동영상 가져오기 -->
		<div class="insert-video" style="display: none">
			<div class="attach-title">동영상 첨부</div>
			<div class="attach-label">Youtube링크</div>
			<div class="link-input-wrapper">
				<div class="link-input" contentEditable="true"></div>
				<div class="link-ok" onclick="videoPreview();">가져오기</div>
			</div>
			<div class="video-detail"></div>
			<div class="attach-submit">전송</div>
			<div class="attach-cancel" onclick="videoUploadCancel();">취소</div>
		</div>
		<!-- /동영상 가져오기 -->

		<!-- 지도 가져오기 -->
		<div class="insert-map" style="display: none">
			<div class="attach-title">지도 첨부</div>
			<div class="map-show" id="map"></div>

			<!-- 위도와 경도를 담을 INPUT 태그 -->
			<input id="latitude" type="hidden" value="" /> <input id="longitude"
				type="hidden" value="" />

			<!-- 카카오 지도 API 적용 스크립트 -->
			<script>
				var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
				mapOption = {
					center : new daum.maps.LatLng(37.49802241874058,
							127.02777407827081), // 지도의 중심좌표
					level : 3
				// 지도의 확대 레벨
				};

				var map = new daum.maps.Map(mapContainer, mapOption);

				var marker = new daum.maps.Marker({
					position : map.getCenter()
				});
				marker.setMap(map);

				daum.maps.event.addListener(map, 'click',
						function(mouseEvent) {
							map.relayout();
							var latlng = mouseEvent.latLng;

							marker.setPosition(latlng);

							document.getElementById("latitude").value = latlng
									.getLat(); //위도
							document.getElementById("longitude").value = latlng
									.getLng(); //경도
						});

				// 주소-좌표 변환 객체를 생성
				var geocoder = new daum.maps.services.Geocoder();

				function searchButton() {
					// 주소로 좌표를 검색합니다
					var search = document.getElementById('search').value;
					geocoder.addressSearch(search, function(result, status) {

						// 정상적으로 검색이 완료됐으면 
						if (status === daum.maps.services.Status.OK) {

						var coords = new daum.maps.LatLng(result[0].y, result[0].x);

//							// 결과값으로 받은 위치를 마커로 표시
//							var marker = new daum.maps.Marker({ map: map, position: coords });

//							// 인포윈도우로 장소에 대한 설명을 표시
//							var infowindow = new daum.maps.InfoWindow({
//												content: '<div style="width:150px;text-align:center;padding:6px 0;"></div>'
//							});
//							infowindow.open(map, marker);
//
							map.setCenter(coords);

							marker.setPosition(coords);
							
							// 위도, 경도 설정
							document.getElementById("latitude").value = coords.getLat();
							document.getElementById("longitude").value = coords	.getLng();

						} else {
							alert("정확한 주소를 적어주세요");
						}
					});
				}
			</script>

			<div class="attach-label">주소로 찾기</div>
			<textarea class="map-input" id="search" placeholder="주소적고 주소검색 클릭!"></textarea>
			<div class="attach-submit">전송</div>
			<div class="attach-cancel">취소</div>
		</div>
		<!-- 파일 가져오기 -->
		<div class="insert-file" style="display: none">
			<div class="attach-title">파일 첨부</div>
			<div class="link-input-wrapper">
				<input type="file" id="filename" name="filename" style="width:600px"/>
		<div class="link-ok" onclick="getFileName();">가져오기</div> 	
			</div>
			<div class="file-size">*첨부하는 파일의 크기는 15MB를 넘을 수 없습니다</div>
			<div class="attach-label">파일이름 설정(옵션)</div>
			<input class="map-input"></input>
			<div class="attach-submit">전송</div>
			<div class="attach-cancel" onclick="fileUploadCancel();">취소</div>
		</div>
		<!-- /파일 가져오기 -->

		<!-- display:none 모음 끝 -->

		<!-- content:main -->
		<div class="maincontent">
			<!-- chatwrapper -->
			<div class="chatwrapper">
				<!-- chat-->
				<%
					//기존 채팅 내역 불러오기
					if (tdtos != null && tdtos.size() != 0) {

						for (int i = 0; i < tdtos.size(); i++) {
							//일반 채팅
							if (tdtos.get(i).getFno() == 0 && tdtos.get(i).getMno() == 0 && tdtos.get(i).getCvno() == 0) {
								//동영상 채팅
								if(tdtos.get(i).getVurl()!=null){
				%>
				<div class="chat_video">
					<div class="profile-pic">
						<img src="<%=tdtos.get(i).getUserurl()%>">
					</div>
					<div class="contextbody">
						<div class="writer"><%=tdtos.get(i).getUsername()%></div>
						<div class="context">
							<iframe id="video_frame<%=tdtos.get(i).getTno() %>" width="560" height="315" src="https://www.youtube.com/embed/<%=tdtos.get(i).getVurl() %>"
									frameborder="0" allow="accelerometer; autoplay;encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
							<div id="bookmarklink<%=tdtos.get(i).getTno() %>">
								<ul style="list-style:none" id="bookmarkul<%=tdtos.get(i).getTno() %>"></ul>
							</div>
							<div id="bookmarkdiv">
								<input id="startTime<%=tdtos.get(i).getTno() %>" type="text" class="inputvideolink" placeholder="ex) 45초 -> 00:45" />
								<input type="button" id="getStartTime" value="구간이동" onclick="javascript:getStartTime('<%=tdtos.get(i).getVurl()%>',<%=tdtos.get(i).getTno() %>)" />
								<input type="text" id="bookmarktext<%=tdtos.get(i).getTno() %>" class="inputvideolink" style="display:none" placeholder="북마크에 설명을 적어주세요." />
								<input type="button" id="bookmark<%=tdtos.get(i).getTno() %>" class="btnbookmark" value="북마크" style="display:none" onclick="javascript:bookmark('<%=tdtos.get(i).getVurl()%>',<%=tdtos.get(i).getTno() %>)" /> 									
							</div>
						</div>
					</div>
				</div>			
				<%
								} else {  //일반 채팅
									if(tdtos.get(i).getTcontent().startsWith("http://")) {  // a태그 처리
				%>
				<!--chat-->
				<div class="chat">
					<div class="profile-pic">
						<img src="<%=tdtos.get(i).getUserurl()%>">
					</div>
					<div class="contextbody">
						<div class="writer"><%=tdtos.get(i).getUsername()%></div>
						<div class="context"><a class="contextlink" href="<%=tdtos.get(i).getTcontent()%>" target="_blank"><%=tdtos.get(i).getTcontent()%></a></div>
					</div>
				</div>
				
				<%						
									} else {
				%>
				
				<!--chat-->
				<div class="chat">
					<div class="profile-pic">
						<img src="<%=tdtos.get(i).getUserurl()%>">
					</div>
					<div class="contextbody">
					<input type="hidden"  class="tno" value="<%=tdtos.get(i).getTno() %>"/>
						<div class="writer"><%=tdtos.get(i).getUsername()%></div>
						<div class="context"><%=tdtos.get(i).getTcontent()%></div>
					</div>
				</div>
				<%
						}
					}
				}

							//지도 채팅
							if (tdtos.get(i).getFno() == 0 && tdtos.get(i).getCvno() == 0 && tdtos.get(i).getMno() != 0) {
				%>
				<div class="chat_map">
					<div class="profile-pic">
						<img src="<%=tdtos.get(i).getUserurl()%>">
					</div>
					<div class="contextbody">
						<div class="writer"><%=tdtos.get(i).getUsername()%></div>
						<div class="context">
							<div class="context-map" id=""></div>
							<input type="hidden" class="text_latitude" value="<%=tdtos.get(i).getLatitude()%>"> 
							<input type="hidden" class="text_longitude" value="<%=tdtos.get(i).getLongitude()%>">
							<script>
								var latitude = document
										.getElementsByClassName("text_latitude")[document
										.getElementsByClassName("text_latitude").length - 1].value;
								var longitude = document
										.getElementsByClassName("text_longitude")[document
										.getElementsByClassName("text_longitude").length - 1].value;

								var allMapContainers = document
										.getElementsByClassName('context-map');
								var mapContainer = allMapContainers[allMapContainers.length - 1],

								mapOption = {
									center : new daum.maps.LatLng(latitude, longitude), // 지도의 중심좌표
									level : 3 //확대 레벨
								};

								// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
								var chatmap = new daum.maps.Map(mapContainer,
										mapOption);

								//마커가표시될위치
								var markerPosition = new daum.maps.LatLng(
										latitude, longitude);
								//마커생성
								var chatmarker = new daum.maps.Marker({
									position : markerPosition
								});
								//마커가지도위에표시되도록설정
								chatmarker.setMap(chatmap);
							</script>
						</div>
					</div>
				</div>

				<%
					}
							//파일 채팅
							if (tdtos.get(i).getFno() != 0 && tdtos.get(i).getCvno() == 0 && tdtos.get(i).getMno() == 0) {

								%>
								<div class="chat_file">
									<div class="profile-pic">
										<img src="<%=tdtos.get(i).getUserurl()%>">
									</div>
									<div class="contextbody">
										<div class="writer"><%=tdtos.get(i).getUsername()%></div>
										<div class="context">
											<div class="context-file">
												<img src="resources/image/icon/file.png" width="18px" height="18px"/>
												<a class="filedownload" href="FileServlet?command=file_download&ftitle=<%=tdtos.get(i).getFtitle()%>"><%=tdtos.get(i).getFtitle() %></a>
											</div>
										</div>
									</div>
								</div>
								
								<%								
								
							}
							
							// 캔버스 채팅
							if (tdtos.get(i).getCvno() != 0 && tdtos.get(i).getFno() == 0 && tdtos.get(i).getMno() == 0) {

								%>
						       <div class="chat_canvas">
									<div class="profile-pic">
										<img src="<%=tdtos.get(i).getUserurl()%>">
									</div>
									<div class="contextbody">
										<div class="writer"><%=tdtos.get(i).getUsername()%></div>
										<div class="context">
											<div class="canvasImg"><img width="300px" height="300px" id="chatImage" src="<%=tdtos.get(i).getCvurl()%>">
											</div>
										</div>
						            </div>
						        </div>
								
								<%								
								
							}
						}
					}
				%>

				<!-- 게시글 가져오기-->
				<c:forEach items="${titlelist }" var="title">
					<div class="chat">
						<div class="profile-pic">
							<img src="">
						</div>
						<div class="contextbody">
							<div class="writer">${title.userno }</div>
							<div class="context">${title.content}</div>
						</div>
					</div>
				</c:forEach>
				<!-- 게시글 가져오기 -->
				<!-- 웹소켓에서 가져오기 -->
				<!-- /웹소켓에서 가져오기 -->
			</div>
			
			<!-- 채팅 입력창 -->
			<div class="inputwrapper">
				<div class="input-dropup">
					<div class="input-dropbtn"></div>
					<div class="input-dropmenu" style="display: none">
						<div class="attach">attach..</div>
						<div class="dropmenu open-file">파일 업로드</div>
						<div class="dropmenu open-map">지도 첨부하기</div>
						<div class="dropmenu open-video">동영상 첨부하기</div>
						<div class="dropmenu open-link">링크 내 텍스트 가져오기</div>
						<div class="dropmenu open-canvas">그림판</div>
					</div>
				</div>
				<div class="input-text" contentEditable="true"></div>
				<div class="input-submit">작성</div>
			</div>
			<!-- 채팅 입력창 끝 -->
		</div>
		<!-- /content:main -->

		<div class="thread-margin">
			<!-- thread wrapper -->
			<div class="thread-wrapper">
				<!-- 작성자+내용 -->
				<div class="thread-board">
					<div class="profile-pic"><img src=""></div>
					<div class="board-context">
						<div class="board-writer"></div>
						<div class="board-content"></div>
					</div>
					<div class="to_board_btn">게시판으로 보내기</div>
				</div>
				
				<!-- 답글입력 -->
				<div class="board-insertReply">
					<div class="reply-dropup">
						<a class="reply-dropbtn" type="button"></a>
						<div class="reply-dropmenu" style="display: none">
							<div class="attach">attach..</div>
							<div class="dropmenu open-map-re">지도 첨부하기</div>
							<div class="dropmenu open-video-re">동영상 첨부하기</div>
							<div class="dropmenu open-link-re">링크 내 텍스트 가져오기</div>
						</div>
					</div>
					<div class="reply-input" contentEditable="true">
						<br>
					</div>
					<div class="reply-submit">작성</div>
				</div>
			</div>
			<!-- /.thread-wrapper -->
		</div>

	</div>
	<!-- /inside-wrapper -->
</body>
</html>