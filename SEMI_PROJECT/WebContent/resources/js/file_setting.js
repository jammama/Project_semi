//파일 가져오기
function getFileName(){
	
	var filevalue = $("#filename").val().split("\\");
	var filename = filevalue[filevalue.length-1];
	document.getElementsByClassName("map-input")[1].value = filename;

}		
// 파일 가져오기-취소
function fileUploadCancel() {
	
	document.getElementById("filename").value = "";	
	document.getElementsByClassName("map-input")[1].value = "";
	
		}