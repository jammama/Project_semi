<%@page import="com.nomwork.user.dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Nomwork - 외부 로그인 회원가입</title>

	<!-- Bootstrap core CSS-->
    <link href="resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="resources/css/sb-admin.css" rel="stylesheet">
    
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script type="text/javascript">
    
    $(function(){
    	var useremail = '${udto.useremail}';
    	var username = '${udto.username}';
    	
    	if(useremail == "undefined"){
    		useremail = "";
    	}
    	if(username == "undefined"){
    		username = "";
    	}
    	
    	$("#inputEmail").val(useremail);
    	$("#Name").val(username);
    });
    
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
    
    function regiCheck() {
		var check = true;
		var inputPassword = $("#inputPassword").val();
		var confirmPassword = $("#confirmPassword").val();
		var name = $("#Name").val();
		var email = $("#inputEmail").val();
		
		if(name==""){
			$("#Name").css("background-color","#ECB2AC");
    	 	$(".namealert").html('이름을 입력해주세요')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
    	 	check = false;
		}
		if(!$("input:radio[name='usergender']").is(":checked")){
			$("#gender").css("background-color","#ECB2AC");
    	 	check = false;
		}
		if(inputPassword != confirmPassword) {
			$("#confirmPassword").css("background-color","#ECB2AC");
    	 	$(".pwalert").html('비밀번호가 일치하지 않습니다')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
		    check = false;
		}
		if(inputPassword == ""){
			$("#inputPassword").css("background-color","#ECB2AC");
			$("#confirmPassword").css("background-color","#ECB2AC");
    	 	$(".pwalert").html('비밀번호를 입력해주세요')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
			check = false;
		}
		if(email.indexOf('@') == -1){
			$("#inputEmail").css("background-color","#ECB2AC");
    	 	$("#emailoverlap").html('이메일 형식이 아닙니다')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
			check = false;
		}
		if(email == ""){
			$("#inputEmail").css("background-color","#ECB2AC");
    	 	$("#emailoverlap").html('이메일을입력해주세요')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
			check = false;
		}
		
		//이메일 중복 검사
		$.ajax({
	      	  url : "User.ho?command=check_email_overlaped&useremail="+$("#inputEmail").val(),
	        	type: "GET",		
	        	success : function(data){
	            	 if(data == 1){
	            		$("#inputEmail").css("background-color","#ECB2AC");
	            	 	$("#emailoverlap").html('중복된 이메일 계정이 존재합니다')
	            		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
	            	 	check = false;
	         	    }
	       		}
	   		});
		
		if(check){
			$("#registerForm").submit();
		}
	}
    
  //양식 에러 알림 초기화
    function condition_check(){
     	
    	if($("#Name").val()!=""){
    		$("#Name").css("background-color","white");
    		$(".namealert").html('');
    	}
    	
    	if($("input:radio[name='usergender']").is(":checked")){
    	 	$(".genderalert").html('');
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
  
    </script>
	<style type="text/css">
    
    #gender{
			width: 46.9%;
			height: 50px;
			border: 1px solid #CED4DA;
			border-radius: 0.25rem;
			margin-left: 4px;
			margin-right: 4px;
		}
		
    #woman{
			float: left;
			width: 50%;
			line-height: 50px;
			cursor: pointer; 
			text-align: center;
			border-right: 1px solid #CED4DA;
			border-radius: 0rem;
			
		}
		
	#man{
			float: right;
			width: 50%;
			line-height: 50px;
			cursor: pointer; 
			text-align: center;
			border-radius: 0rem;
		}
	div > label > input[type=radio] {
			visibility: hidden;
		}
		
	div > label > span {
			margin-right: 20px;
			color: #495057;
		}	
		
	</style>
</head>
<%
	UserDto udto = (UserDto) session.getAttribute("udto");
%>
<body class="bg-dark">
	
	<div class="container">
      	<div class="card card-register mx-auto mt-5">
        	<div class="card-header">회원가입 - 빈칸을 입력해주세요 :)</div>
        	<div class="card-body">
          	<form id="registerForm" action="User.ho" method="get">
          		<input type="hidden" name="command" value="insert_user"/>
          		<input type="hidden" name="userno" value="${udto.userno}"/>
          		<input type="hidden" name="userurl" value="${udto.userurl}"/>
          		
          		
            	<div class="form-group">
              	<div class="form-row">
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="text" name="username" id="Name" class="form-control" placeholder="name" required="required" autofocus="autofocus" oninput="condition_check()">
                    	<label for="Name">이름</label>
                    	<div class="namealert"></div>
                  	</div>
                	</div>
                	
                  	<div id="gender" onclick="condition_check()">
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
                	<input type="email" name="useremail" id="inputEmail" class="form-control" placeholder="Email address" required="required" oninput="condition_check()">
                	<div id="emailoverlap"></div>
                	<label for="inputEmail">이메일 주소</label>
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
                  	</div>
                	</div>
              	</div>
              	<div class="pwalert"></div>
            	</div>
            	<input id="btn_register" class="btn btn-primary btn-block" type="button" onclick="regiCheck()" value="다음" />
          	</form>
        	</div>
      	 </div>
    	</div>

    <!-- Bootstrap core JavaScript-->
    <script src="resources/vendor/jquery/jquery.min.js"></script>
    <script src="resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="resources/vendor/jquery-easing/jquery.easing.min.js"></script>

</body>
</html>