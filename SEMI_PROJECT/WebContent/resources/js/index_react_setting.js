//뒤로가기 방지
history.pushState(null, null, location.href);
window.onpopstate = function(event) {
	history.go(1);
};

$(document).ready(
		function() {

			// 스크롤내려도 상단바 메뉴 고정되도록 하는 기능
			var jbOffset = $('.topwrap').offset();
			$(window).scroll(function() {
				if ($(document).scrollTop() > jbOffset.top) {
					$('.topwrap').addClass('jbFixed');
				} else {
					$('.topwrap').removeClass('jbFixed');
				}
			});

			// 저장된 쿠키값을 가져와서 email 칸에 넣어준다. 없으면 공백으로 들어감.
			var userInputId = getCookie("userInputId");
			$("input[name='useremail']").val(userInputId);

			if ($("input[name='useremail']").val() != "") { // 그 전에 ID를 저장해서 처음
				// 페이지 로딩 시, 입력 칸에
				// 저장된 ID가 표시된 상태라면,
				$("#emailSaveCheck").attr("checked", true); // ID 저장하기를 체크 상태로
				// 두기.
			}

			$("#emailSaveCheck").change(function() { // 체크박스에 변화가 있다면,
				if ($("#emailSaveCheck").is(":checked")) { // ID 저장하기 체크했을 때,
					var userInputId = $("input[name='useremail']").val();
					setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
				} else { // ID 저장하기 체크 해제 시,
					deleteCookie("userInputId");
				}
			});

			// ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
			$("input[name='useremail']").keyup(function() { // ID 입력 칸에 ID를 입력할
				// 때,
				if ($("#emailSaveCheck").is(":checked")) { // ID 저장하기를 체크한
					// 상태라면,
					var userInputId = $("input[name='useremail']").val();
					setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
				}
			});

			// 카카오 로그인 기능

			// 사용할 앱의 JavaScript 키를 설정해 주세요.
			Kakao.init('7c0b18940751bb33c42de38319530d1c');

			// 카카오 로그인 버튼을 생성합니다.
			Kakao.Auth.createLoginButton({
				container : '#kakao-login-btn',
				success : function(authObj) {

					// 로그인 성공시, API를 호출합니다.
					Kakao.API.request({
						url : '/v2/user/me',
						success : function(res) {
							var userno = res.id;
							var useremail = res.kakao_account.email;
							var username = res.properties.nickname;
							var userurl = res.properties.thumbnail_image;

							location.href = "User.ho?"
									+ "command=regist_user_by_api&userno="
									+ userno + "&useremail=" + useremail
									+ "&username=" + username + "&userurl="
									+ userurl;

						},
						fail : function(error) {
							alert(JSON.stringify(error));
						}
					});
				},
				fail : function(err) {
					alert(JSON.stringify(err));
				}
			});
			// 카카오 로그인 기능 끝

		});

// 쿠키를 저장
function setCookie(cookieName, value, exdays) {
	var exdate = new Date();
	exdate.setDate(exdate.getDate() + exdays);
	var cookieValue = escape(value)
			+ ((exdays == null) ? "" : "; expires=" + exdate.toGMTString());
	document.cookie = cookieName + "=" + cookieValue;
}
// 쿠키를 삭제
function deleteCookie(cookieName) {
	var expireDate = new Date();
	expireDate.setDate(expireDate.getDate() - 1);
	document.cookie = cookieName + "= " + "; expires="
			+ expireDate.toGMTString();
}
// 쿠키를 불러오기
function getCookie(cookieName) {
	cookieName = cookieName + '=';
	var cookieData = document.cookie;
	var start = cookieData.indexOf(cookieName);
	var cookieValue = '';
	if (start != -1) {
		start += cookieName.length;
		var end = cookieData.indexOf(';', start);
		if (end == -1)
			end = cookieData.length;
		cookieValue = cookieData.substring(start, end);
	}
	return unescape(cookieValue);
}

// 회원가입시 폼의 양식을 검사
function regiCheck() {
	var check = true;
	var inputPassword = $("#inputPassword").val();
	var confirmPassword = $("#confirmPassword").val();
	var name = $("#Name").val();
	var email = $("#inputEmail").val();

	if (name == "") {
		$("#Name").css("background-color", "#ECB2AC");
		$(".namealert").html('이름을 입력해주세요').css('color', 'red').css('font-size',
				'14px').css('margin-left', '8px').css('font-weight', 'bold');
		check = false;
	}
	if (!$("input:radio[name='usergender']").is(":checked")) {
		$("#gender").css("background-color", "#ECB2AC");
		check = false;
	}
	if (inputPassword != confirmPassword) {
		$("#confirmPassword").css("background-color", "#ECB2AC");
		$(".pwalert").html('비밀번호가 일치하지 않습니다').css('color', 'red').css(
				'font-size', '14px').css('margin-left', '8px').css(
				'font-weight', 'bold');
		check = false;
	}
	if (inputPassword == "") {
		$("#inputPassword").css("background-color", "#ECB2AC");
		$("#confirmPassword").css("background-color", "#ECB2AC");
		$(".pwalert").html('비밀번호를 입력해주세요').css('color', 'red').css('font-size',
				'14px').css('margin-left', '8px').css('font-weight', 'bold');
		check = false;
	}
	if (email.indexOf('@') == -1) {
		$("#inputEmail").css("background-color", "#ECB2AC");
		$("#emailoverlap").html('이메일 형식이 아닙니다').css('color', 'red').css(
				'font-size', '14px').css('margin-left', '8px').css(
				'font-weight', 'bold');
		check = false;
	}
	if (email == "") {
		$("#inputEmail").css("background-color", "#ECB2AC");
		$("#emailoverlap").html('이메일을입력해주세요').css('color', 'red').css(
				'font-size', '14px').css('margin-left', '8px').css(
				'font-weight', 'bold');
		check = false;
	}

	// 이메일 중복 검사
	$.ajax({
		url : "User.ho?command=check_email_overlaped&useremail="
				+ $("#inputEmail").val(),
		type : "GET",
		async : false,
		success : function(data) {
			if (data == 1) {
				$("#inputEmail").css("background-color", "#ECB2AC");
				$("#emailoverlap").html('중복된 이메일 계정이 존재합니다')
						.css('color', 'red').css('font-size', '14px').css(
								'margin-left', '8px')
						.css('font-weight', 'bold');
				check = false;
			}
		}
	});

	if (check) {
		$("#registerForm").submit();
	}
}

// 회원가입 폼 입력시 조건에 따른 색 변화와 알림
function condition_check() {

	if ($("#Name").val() != "") {
		$("#Name").css("background-color", "#EBFBD0");
		$(".namealert").html('');
	}

	if ($("#inputEmail").val() != "") {
		$("#inputEmail").css("background-color", "#EBFBD0");
		$("#emailoverlap").html('');
	}

	if ($("#inputPassword").val() != "") {
		$("#inputPassword").css("background-color", "#EBFBD0");
		$(".pwalert").html('');
	}

	if ($("#confirmPassword").val() != "") {
		$("#confirmPassword").css("background-color", "#EBFBD0");
		$(".pwalert").html('');
	}

}
// 성별을 선택하면 색이 표시되는 기능
function genderChk() {
	var chk_radio = document.getElementsByClassName('chk');

	for (var i = 0; i < chk_radio.length; i++) {
		if (chk_radio[i].checked == true) {
			chk_radio[i].parentNode.style.backgroundColor = "#EBFBD0";
			$(".genderalert").html('');
		} else if (chk_radio[i].checked == false) {
			chk_radio[i].parentNode.style.backgroundColor = "white";
		}
	}
}

// 구글 로그인 기능
function onSignIn(googleUser) {
	var profile = googleUser.getBasicProfile();
	var userno = profile.getId();
	var useremail = profile.getEmail();
	var username = profile.getName();
	var userurl = profile.getImageUrl();

	location.href = "User.ho?command=regist_user_by_api&userno=" + userno
			+ "&useremail=" + useremail + "&username=" + username + "&userurl="
			+ userurl;
}
