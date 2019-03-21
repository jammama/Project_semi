<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<%response.setContentType("text/html; charset=UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style type="text/css">

::-webkit-scrollbar-button {
	height: 0;
}

::-webkit-scrollbar {
	width: 6px;
	height: 6px;
}
/* Handle */
::-webkit-scrollbar-thumb {
	border-radius: 4px;
	background: #888;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
	background: #555;
}

.canvas_wrapper{
	display: flex;
}

#canvas{
	order: 1;
}

.penmode{
	order: 2;
	display: flex;
	flex-direction: column;
	justify-content: flex-end;
}

.penmode div{
	overflow:visible;
	padding: 8px;
	width: 20px;
	color: #000000;
	margin: 5px;
	border-radius: 20px;
}
.pen{
	background-color: #e4e4e4;
	order: 1;
}
.line{
	background-color: #e4e4e4;
	order: 2;
}
.rect{
	background-color: #e4e4e4;
	order: 3;
}
.colorpicker{
	order: 4;
}
.black{
	background-color:#000000
}
.red{
	background-color:#f00
}
.yellow{
	background-color:#ff0
}
.orange{
	background-color:#ffa500
}
.green{
	background-color:#008000
}
.blue{
	background-color:#00f
}
#savebutton{
	text-decoration: none;
	position: absolute;
	top: 520px;
	left: 500px;
	background-color: #0067ce;
	color: #fff;
	margin: 5px;
	border-radius: 5px;
	width: 100px;
	height: 20px;
	padding: 10px;
}

.submit{
	position: absolute;
	background-color: #0067ce;
	top: 520px;
	left: 640px;
	color: #fff;
	margin: 5px;
	border-radius: 5px;
	width: 130px;
	padding: 10px;
}
	
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
/**
 * 그림판....
 */
 
/**
 * canvas
 */
var picture = {
 canvas : null,
 context : null,
 context1 : null
};
/**
 * 0 : 펜
 * 1 : 직선
 * 2 : 사각형
 */
var eventObject = {
 mode: 0,
 click : false,
 x: 0,
 y: 0,
};
 
// 초기화
window.onload = function() {
 
 document.getElementById("loadImg").addEventListener("change", loadImg, false);
 picture.canvas = document.getElementById("canvas");
 picture.context = picture.canvas.getContext("2d");
 picture.context.lineWidth = 4;
 
 mouseListener();
 
 $(function() {
		
		$(".color").click(function() {
			
			if($(this).html()=="red"){
				picture.context.strokeStyle = "red";
				picture.context.beginPath();
			}else if($(this).html()=="yellow"){
				picture.context.strokeStyle = "#ff0";
				picture.context.beginPath();
			}else if($(this).html()=="orange"){
				picture.context.strokeStyle = "#ffa500";
				picture.context.beginPath();
			}else if($(this).html()=="green"){
				picture.context.strokeStyle = "#008000";
				picture.context.beginPath();
			}else if($(this).html()=="blue"){
				picture.context.strokeStyle = "#00f";
				picture.context.beginPath();
			}else if($(this).html()=="black"){
				picture.context.strokeStyle = "#000000";
				picture.context.beginPath();
			}	
			picture.context.stroke();
		})
	})
}
 
// 현재 클릭중인지 아닌지 구분?하기위한 변수 세팅
function setClickTrue(){
 eventObject.click = true;
}
function setClickFalse(){
 eventObject.click = false;
}
 
// 펜일 경우의 이벤트
function dragEvent(event) {
 
 var g = picture.context;
 
 g.moveTo(eventObject.x, eventObject.y);
 
 eventObject.x = event.x;
 eventObject.y = event.y;
 
 if (eventObject.click) {
  g.lineTo(event.x, event.y);
  g.stroke();
 }
 
}
 
// 좌표 출력
function printXY(e){
 var g = picture.context;
 document.getElementById("x").innerHTML = e.x;
 document.getElementById("y").innerHTML = e.y;
}
 
// 라인, 사각형 등 이전 좌표가 필요할 경우 이전좌표 세팅
function setBeforeXY(e){
 
 var g = picture.context;
 eventObject.x = e.x;
 eventObject.y = e.y;
 g.moveTo(e.x, e.y);
}
 
// setBeforeXY 에서 세팅한 좌표부터 현재 좌표까지 직선을 그림
function drawLine(e){
 
 var g = picture.context;
 
 g.lineTo(e.x, e.y);
 g.stroke();
}
 
// setBeforeXY 에서 세팅한 좌표부터 현재 좌표까지 사각형을 그림
function drawRect(e){
 
 var g = picture.context;
 g.rect(eventObject.x, eventObject.y, e.x-eventObject.x, e.y-eventObject.y);
 g.stroke();
 // g.fill(); 을 g.stroke() 대신 사용하면 속이 꽉찬 사각형을 그린다.
}
 
// 각 경우에 따라서 이벤트리스너를 달아준다.
function mouseListener(){
 
 var mode = Number(eventObject.mode);
 picture.canvas.addEventListener("mousemove", printXY, false);
 
 switch(mode){
 
 case 0:
  document.getElementById("mode").innerHTML = "pen";
  picture.canvas.addEventListener("mousedown",setClickTrue, false);
  picture.canvas.addEventListener("mouseup", setClickFalse, false);
  picture.canvas.addEventListener("mousemove", dragEvent, false);
  break;
  
 case 1:
  document.getElementById("mode").innerHTML = "line";
  picture.canvas.addEventListener("mousedown",setBeforeXY, false);
  picture.canvas.addEventListener("mouseup", drawLine, false);
  break;
  
 case 2:
  document.getElementById("mode").innerHTML = "rect";
  picture.canvas.addEventListener("mousedown",setBeforeXY, false);
  picture.canvas.addEventListener("mouseup", drawRect, false);
  break;
  
 default:
  break;
 }
 
}
 
// 이벤트 리스너 제거
function removeEvent(){
 picture.canvas.removeEventListener("mousedown",setClickTrue, false);
 picture.canvas.removeEventListener("mouseup", setClickFalse, false);
 picture.canvas.removeEventListener("mousemove", dragEvent, false);
 picture.canvas.removeEventListener("mousedown",setBeforeXY, false);
 picture.canvas.removeEventListener("mouseup", drawLine, false);
 picture.canvas.removeEventListener("mouseup", drawRect, false);
}
 
// 모드 체인지
function changeMode(mode){
 removeEvent();
 eventObject.mode = mode;
 mouseListener();
}
 
function toDateURL() {
	var myimage = document.getElementById('myImage');
	myImage.src=canvas.toDataURL();
	
	var canvasURL = document.getElementById('url');
	canvasURL.value=canvas.toDataURL();
	
	alert(canvasURL.value);
	
	//window.close();
	
}

//canvas에 그려진 그림을 파일로 저장
function save2(){ 
	var myImage = document.getElementById('myImage');
	//myImage.src = canvas.toDataURL();//canvas를 이미지파일로 옮김 
	//alert(myImage.src); //이미직 경로
		
	document.getElementById('abc').setAttribute('href',canvas.toDataURL());	
}

// function sendChat(){
// 	document.getElementById('').setAttribute('src',canvas.toDateURL());
// }
	
	
</script>

<title>그림판</title>
</head>
<body>
 
<form action="Canvas.ho" method="post">
 
 	<input type="hidden" name="command" value="insert_canvas">
 	<input type="hidden" name="canvasURL" id="url" >
 	<input type="hidden" id="loadImg">
 	<div class="canvas_wrapper">
		 <canvas id = "canvas" width="770" height="500" style = "border: 1px solid #b6b6b6;border-radius: 5px;"></canvas>
		 </canvas>
		 <div class="penmode">
			 <div class = "pen" onclick="changeMode(0)">pen</div>
			 <div class ="line" onclick="changeMode(1)">line</div>
			 <div class="rect" onclick="changeMode(2)">rect</div>
			 
			 <div class ="color black">black</div>
			 <div class ="color red">red</div>
			 <div class ="color orange">orange</div>
			 <div class ="color yellow">yellow</div>
			 <div class ="color green">green</div>
			 <div class ="color blue">blue</div>
		 </div>
		 <!-- <input type="button" value="save(보내기)" onclick="save()"><br>  -->
	 </div>
	 <div id="showmode"> mode : <span id="mode"></span></div>
     
     <a class="save" id="abc" href="#" download>
     <input id ="savebutton" onclick="save2()" value="save pngfile">
     </a>

	 
	 <!--  <button onclick="toDateURL();" >URL로변환</button> -->
	 
	 <input class="submit" onclick="toDateURL();" type="submit" value="보내기(전송)">
	 
	 
	 
	 <img id="myImage">
</form>

</body>
</html>