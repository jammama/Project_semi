function videoPreview() {
	$("#img_video").remove();
	$(".video-detail").append("<img id='img_video'></img>");
	    	
	var link = document.getElementsByClassName("link-input")[1].innerHTML;

	if(link.includes("youtube.com")){
		var youtubeid_index = link.search("v=");
		var youtubeid = link.substr(youtubeid_index+2,link.length);
				
		$("#img_video").attr("src","http://img.youtube.com/vi/"+youtubeid+"/2.jpg");
		$("#img_video").wrap("<a id='link' href='"+link+"'></a>");
		$(".video-detail").append("<br/><br/>유튜브에서 동영상을 가져왔습니다.");
		$(".video-detail").css("text-align","center");
	
	} else{
		
			alert("링크 주소가 잘못되었습니다.");
			
			}
	}	

// 동영상 가져오기-취소
function videoUploadCancel() {
	
	document.getElementsByClassName("link-input")[1].innerHTML = "";
	document.getElementsByClassName("video-detail")[0].innerHTML = "";
}

var videotime_res;	
var bookmarkArr = new Array();

// 동영상 구간이동
function getStartTime(linkvar,tno){
	
	/*$("#bookmark"+tno).show();
	$("#bookmarktext"+tno).show();*/
	var startTime = $("#startTime"+tno).val().split(":");
	var startTime_ = new Array();
	var hh = null;
	var mm = null;
	var ss = null;	
			
	if(startTime.length==3){  // [시:분:초] 입력했을 경우
		
		for(var i=0;i<startTime.length;i++){
			
			if(startTime[i].startsWith("0")){
				
				startTime_[i] = startTime[i].substr(1);
				hh = eval(startTime_[0]*60*60);
				mm = eval(startTime_[1]*60); 
				
			} else {
				
					hh = eval(startTime[0]*60*60);
					mm = eval(startTime[1]*60); 
			}
		}
		
		ss = eval(startTime[2]);
		videotime_res = hh+mm+ss;
		
		$("#bookmark"+tno).show();
		$("#bookmarktext"+tno).show();
		
		} // [분:초] 입력했을 경우
		else if(startTime.length==2){ 
			
			for(var i=0;i<startTime.length;i++){
					
				if(startTime[i].startsWith("0")){
						
					startTime_[i] = startTime[i].substr(1);
					mm = eval(startTime_[0]*60); 
						
				} else{
					
						mm = eval(startTime[0]*60); 
				}
			}
			
			ss = eval(startTime[1]);
			videotime_res = mm+ss;
			
			$("#bookmark"+tno).show();
			$("#bookmarktext"+tno).show();
			
			} else {
				$("#startTime"+tno).val="";
				alert("잘못 입력했습니다.");
			}	
			$("#video_frame"+tno).attr("src","https://www.youtube.com/embed/"+linkvar+"?start="+videotime_res);
		}	

var li_id = -1;

// 동영상 북마크
function bookmark(linkvar,i){
	
	var tt = videotime_res;
	var ul = document.getElementById("bookmarkul"+i);
	var li = document.createElement("li");
	var btn_bm = document.createElement("input");
	var btn_del = document.createElement("input");
	var bookmarklabel = document.createElement("label");			
			
	li.setAttribute("id","li"+(++li_id))
			
	btn_bm.setAttribute("type","button");
	btn_bm.setAttribute("id","bmbtn"+li_id);
	btn_bm.setAttribute("class","btnvideolink");
	btn_bm.setAttribute("value",$("#startTime"+i).val());
	btn_bm.setAttribute("onclick","gotoBookmark("+tt+","+i+",\""+linkvar+"\");");
			
	btn_del.setAttribute("type","button");
	btn_del.setAttribute("id","delbtn"+li_id);
	btn_del.setAttribute("class","btnvideolinkdel");
	btn_del.setAttribute("value","X");
	btn_del.setAttribute("onclick","delBookmark("+li_id+","+i+");");	

	bookmarklabel.innerHTML = " "+document.getElementById("bookmarktext"+i).value;
	bookmarklabel.setAttribute("class","labelbookmark");
			
	li.appendChild(btn_del);
	li.appendChild(btn_bm);
	li.appendChild(bookmarklabel);
	ul.appendChild(li);

	$("#startTime"+i).val("");
	$("#bookmark"+i).hide();
	$("#bookmarktext"+i).hide();
	document.getElementById("bookmarktext"+i).value="";
}

function gotoBookmark(tt,i,linkvar){
	
	$("#video_frame"+i).attr("src","https://www.youtube.com/embed/"+linkvar+"?start="+tt);
}		

function delBookmark(li_id,i){
	
	var li_ = document.getElementById("li"+li_id);
	document.getElementById("bookmarkul"+i).removeChild(li_);		
}