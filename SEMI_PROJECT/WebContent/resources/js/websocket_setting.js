//웹소켓 연결은 페이지가 모두 로드된 후 호출된다.
window.onload = function() {
	var Chat = {};

	Chat.socket = null;

	// connect() 함수 정의
	Chat.connect = (function(host) {

		// 서버에 접속 시도
		// 브라우저마다 WebScoket이 지원되지 않는 경우가 있기 때문에 조건문으로 판단한다.
		// window 객체에 WebSocket 속성이 있다면 if문 실행
		if ('WebSocket' in window) {

			// WebSocket은 브라우저가 제공하는 시스템 객체이다.
			Chat.socket = new WebSocket(host);

		} else {

			alert('해당 브라우저는 웹소켓을 지원하지 않습니다.');
			return;
		}

		// 서버에 접속이 되면 호출되는 콜백함수
		// 소켓에 정의된 속성에 함수주소를 저장한다.
		Chat.socket.onopen = function() {

			// Console은 개발자가 만든 객체
			alert('웹소켓 연결에 성공하였습니다.');

			// 채팅 작성 버튼 이벤트 생성
			$(".input-submit").click(function(event) {
				Chat.sendMessage();
			});

			$(".input-text").on("keydown", function(event) {

				// 엔터키가 눌린 경우, 서버로 메세지를 전송함
				if (event.keyCode == 13) {
					Chat.sendMessage();
				}

			});

			// 지도 마크 전송 버튼 이벤트 생성
			$(".attach-submit:eq(2)").click(function(event) {

				// 지도 첨부 창 닫기
				$(".insert-map").hide();
				$(".inside-cover").hide();

				// 서버로 메세지 전송하기
				Chat.sendMap();
			});
			
			// 채팅 답글 작성 버튼 이벤트 생성
			$(".reply-submit").click(function(event) {
				var tno = $(".reply_tno").val();
				Chat.sendReply(tno);
			});

			$(".reply-input").on("keydown", function(event) {
				// 엔터키가 눌린 경우, 서버로 메세지를 전송함
				if (event.keyCode == 13) {
					var tno = $(".reply_tno").val();
					Chat.sendReply(tno);
				}

			});
			
			//동영상 첨부 전송 버튼 이벤트 생성
			$(".attach-submit:eq(1)").click(function(event) {
				
				//동영상 첨부 창 닫기
				$(".insert-video").hide();
				$(".inside-cover").hide();
		
				Chat.sendVideo();
				
				document.getElementsByClassName("link-input")[1].innerHTML = "";
				document.getElementsByClassName("video-detail")[0].innerHTML = "";
			});
			
			//파일 첨부 전송 버튼 이벤트 생성
			$(".attach-submit:eq(3)").click(function(event) {
				//파일 첨부 창 닫기
				document.getElementsByClassName("insert-file")[0].style.display="none";
				$(".inside-cover").hide();

				Chat.sendFileUpload();
				
				document.getElementById("filename").value = "";	
		    	document.getElementsByClassName("map-input")[1].value = "";
		    	
			});
		}

		// 연결이 끊어진 경우에 호출되는 콜백함수
		Chat.socket.onclose = function() {

			alert('웹소켓 연결이 해제되었습니다.');

			// 채팅 작성 버튼 이벤트를 제거한다.
			$(".input-text").click(null);
			// 채팅창 이벤트 제거
			$(".input-text").on("keydown", null);
			// 채팅 답글 작성 이벤트 제거
			$(".reply-submit").click(null);
			// 채팅 답글창 이벤트 제거
			$(".reply-input").on("keydown", null);
			// 지도 전송 버튼 이벤트 제거
			$(".attach-submit:eq(2)").click(null);
			//동영상 첨부 전송 버튼 이벤트 제거
			$(".attach-submit:eq(1)").click(null);
			//파일 첨부 전송 버튼 이벤트 제거
			$(".attach-submit:eq(3)").click(null);
			

		};

		// 서버로부터 메세지를 받은 경우에 호출되는 콜백함수
		Chat.socket.onmessage = function(message) {

			// 수신된 메세지를 화면에 출력함.
			var obj = eval(message.data);
			var pass = false;

			for (var i = 0; i < obj.length; i++) {
				ok = false;
				// 웹소켓 연결 성공시 이벤트
				if (obj[i].command == "HandleOpen") {

					$(".member").find("li").find("a").each(function(idx) {

						// 웹소켓 연결 사용자 처리
						if ($(this).attr('id') == obj[i].userno) {

							pass = true;
							if (!$(this).text().match(/ON/)) {
								$(this).append('[ON]');
								$(this).css("font-weight", "bold");
							}
						}
					});
					// 웹소켓 연결 사용자를 제외한 사용자 처리
					if (!pass) {
						//
					}

				} else if (obj[i].command == "HandleMessage") {

					Console.log(obj[i]);

				} else if (obj[i].command == "HandleClose") {

					$(".member").find("li").find("a").each(function(idx) {
						// 연결종료된 사용자 처리
						if ($(this).attr('id') == obj[i].userno) {

							if (!$(this).text().match(/ON/)) {
								$(this).text(text.replace('[ON]', ''));
								$(this).css("font-weight", "normal");
							}
						}
					});
				}
			}
		};
	}); // connect() 함수 정의 끝

	// 위에서 정의한 connect() 함수를 호출하여 접속을 시도함.
	Chat.initialize = function() {

		if (window.location.protocol == 'http:') {

			// Chat.connect('ws://' + window.location.host + 'websocket/chat');
			// connect 함수에 파라미터를 전달해서 접속 시도, 콜백함수 등록
			// ws : tcp/ip 기반 프로토콜
			Chat.connect('ws://localhost:8787/SEMI_PROJECT/ChatWS');

		} else {

			Chat.connect('wss://' + window.location.host + '/websocket/chat');

		}
	};

	// 서버로 메세지를 전송하고 입력창에서 메세지를 제거함
	Chat.sendMessage = (function() {

		var message = $(".input-text").text();
		var arr = [];
		
		// url 입력은 a태그로 만들기
		if(message.startsWith("www.") || message.startsWith("http://") || message.startsWith("https://")){
			message="http://"+message;
		}
		
		// 공백의 경우는 제외시킨다
		if (message != '') {
			var obj = {};
			var jsonStr;

			// 채널에 포함된 인원에게만 메세지 보내기
			obj.command = "HandleMessage";
			obj.purpose = "Chat"
			obj.tcontent = message;
			jsonStr = JSON.stringify(obj);

			Chat.socket.send(jsonStr);

			// 입력창에서 텍스트 제거
			$(".input-text").text('');
		}
	});
	
	// 서버로 답글을 전송하고 입력창에서 메세지를 제거함
	Chat.sendReply = (function(tno) {

		var message = $(".reply-input").text();
		var arr = [];
		// 공백의 경우는 제외시킨다
		if (message != '') {
			var obj = {};
			var jsonStr;

			// 채널에 포함된 인원에게만 메세지 보내기
			obj.command = "HandleMessage";
			obj.purpose = "Reply"
			obj.tcontent = message;
			obj.tno = tno;
			jsonStr = JSON.stringify(obj);

			Chat.socket.send(jsonStr);

			// 입력창에서 텍스트 제거
			$(".reply-input").text('');
		}
	});

	// 서버로 지도를 전송하기 위한 함수 정의
	Chat.sendMap = (function() {

		// 위도, 경도값 설정
		var latitude = document.getElementById("latitude").value;
		var longitude = document.getElementById("longitude").value;

		// JSON
		if (!(latitude == "" && longitude == "")) {
			var arr = [];
			var obj = {};
			var jsonStr;

			// JSON형태로 웹소켓 서버에 메세지 보내기
			obj.command = "HandleMessage";
			obj.purpose = "Map"
			obj.latitude = latitude;
			obj.longitude = longitude;
			jsonStr = JSON.stringify(obj);

			Chat.socket.send(jsonStr);
		}
	});
	
	//서버로 동영상를 전송하기 위한 함수 정의
	Chat.sendVideo = (function() {
		
		var link = document.getElementsByClassName("link-input")[1].innerHTML;
		var index = link.indexOf("watch?v=");
		var link_v = link.substr(index+8,link.length);

		//JSON
		if(!(link=="")){
			var arr = [];
			var obj = {};
			var jsonStr;
			
			//JSON형태로 웹소켓 서버에 메세지 보내기
			obj.command = "HandleMessage";
			obj.purpose = "Video"
			obj.link_v  = link_v ;
			jsonStr = JSON.stringify(obj);
			
			Chat.socket.send(jsonStr);
		}
		
	}); 

	Chat.sendFileUpload = (function() {
		var files =$("#filename").prop("files"); 
	    var data = new FormData();
	    $.each(files, function(key, value)
	    {
	        data.append(key, value);
	    });

	    var datas;
	    var filetitle;
	    var filestream
	    $.ajax({
	        url: 'File.ho?command=file_upload',
	        type: 'POST',
	        data: data,
	        cache: false,
	        dataType: 'text',
	        processData: false, 
	        contentType: false, 
	        success: function(data, textStatus, jqXHR) {
			    var datas = data.split("\n")
			    filestream = datas[0];
			    filetitle = datas[1];
			   // filename = datas[2];
			    
			  //JSON
				if(!(filetitle==""&&filestream=="")){
					var arr = [];
					var obj = {};
					var jsonStr;
					
					//JSON형태로 웹소켓 서버에 메세지 보내기
					obj.command = "HandleMessage";
					obj.purpose = "FileUpload";
					obj.filetitle = filetitle;
					obj.filestream = filestream;
					//obj.filename = filename;
					jsonStr = JSON.stringify(obj);
					
					Chat.socket.send(jsonStr);
				}
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	            console.log('ERRORS: ' + textStatus);
	        }
		});	
	});

	// 화면에 메세지를 출력하기 위한 객체 생성, json Object
	var Console = {};

	// log() 함수 정의
	Console.log = (function(message) {
		var $console = $(".chatwrapper");

		if (message != "" || message != null) {
			if (message.purpose == "Map") { // 지도 첨부 형식 지정

				$console
						.append("<div class='chat_map'>"
								+ "<div class='profile-pic'><img src='"
								+ message.userurl
								+ "'></div>"
								+ "<div class='contextbody'>"
								+ "<div class='writer'>"
								+ message.username
								+ "</div>"
								+ "<div class='context'>"
								+ "<div class='context-map' id='"
								+ message.tno
								+ "'></div>"
								+ "<script>"
								+ "var mapContainer = document.getElementById('"
								+ message.tno
								+ "'),"
								+ "mapOption = {"
								+ "center: new daum.maps.LatLng("
								+ +message.latitude
								+ ","
								+ message.longitude
								+ "),"
								+ "level: 3};"
								+ "var chatmap = new daum.maps.Map(mapContainer, mapOption); "
								+ "var markerPosition  = new daum.maps.LatLng("
								+ message.latitude
								+ ","
								+ message.longitude
								+ ");"
								+ "var chatmarker = new daum.maps.Marker({"
								+ "position: markerPosition });"
								+ "chatmarker.setMap(chatmap);"
								+ "<\/script></div></div></div>");
				
			} // 채팅답글 형식 지정
			else if (message.purpose == "Reply") {
				
				$(".board-insertReply").before(
        				"<div class='board-reply'>"
	    					+"<div class='profile-pic'>"
	    						+"<img src='"+message.userurl+"'>"
	    					+"</div>"
	    					+"<div class='reply-context'>"
	    						+"<div class='reply-writer'>"+message.username+"</div>"
	    						+"<div class='reply-context-body'>"+message.tcontent+"</div>"
	    					+"</div>"
	    				+"</div>")
	    	} // 비디오 채팅 형식 지정
			else if(message.purpose=="Video"){
			$console.append(
					"<div class='chat_video'>"
						+"<div class='profile-pic'>"
							+"<img src='"+ message.userurl +"'>"
						+"</div>"
						+"<div class='contextbody'>"
							+"<div class='writer'>"+ message.username +"</div>"
							+"<div class='context'>"
								+"<iframe id='video_frame"+message.tno+"' width='560' height='315' src='https://www.youtube.com/embed/"+message.link_v+"'"
								+"'frameborder='0' allow='accelerometer; autoplay;encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe>"
								+"<div id='bookmarklink"+message.tno+"'><ul style='list-style:none' id='bookmarkul"+message.tno+"'></ul></div>"
								+"<div id='bookmarkdiv'><input id='startTime"+message.tno+"' type='text' class='inputvideolink' placeholder='ex) 45초 -> 00:45'>"
									+"<input type='button' id='getStartTime' value='구간이동' onclick='javascript:getStartTime(\""+message.link_v+"\","+message.tno+");'>"
									+"<input type='text' id='bookmarktext"+message.tno+"' class='inputvideolink' style='display:none' placeholder='북마크에 설명을 적어주세요.'>"
									+"<input type='button' id='bookmark"+message.tno+"' class='btnbookmark' value='북마크' style='display:none' onclick='javascript:bookmark(\""+message.link_v+"\","+message.tno+");'>"  									
									+"</div>"
							+"</div>"			
						+"</div>"
					+"</div>"
						);
		} else if(message.purpose=="FileUpload"){
			$console.append(
					"<div class='chat_file'>"
						+"<div class='profile-pic'>"
							+"<img src='"+ message.userurl +"' />"
						+"</div>"
						+"<div class='contextbody'>"
							+"<div class='writer'>"+ message.username +"</div>"
							+"<div class='context'>"
								+"<div class='context-file'>"
									+"<img src='resources/image/icon/file.png' width='18px' height='18px'/>"
									+"<a class='filedownload' href='FileServlet?command=file_download&ftitle="+message.filetitle+"'>"+message.filetitle+"</a>"
								+"</div>"
							+"</div>"			 									
                		+"</div>"
                	+"</div>"
					);
					
		} // 일반 채팅 형식 지정
		else if (message.purpose == "Chat") {
			
			if(message.tcontent.startsWith("http://")){ // URL 입력은 A 태그로 만들기
				$console.append(
						"<div class='chat'>"
		        		+"<div class='profile-pic'><img src='"+ message.userurl +"'></div>"
		        		+"<div class='contextbody'>"
		        			+ "<input type='hidden' class='tno' value='"+ message.tno+"'/>"
	    	        		+"<div class='writer'>"+ message.username +"</div>"
	    	        		+"<div class='context'>"+ "<a class='contextlink' href='"+message.tcontent+"' target='_blank'>"+message.tcontent+"</a>" +"</div>"
		        		+"</div>"
		        	+"</div>"
						);
			} else{
			 $console.append(	    		
	        	"<div class='chat'>"
	        		+"<div class='profile-pic'><img src='"+ message.userurl +"'></div>"
	        		+"<div class='contextbody'>"
	        			+ "<input type='hidden' class='tno' value='"+ message.tno+"'/>"
    	        		+"<div class='writer'>"+ message.username +"</div>"
    	        		+"<div class='context'>"+ message.tcontent +"</div>"
	        		+"</div>"
	        	+"</div>"
	   		);
			}
		};
		}

		// 스크롤을 최상단에 있도록 설정함
		$console.scrollTop($console.prop("scrollHeight"));

	});

	// 위에 정의된 함수(접속시도)를 호출함
	Chat.initialize();

}