var bg=chrome.extension.getBackgroundPage();
synBgStatus();
$("#textShow").click(function(){
	switchOn();
});
$("#serverIpBtn").click(function(){
	editBgTarget($("#serverIp").val());
});
function editBgTarget(newValue){
	bg.editTarget(newValue);
}
function switchOn(){
	bg.running=!bg.running;
	synBgStatus();
}
function synBgStatus(){
	$("#serverIp").val(localStorage["serverIp"]);
	if(!bg.running){
		$("#textShow").css({
			color:"rgb(100,100,100)",
			width:"10rem"
		});
		$("#textShow").text("插件处于关闭状态");
	}else{
		$("#textShow").css({
			color:"rgb(255,100,100)",
			width:"20rem"
		});
		$("#textShow").text("已启动插件");
	}
}