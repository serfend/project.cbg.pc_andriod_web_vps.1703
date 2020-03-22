// chrome.tabs.getSelected(null, function (tab) {
//        alert("已注入到:"+tab.url);
//    });

// $(window).load(function(){
// 	noti.ShowDataOnPage("页面加载完成");
// });

  console.log("重定向console.log");
  console.log=function(info){
  	alert(info);
  	
  };


function PostMsgToContentJs(info){
	window.postMessage({"cmd": info}, '*');
}