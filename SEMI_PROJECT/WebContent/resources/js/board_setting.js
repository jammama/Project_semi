
// 모두 체크
function allChk(bool){
	var checked_items = document.getElementsByName("checkable_item");
	for(var i=0;i<checked_items.length;i++){
		checked_items[i].checked = bool;
	}
}
	

// 게시글 삭제하기 전 유효성 검사
$(function(){
	$("#board-table").submit(function(){
		if($("input[name=checkable_item]:checked").length==0){
			alert("하나 이상 체크해 주세요.");
			return false;
		}
	});
});
	
$(function(){ 
	
	$("#detail_file").hide();
});

function boardDetail(bno) {
	$.ajax({
			url : "Board.ho?command=board_detail&bno=" + bno,
			dataType : "json",
			success : function(msg) {
			// 회원정보 관련 변수 설정
			var userno = decodeURIComponent(msg.userno);
			var username = decodeURIComponent(msg.username);
			var userurl = decodeURIComponent(msg.userurl)
			
			//지도 관련 변수 설정
			var mno = decodeURIComponent(msg.mno);
			var latitude = decodeURIComponent(msg.latitude);
			var longitude = decodeURIComponent(msg.longitude);
			
			//파일 관련 변수 설정
			var fno = decodeURIComponent(fno);
			var ftitle = decodeURIComponent(msg.ftitle);
			var fstream = decodeURIComponent(msg.fstream);
			
			//게시글 관련 변수 설정
			var regdate = decodeURIComponent(msg.regdate);
			var bcontent = decodeURIComponent(msg.bcontent);
			var btitle = decodeURIComponent(msg.btitle);


			// 날짜 설정
			var regdate_ = regdate.split(" ");
			if (regdate_[1] == "Jan") { 	   regdate_[1] = "1";
			} else if (regdate_[1] == "Feb") { regdate_[1] = "2";
			} else if (regdate_[1] == "Mar") { regdate_[1] = "3";
			} else if (regdate_[1] == "Apr") { regdate_[1] = "4";
			} else if (regdate_[1] == "May") { regdate_[1] = "5";
			} else if (regdate_[1] == "Jun") { regdate_[1] = "6";
			} else if (regdate_[1] == "Jul") { regdate_[1] = "7";
			} else if (regdate_[1] == "Aug") { regdate_[1] = "8";
			} else if (regdate_[1] == "Sep") { regdate_[1] = "9";
			} else if (regdate_[1] == "Oct") { regdate_[1] = "10";
			} else if (regdate_[1] == "Nov") { regdate_[1] = "11";
			} else if (regdate_[1] == "Dec") { regdate_[1] = "12";
			}
			// 작성자 설정
			$("#detail_username").attr("value", username);
			$("#detail_username").attr("readonly", true);
			
			// 작성일자 설정
			$("#detail_date_").show();
			$("#detail_date").show();
			
			$("#detail_date").attr( "value", regdate_[5] + "/" + regdate_[1] + "/" + regdate_[2]);
			$("#detail_date").attr("readonly", true);
			
			// 제목 설정
			$("#detail_btitle").attr("value", btitle);
			
			// 내용 설정
			$("#detail_bcontent").text(bcontent);
			$("#board_thread-insertbtn").css("visibility", "hidden");
			
			// 첨부 파일 설정
			// 첨부된 파일이 없는 경우
			if (ftitle=="undefined") {
				$("#binfile").html("<div id='filedown_board'>파일이 없습니다.</div>");
			
			} else { 
					//첨부된 파일이 있는 경우
					$("#binfile").html( "<a id='filedown_board' href='#'>"	+ ftitle + "</a>");
					}
			
			document.getElementById("filedown_board")
			.addEventListener("click",function(event) {
										event.stopPropagation();
										event.preventDefault();
										window.location.href = "File.ho?command=file_download&ftitle="
												+ ftitle;
									});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					console.log('ERRORS: ' + textStatus);
				}
			});
}

// 글쓰기 버튼 눌렀을 때
function showBoardInsert(userno, username){
	//작성완료 버튼 띄우기
	$("#board_thread-insertbtn").css("visibility","visible");
	
	// 로그인된 유저정보로 작성자 값 설정하기
	$("#detail_username").attr("value", username);
	$("#detail_username").attr("readonly", true);
	$("#detail_userno").attr("value", userno);
	
	// 내용 지우기
	$("#detail_date").hide();
	$("#detail_date_").hide();
	$("#detail_btitle").attr("value","");
	$("#detail_bcontent").text("");
	$("#binfile").html("<div class='filecover'>파일선택</div><input type='file' name='file' id='detail_file' />");
	$("#detail_file").attr("value","");
	
}

//write
function boardInsert(event){
	
    // AJAX로 넘겨줄 파일 처리
	var files =$("#detail_file").prop("files"); 
    data = new FormData();
    $.each(files, function(key, value) {
        data.append(key, value);
    });
    command="insert_board";
    
    var form = document.getElementById("board_thread");
    //form.encoding = "application/x-www-form-urlencoded";
	
	// 중요 변수 설정
	var userno = escape(encodeURIComponent($("#detail_userno").val()));
	var btitle = escape(encodeURIComponent($("#detail_btitle").val()));
	var bcontent = escape(encodeURIComponent($("#detail_bcontent").val()));
	
	$.ajax({
        url: 'Board.ho?command='+command+'&userno='+userno+'&btitle='+btitle+'&bcontent='+bcontent,
        type: 'POST',
        data: data,
        cache: false,
        dataType: 'text',
        processData: false, 
        contentType: false, 
        success: function(msg) {
		    if(msg>0){
		        window.location.href="Board.ho?command=reflash_board_list";
		    } else {
		        window.location.href="Board.ho?command=reflash_board_list";
		    }	 		                

        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.log('ERRORS: ' + textStatus);
        }
	});
}