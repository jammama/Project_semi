$(function() {
	/* thread 숨김/보임 수정3 */
	$(".thread-wrapper").hide();
	$(".inside-wrapper").on('click', '.chat',function() {
						$(".thread-wrapper").toggle();
						$(".reply-dropmenu").hide();
						var tno = $(this).find(".tno").val();

						$.ajax({
									url : "Text.ho?command=select_text_list&tno="
											+ tno,
									dataType : "text",
									success : function(data) {
										var jobj = JSON.parse(data);
										$(".thread-board > .profile-pic > img")
												.attr("src",
														jobj.tdto[0].userurl)
										$(".board-writer").html(
												jobj.tdto[0].username);
										$(".board-content").html(
												jobj.tdto[0].tcontent);
										$(".reply_tno").remove();
										$(".board-content").append(
												"<input type='hidden' class='reply_tno' value='"
														+ tno + "'/>")
										$(".board-reply").remove();
										var i;
										for (i = 1; i < jobj.tdto.length; i++) {
											$(".board-insertReply")
													.before(
															"<div class='board-reply'>"
																	+ "<div class='profile-pic'>"
																	+ "<img src='"
																	+ jobj.tdto[i].userurl
																	+ "'>"
																	+ "</div>"
																	+ "<div class='reply-context'>"
																	+ "<div class='reply-writer'>"
																	+ jobj.tdto[i].username
																	+ "</div>"
																	+ "<div class='reply-context-body'>"
																	+ jobj.tdto[i].tcontent
																	+ "</div>"
																	+ "</div>"
																	+ "</div>")
										}

									},
									error : function(request, error) {
										alert(error);
									}
								});
					});

	/* 프로필 드롭업 보임/숨김 */
	$(".topprofile").click(function() {
		$(".inside-cover").show();
		$(".top-dropmenu").show();
	});
	$(".topside-4").click(function() {
		$(".inside-cover").show();
		$(".top-dropmenu").show();
	});

	/* 메인창 드롭업 보임/숨김 */
	$(".input-dropbtn").click(function() {
		$(".inside-cover").show()
		$(".input-dropmenu").show();
	})
	/* 답글창 드롭업 보임/숨김 */
	$(".reply-dropbtn").click(function() {
		$(".inside-cover").show();
		$(".reply-dropmenu").show();
	});
	/* insert-취소버든 */
	$(".attach-cancel").click(function() {
		$(".insert-link-text").hide();
		$(".inside-cover").hide();
		$(".insert-video").hide();
		$(".insert-map").hide();
		$(".insert-file").hide();
	})
	/* 클릭방지커버 클릭-전체 닫힘 */
	$(".inside-cover").click(function() {
		$(".insert-link-text").hide();
		$(".input-dropmenu").hide();
		$(".reply-dropmenu").hide();
		$(".inside-cover").hide();
		$(".insert-video").hide();
		$(".insert-map").hide();
		$(".insert-file").hide();
		$(".top-dropmenu").hide();
	})
	function addRe() {
		$(".attach-submit").addClass("attach-submit-re");
		$(".attach-submit-re").removeClass("attach-submit");
		$(".inside-cover").show();
		$(".reply-dropmenu").hide();
	}
	function removeRe() {
		$(".attach-submit-re").addClass("attach-submit");
		$(".attach-submit").removeClass("attach-submit-re");
		$(".inside-cover").show();
		$(".input-dropmenu").hide();
	}
	/* 메인-링크가져오기 보임 */
	$(".open-link").click(function() {
		$(".insert-link-text").show();
		removeRe();
	})
	/* 답글-링크가져오기 보임 */
	$(".open-link-re").click(function() {
		$(".insert-link-text").show();
		addRe()
	})
	/* 동영상 가져오기 */
	$(".open-video").click(function() {
		$(".insert-video").show();
		removeRe();
	})
	$(".open-video-re").click(function() {
		$(".insert-video").show();
		addRe();
	})
	/* 지도 가져오기 */
	$(".open-map").click(function() {
		$(".insert-map").show();
		removeRe();
	})
	$(".open-map-re").click(function() {
		$(".insert-map").show();
		addRe();
	})
	/* 파일 가져오기 */
	$(".open-file").click(function() {
		$(".insert-file").show();
		removeRe();
	})
	$(".open-file-re").click(function() {
		$(".insert-file").show();
		addRe();
	})
	/* 링크가져오기-클릭구분 */
	function texttoinsert() {
		var txt = $(".link-output").text();
		if (txt.length > 2000) {
			alert("채팅창에 입력할 수 있는 글자는 최대 2000바이트를 넘을 수 없습니다");
		} else if (txt.length < 2000) {
			$(".link-output").html("");
			$(".input-text").html(txt);
			$(".insert-link-text").hide();
			$(".inside-cover").hide();
		}
	}
	$(".insert-link-text").on('click', '.attach-submit-re', function() {
		texttoinsert();
	})
	$(".insert-link-text").on('click', '.attach-submit', function() {
		texttoinsert();
	})
	/* 링크로 텍스트 가져오기 */
	$(".insert-link-text").on('click', '.link-ok', function() {
		var txt = $(".link-input").text();
		$.ajax({
			url : "Text.ho?command=text_link&url=" + txt,
			dataType : "text",
			success : function(msg) {
				$(".link-input").text("");
				$(".link-output").html(msg);
			},
			error : function(jqXHR, textStatus, error) {
				alert(error);
				console.log('ERRORS: ' + textStatus);
			}
		});
	});
	/* 지도관련 */
	$(".map-input").on('keydown', function(event) {
		// 엔터키가 눌린 경우, 주소 검색
		if (event.keyCode == 13) {
			searchButton();
			$('.map-input').blur();
		}
	});
	
	/*그림판 열기*/
	$(".open-canvas").click(function(){
		//window.open('canvas.jsp'); //새탭으로그림창
		var popUrl = "canvas.jsp";
		var popOption = "width=850,height=630,resizable=no,scrollbars=no,status=no;";
		window.open(popUrl,"",popOption); //팝업창열어버리기
	})
	
	$(".insert-link-text").on('click','.attach-submit-re',function(){
		var txt = $(".link-output").text();
		$(".link-output").val("");
		$(".reply-input").html(txt);
	})
	$(".insert-link-text").on('click','.attach-submit',function(){
		var txt = $(".link-output").text();
		$(".link-output").val("");
		$(".inputtext").html(txt);
	})
	
	/*게시판과연동관련*/
	$(".thread-board").on('click','.to_board_btn', function() {
		var textno = $(".reply_tno").val();
		alert(textno);

		$.ajax({
			url : "Text.ho?command=chattoboard&textno="+textno,
			dataType:"text",
			success: function(msg){
				alert("게시판에 추가했습니다.");
			},error: function(jqXHR, textStatus, error) {
				alert(error);
	            console.log('ERRORS: ' + textStatus);
	        }
		});
	})

});