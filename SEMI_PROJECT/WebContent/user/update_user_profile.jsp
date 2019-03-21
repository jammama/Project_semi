<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>
<head>
<meta charset="UTF-8">
<link rel="shortcut icon" href="../resources/image/favicon.ico"/>
<title>Nomwork - 회원정보 수정</title>
	
	<!-- Bootstrap core CSS-->
    <link href="../resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="../resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="../resources/css/sb-admin.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../resources/css/userinfo.css">
   
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script type="text/javascript">

$(function(){
	
	//처음 유저 정보 들어갔을 때 지정된 성별로 선택되는 기능
	var gender = $("#gender").val();
	var chk_radio = $(".chk");
	if(gender == 'W'){
		chk_radio[0].parentNode.style.backgroundColor="#EBFBD0";
		chk_radio.eq(0).attr('checked', true);
		
	}else if(gender == 'M'){
		chk_radio[1].parentNode.style.backgroundColor="#EBFBD0";
		chk_radio.eq(1).attr('checked', true);
	}
	
	//프로필 사진위에 마우스를 올리면 이벤트 발생
	$(".profile").hover(function() {
		   $(this).css("opacity", 0.7);
		}, function(){
			$(this).css("opacity", 1);
		});
	
	$(".profile").click(function(e){
		$(".profile_dropmenu").show();
		e.stopPropagation();
	});
	//프로필 변경 팝업 다른곳 클릭 시, 사라지게 함
	$(document).click(function(){
		$(".profile_dropmenu").hide();
	});
});

//회원 정보 수정 폼의 양식을 검사
function info_Check() {
	var check = true;
	var inputPassword = $("#inputPassword").val();
	var confirmPassword = $("#confirmPassword").val();
	var name = $("#Name").val();
	
	if(name==""){
		$("#Name").css("background-color","#ECB2AC");
		$(".namealert").show();
	 	$(".namealert").html('이름을 입력해주세요')
		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
	 	check = false;
	}
	
	if(inputPassword != confirmPassword) {
		$("#confirmPassword").css("background-color","#ECB2AC");
		$(".pwalert").show();
	 	$(".pwalert").html('비밀번호가 일치하지 않습니다')
		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
	    check = false;
	}
	if(inputPassword == ""){
		$("#inputPassword").css("background-color","#ECB2AC");
		$("#confirmPassword").css("background-color","#ECB2AC");
		$(".pwalert").show();
	 	$(".pwalert").html('비밀번호를 입력해주세요')
		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
		check = false;
	}
	
	if(check){
		$("#info_change_form").submit();
		sendToServer(dataURI);
		
	}
}

//양식 에러 알림 초기화
function condition_check(){
 	
	if($("#Name").val()!=""){
		$("#Name").css("background-color","white");
		$(".namealert").html('');
	}
	
	if($("#inputPassword").val()!=""){
		$("#inputPassword").css("background-color","white");
		$(".pwalert").html('');
	}
	
	if($("#confirmPassword").val()!=""){
		$("#confirmPassword").css("background-color","white");
		$(".pwalert").html('');
	}
	
}

function condition_check_email(){
	if($("#change_inputEmail").val()!=""){
		$("#change_inputEmail").css("background-color","white");
		$(".email_alert_1").html('');
		$(".email_alert_1").hide();
	}
}



//성별 선택시 색 선택
function genderChk(){
	var chk_radio = document.getElementsByClassName('chk');

	for(var i=0;i<chk_radio.length;i++){
		if(chk_radio[i].checked == true){ 
			chk_radio[i].parentNode.style.backgroundColor="#EBFBD0";
		}else if(chk_radio[i].checked == false){
			chk_radio[i].parentNode.style.backgroundColor="white";
		}
	}
}



var dataURI = "";
//프로필 이미지로 설정할 파일을 선택시, 미리 보여주고 편집하는 기능
function profile_update(){
	
	var file = document.querySelector('#getfile');
	
	    var fileList = file.files ;
	    
	    // 읽기
	    var reader = new FileReader();
	    reader.readAsDataURL(fileList[0]);

	    //로드 한 후
	    reader.onload = function(){
	        
	        //썸네일 이미지 생성
	        var tempImage = new Image(); //drawImage 메서드에 넣기 위해 이미지 객체화
	        tempImage.src = reader.result; //data-uri를 이미지 객체에 주입
	        tempImage.onload = function() {
	            //리사이즈를 위해 캔버스 객체 생성
	            var canvas = document.createElement('canvas'); 
				var canvasContext = canvas.getContext("2d");
	            //캔버스 크기 설정
	            canvas.width = 500; //가로 100px
	            canvas.height = 500; //세로 100px
	            
	            //이미지를 캔버스에 그리기
	            canvasContext.drawImage(this, 0, 0, 500, 500);
	            //캔버스에 그린 이미지를 다시 data-uri 형태로 변환
	            dataURI = canvas.toDataURL("image/png");
	            
	            //썸네일 이미지 보여주기
	            $("#thumbnail").prop("src", dataURI);
	    }; 
	}; 
}

//프로필 변경창에서 확인을 누르면 메인화면에 미리보기되는 기능
function confirm_profile(){
	if(dataURI == ""){
		alert("이미지를 선택해주세요");
		return false;
	}
	$(".profile").prop("src", dataURI);
	$(".profile_wrap").hide();
	$(".inside-div").hide();
	
	var userno = $("#userno").val();
	$("#userurl").val("resources/image/profile/"+userno+".png");
	
}
//캔버스 창을 초기화 하는 기능
function cancle(){
	$("#thumbnail").prop("src", "");
	dataURI="";
	$(".profile_wrap").hide();
	$(".inside-div").hide();

}

//캔버스 객체를 서버에 이미지로 저장하는 기능
function sendToServer(image){
	var userno = $("#userno").val();
	$.ajax({ 
	    type: "POST", 
	    url: "../User.ho?command=profile_save_server&userno="+userno, 
	    data: image,  
	    success: function(){      
	    }, 
	    error: function(){ 
	    } 
	}); 
} 


//프로필 사진 변경 창 나타나기
function profile_pop(){
	$(".profile_wrap").show();
	$(".profile_dropmenu").hide();
	$(".inside-div").show();
}

//프로필 사진 기본이미지로 바꾸기
function profile_basic(){
	$("#userurl").val("resources/image/profile/basic.jpg");
	$(".profile").prop("src","../resources/image/profile/basic.jpg");
	$(".profile_dropmenu").hide();
}

//이메일 변경하기 버튼 이벤트
function useremail_change_1(){
	$("#email_change").hide();
	$("#email_change_bf1").show();
	$("#email_change_bf2").show();
}

var chk_num = 0;
//이메일 인증하기 버튼 이벤트
function useremail_change_2(){
	var overlap_ck = 0;
	$.ajax({
		url : "../User.ho?command=emailOverlap&useremail="+$("#change_inputEmail").val()
		,type: "GET"
		,async: false
		,success : function(data){
			if(data == 1){
				overlap_ck = 1;
	        }
	    }
	});

	//수정할 이메일을 입력하지않을 때
	if($("#change_inputEmail").val() == ""){
		$("#change_inputEmail").css("background-color","#ECB2AC");
		$(".email_alert_1").show();
		$(".email_alert_1").html('이메일을 입력해주세요')
		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
		return false;
		
	}//수정할 이메일이 올바른 형식이 아닐 때
	else if($("#change_inputEmail").val().indexOf('@') == -1){
		$("#change_inputEmail").css("background-color","#ECB2AC");
		$(".email_alert_1").show();
		$(".email_alert_1").html('이메일 형식이 아닙니다')
		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
		return false;
	}//이메일 중복 검사
	else if(overlap_ck == 1){
		$("#change_inputEmail").css("background-color","#ECB2AC");
		$(".email_alert_1").show();
		$(".email_alert_1").html('중복된 이메일이 존재합니다')
		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
		return false;
	}
	
	$("#change_inputEmail").css("background-color","#EBFBD0");
	$("#email_change_bf2").hide();
	$("#change_inputEmail").prop("readonly", true);
	$("#Email_check_cf").show();
	$("#email_change_bf3").show();
	$("#Email_check_num").val("");
	
	$.ajax({
		url : "../User.ho?command=change_user_email&useremail="+$("#change_inputEmail").val()
		,type: "GET"
		,async: false
		,success : function(data){
			chk_num = data;
	    }
	});
}

//이메일 마지막 확인 버튼 이벤트
function useremail_change_3(){
	
	if(chk_num != $("#Email_check_num").val()){
		$("#Email_check_num").css("background-color","#ECB2AC");
		$(".email_alert_2").show();
		$(".email_alert_2").html('인증번호를 다시 확인해주세요')
		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
		return false;
	}else if(chk_num == $("#Email_check_num").val()){
		$("#change_inputEmail").css("background-color","white");
		$("#email_change_bf3").hide();
		$("#email_change").show();
		$("#email_change_bf1").hide();
		$("#Email_check_cf").hide();
		$("#change_inputEmail").prop("readonly", false);
		$("#inputEmail").val($("#change_inputEmail").val());
		$("#change_inputEmail").val("");
		$("#Email_check_num").css("background-color","white");
		$("#Email_check_num").html('');
		$(".email_alert_2").hide();
		
	}
}

//회원 탈퇴 기능
function drop_user(){
	var answer = confirm("계정 정보 및 프로젝트가 초기화 됩니다.\n탈퇴하시겠습니까?");
	var userno = $("#userno").val();
		if(answer == true){
			location.href="../User.ho?command=drop_user&userno="+userno;
			
		}
}

</script>
</head>
<body>
<%
String userno = request.getParameter("userno");
String username = request.getParameter("username");
String useremail = request.getParameter("useremail");
String usergender = request.getParameter("usergender");
String userpw = request.getParameter("userpw");
String userurl = request.getParameter("userurl");
String urlpath = null;
%>
	<!-- 프로필 사진 변경 창이 뜨면 나타나는 투명창 -->
	<div class="inside-div">
	</div>
	<!-- 프로필 사진 변경 클릭시 뜨는 창 -->
		<div class="profile_wrap">
		<div class="preview">
			<img alt="" src="../resources/image/profile/preview.png">
		</div>
		
		<div class="profile_image">
    		<img id="thumbnail" src="" width="500">
		</div>
		
		<div class="profile_button">
			<form>
			<div class="filebox">
  				<label for="getfile">프로필 사진 업로드</label>
  				<input type="file" id="getfile" accept="image/*" onchange="profile_update()">
  				
  				
  				<label for="save">저장</label>
  				<input type="button" id="save" onclick="confirm_profile()">
  				
  				<label for="reset">취소</label>
  				<input type="reset" id="reset" onclick="cancle()">
  				
			</div>
			</form>
		</div>
	</div>
	
	<!-- 프로필 사진 변경 클릭시 뜨는 창 끝 -->
	
	
	<input type="hidden" id="gender" value="<%=usergender%>"/>
	<div class="container">
      	<div class="card card-register mx-auto mt-5">
      		<div class="card-header">회원 정보 수정</div>
      		
      		<%//이미지가 서버 폴더에 저장되있는 경우 경로를 해결
      		if(!userurl.contains("http")){
      			urlpath = "../"+userurl;
      		}else{
      			urlpath = userurl;
      		}
      		%>
      		
        	<div class="card-header">
        	<img class="profile" src="<%=urlpath%>">
        	<div class="profile_dropmenu">
           		<div class="" onclick="profile_pop()">프로필 사진 변경</div>
				<div class="" onclick="profile_basic()">기본 이미지로 변경</div>
			</div>
        	</div>
        	<div class="card-body">
          	<form id="info_change_form" action="../User.ho" method="get">
          		<input type="hidden" name="command" value="update_userinfo"/>
          		<input type="hidden" name="userno" id="userno" value="<%=userno%>"/>
          		<input type="hidden" name="userurl" id="userurl" value="<%=userurl%>">
          		
            	<div class="form-group">
              	<div class="form-row">
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="text" name="username" value="<%=username%>" id="Name" class="form-control" placeholder="name" required="required" autofocus="autofocus" oninput="condition_check()">
                    	<label for="Name">이름</label>
                    	<div class="namealert" style="display: none;"></div>
                  	</div>
                	</div>
                	
                  	<div id="gender">
                    		<label id="woman">
							<input type="radio" class="chk" name="usergender" value="W" onclick="genderChk()">
							<span>여성</span>
							</label>
		
							<label id="man">
							<input type="radio" class="chk" name="usergender" value="M" onclick="genderChk()">
							<span>남성</span>
							</label>
                  	</div>
                    	
              	</div>
            	</div>
            	<div class="form-group">
              	<div class="form-label-group">
                	<input type="email" name="useremail" value="<%=useremail%>" id="inputEmail" class="form-control" placeholder="Email address" required="required" readonly="readonly">
                	<label for="inputEmail">이메일 주소</label>
              	</div>
            	</div>
            	
            	<div class="form-group" class="alert_email">
            		<input type="button" class="button_userinfo" id="email_change" value="이메일 변경" onclick="useremail_change_1()"/>
              	<div class="form-row">
              	
                	<div class="col-md-6">
                  	<div class="form-label-group" id="email_change_bf1" style="display: none; text-align: center;">
                    	<input type="email" name="change_inputEmail" id="change_inputEmail" class="form-control" placeholder="Email address" required="required" oninput="condition_check_email()">
                		<label style="text-align: left;" for="change_inputEmail">수정할 이메일 주소</label>
                		<span class="email_alert_1"></span>
                  	</div>
                	</div>
                	
                	<div class="col-md-6">
                  		<input type="button" class="button_userinfo" id="email_change_bf2" value="인증하기" style="display: none;" onclick="useremail_change_2()"/>
                  		
                  		<div class="form-label-group" id="Email_check_cf" style="display: none; text-align: center;">
                    	<input type="text" name="Email_check_num" id="Email_check_num" class="form-control" placeholder="number" required="required"/>
                		<label style="text-align: left;" for="Email_check_num">인증번호</label>
                		<span class="email_alert_2"></span>
                  		</div>
                    </div>
                    <input type="button" class="button_userinfo" id="email_change_bf3" value="확인" onclick="useremail_change_3()" style="display: none; margin: 4px"/>
              	</div>
            	</div>
            	
            	
            	<div class="form-group">
              	<div class="form-row">
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="password" name="userpw" id="inputPassword" class="form-control" placeholder="Password" required="required" oninput="condition_check()">
                    	<label for="inputPassword">비밀번호</label>
                  	</div>
                	</div>
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="password" id="confirmPassword" class="form-control" placeholder="Confirm password" required="required" oninput="condition_check()">
                    	<label for="confirmPassword">비밀번호 확인</label>
                    	<div class="pwalert" style="display: none;"></div>
                  	</div>
                	</div>
              	</div>
            	</div>
            	<input id="btn_register" class="btn btn-primary btn-block" type="button" onclick="info_Check()" value="회원정보 수정" />
          		</form>
          		<div class="text-center">
            	<a class="d-block small" style="margin-top: 8px; cursor: pointer; color: #007bff" onclick="drop_user()">회원탈퇴</a>
          		</div>
        		</div>
      		</div>
    	</div>


	<!-- Bootstrap core JavaScript-->
    <script src="../resources/vendor/jquery/jquery.min.js"></script>
    <script src="../resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="../resources/vendor/jquery-easing/jquery.easing.min.js"></script>
</body>
</html>