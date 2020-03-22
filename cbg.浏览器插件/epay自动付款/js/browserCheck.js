
var client;
var noti=new Notify("付款插件","img/icon.png",function(x){
	reportInfo("report",{
		t:x.title,
		m:x.body
	});
});
function Init(targetIp){
	targetIp=targetIp||localStorage["serverIp"]||"111.225.8.153";
	localStorage["serverIp"]=targetIp;
	if(!running){
		setTimeout(Init,5000);
		return;
	}
	client=new SfConnect(
		targetIp,
		function(event){
			if(running){
				noti.ShowDataOnPage("等待重新连接到服务器"); 
			}else{
				noti.ShowDataOnPage('浏览器已停止运行');
				return;
			}
			setTimeout(Init,5000);
		}
	);
}
getClientName=function(){
		if(this.clientName){
			return this.clientName;
		}
		this.clientName=prompt("输入此浏览器名称");
		return this.clientName;
	}
Init();
function reportInfo(title,body){
	if(client){
		client.sendReport(title,body);
	}
}
function editTarget(newValue){
	Init(newValue);
}