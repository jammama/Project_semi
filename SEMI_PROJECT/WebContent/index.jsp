<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
    
    <!-- 구글아이디로 로그인에 필요한 meta -->
    <meta name="google-signin-scope" content="profile email">
	<meta name="google-signin-client_id" content="317778192554-jea133gf9tpn217khalf73svqbndfelo.apps.googleusercontent.com">

    <title>Nomwork에 오신걸 환영합니다</title>
	<link rel="shortcut icon" href="resources/image/favicon.ico"/>
	
    <!-- Bootstrap core CSS-->
    <link href="resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="resources/css/sb-admin.css" rel="stylesheet">

	<!-- 인덱스 페이지 CSS 로드 -->
    <link href="resources/css/index_setting.css" rel="stylesheet">
	
	<!-- JQUERY 스크리로드 -->
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	
	<!-- 카카오 로그인 관련 스크립트 로드 -->
	<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
	
	<!-- 구글 로그인 관련 스크립트 로드 -->
	<script src="https://apis.google.com/js/platform.js" async defer></script>
	
		<!-- 인덱스 주요 스크립트 로드 -->
	<script type="text/javascript" src="resources/js/index_react_setting.js"></script>

  </head>
<body>
	<div class="topwrap">
		<img src="resources/image/main/Nomwork_logo.png">
		<ul>
			<li style="border-left: none;">제품소개</li>
		</ul>
	</div>
	
	<!-- inside_wrapper start -->
	<div class="inside_wrapper">
	<div class="leftwrap">
		<a><img src="resources/image/main/mainimage1.png"></a>
	</div>
	
	
	
	<div class="rightwrap">
	
		<div class="container">
     	 <div class="card card-login mx-auto mt-5">
        	<div class="card-header">로그인</div>
      	  <div class="card-body">
       	  	<form action="User.ho" method="get">
       	  	<input type="hidden" name="command" value="login"/>
           	 <div class="form-group">
            	  <div class="form-label-group">
            	    <input type="email" name="useremail" id="inputEmailin" class="form-control" placeholder="Email addressin" required="required" autofocus="autofocus">
            	    <label for="inputEmailin">이메일 주소</label>
            	  </div>
            </div>
           	 <div class="form-group">
            	  <div class="form-label-group">
             	   <input type="password" name="userpw" id="inputPasswordin" class="form-control" placeholder="Passwordin" required="required">
            	   <label for="inputPasswordin">비밀번호</label>
              	</div>
           	 </div>
           	 
           	  <div class="form-group">
           	  <div class="form-row">
           	  
           		<!-- 카카오톡 / 구글 로그인 버튼 -->
           	 	<div style="width: 50%;">
           	 		<span id="kakao-login-btn"></span>
           	 	</div>
           	 	<div style="width: 50%;">
           	 		<span class="g-signin2" data-width="180" data-height="50" data-onsuccess="onSignIn"></span>
           	 	</div>
             	
             	
             </div>
             </div>
             
       	     <div class="form-group">
             	 <div class="checkbox">
               		 <label>
                  	<input type="checkbox" id="emailSaveCheck" value="remember-me">
                  	Remember Email
                	</label>
              	</div>
            	</div>
            	<input class="btn btn-primary btn-block" type="submit" value="로그인"/>
          	</form>
          	<div class="text-center">
            	<a class="d-block small" href="user/forgot_password.jsp" style="margin-top: 8px;">비밀번호가 생각이 안나시나요?</a>
          	</div>
        	</div>
      	 </div>
    	</div>


    	<div class="container">
      	<div class="card card-register mx-auto mt-5">
        	<div class="card-header">회원가입</div>
        	<div class="card-body">
          	<form id="registerForm" action="User.ho" method="get">
          		<input type="hidden" name="command" value="regist_user"/>
          		<input type="hidden" id="overlap" value="0"/>
            	<div class="form-group">
              	<div class="form-row">
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="text" name="username" id="Name" class="form-control" placeholder="name" required="required" autofocus="autofocus" oninput="condition_check()">
                    	<div class="namealert"></div>
                    	<label for="Name">이름</label>
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
							<div class="genderalert"></div>
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
	</div>
	<!-- right_wrapper end -->
	</div>
	<!-- inside_wrapper end -->
	
	
	<div class="middlewrap">
		<img src="resources/image/main/sample1.jpg" style="width: 100%;">
	</div>
	
	<script type='text/javascript'>
	
				
		</script>
	
    <!-- Bootstrap core JavaScript-->
    <script src="resources/vendor/jquery/jquery.min.js"></script>
    <script src="resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="resources/vendor/jquery-easing/jquery.easing.min.js"></script>

  </body>
</html>