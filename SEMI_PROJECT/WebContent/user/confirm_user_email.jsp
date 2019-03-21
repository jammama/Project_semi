<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%
response.setHeader("pragma","No-cache");
response.setHeader("Cache-Control","no-cache");
response.addHeader("Cache-Control","No-store");
response.setDateHeader("Expires",1L);
%>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Nomwork-이메일 인증</title>

    <!-- Bootstrap core CSS-->
    <link href="resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="resources/css/sb-admin.css" rel="stylesheet">
    
    <style type="text/css">
    	
    .wrap{
    	background-color: white;
    	width: 30%;
    	height: 70%;
    	text-align: center;
    	position: absolute;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		border-radius: 0.5rem;
    }
    
    .appro{
    	width: 50px;
    	height: 50px;
    	border-radius: 0.7em;
  		box-sizing: border-box;
  		border: 3px solid #00ACE9;
 		outline: none;
 		text-align: center;
 		font-size: 20px;
    }
    
    input::-webkit-outer-spin-button,
	input::-webkit-inner-spin-button {
    -webkit-appearance: none;
	}
	
	.submit_btn{
		margin: 10px;
		width: 30%;
		height: auto;
		color: white;
		background-color: #00ACE9;
		border: 2px solid #00ACE9;
		border-radius: 0.7em;
		min-width: 210px;
		cursor: pointer;
		outline: none;
	}
	
	.submit_btn:hover{
		background-color: #0ea8de;
	}
    
    .re_btn{
    	cursor: pointer;
    	font-size: 13px;
    }	
    
    .re_btn:hover{
    	color: gray;
    }
    </style>
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script type="text/javascript">
    
    //새로고침 키 방지
    function noEvent() {
    	if (event.keyCode == 116) {
    		event.keyCode= 2;
    		return false;
    	}
    	else if(event.ctrlKey && (event.keyCode==78 || event.keyCode == 82)){
    		return false;
    	}
    }
    	document.onkeydown = noEvent;
    
   	//인증번호를 3번이상 틀리면 창이 꺼진다.
    var missCount = 0;
	function check() {
		var size = $(".appro").length;
        var appro_user = "";
        for(i=0; i<size; i++){
            appro_user += $(".appro").eq(i).val();
        }
        var appro_msg = ${appro};
		if(appro_msg != appro_user) {
    	    alert("인증번호가 다릅니다.");
    	    
    		missCount++;
    		if(missCount == 3){
    		//3번 잘못 입력하면 창이 꺼짐
    		location.href="index.jsp";
    		}
    		return false;
		}else{
			return true;
		}
	}
		
	//인증번호 재전송
	function re_sand_email(){
		document.location.reload();
		alert("인증번호를 다시 전송했습니다")
	}	
	
	function move_focus(num,fromform,toform){
		var str = fromform.value.length;
		if(str == num) {
	    	toform.focus();
		}    
	}
	
    </script>
</head>
<body oncontextmenu="return false" class="bg-dark">

	<div class="wrap">
		<img style="margin-top: 10px; width: 100%;" src="resources/image/icon/emailicon.PNG">
		<p>인증번호를 이메일로 발송했습니다<br/>받으신 인증번호를 입력해주세요.<h4>${udto.useremail }</h4><br/>
		
		<form action="User.ho" method="get" onsubmit="return check()">
			<input type="hidden" name="command" value="insert_user">
			<input type="hidden" name="useremail" value="${udto.useremail}">
			<input type="hidden" name="userpw" value="${udto.userpw}">
			<input type="hidden" name="username" value="${udto.username}">
			<input type="hidden" name="usergender" value="${udto.usergender}">
			<input type="text" class="appro" name="appro1" value="" size="1" maxlength="1" oninput="move_focus(1,this,appro2)"/>
			<input type="text" class="appro" name="appro2" value="" size="1" maxlength="1" oninput="move_focus(1,this,appro3)"/>
			<input type="text" class="appro" name="appro3" value="" size="1" maxlength="1" oninput="move_focus(1,this,appro4)"/>
			<input type="text" class="appro" name="appro4" value="" size="1" maxlength="1" oninput="move_focus(1,this,sub_ck)"/>
			<br/>
			<input class="submit_btn" name="sub_ck" type="submit" value="회원가입 완료"/>
		</form>
		<span class="re_btn" onclick="re_sand_email()">이메일을 받지 못하셨나요? 재전송</span>
	</div>
</body>
</html>