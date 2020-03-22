setTimeout(()=>{
  location.href="https://epay.163.com/wap/h5/checkLogin.htm";
},60000);
//injectCustomJs("js/inject.js");
var billInfo;
$(document).ready(()=>{
  chrome.runtime.sendMessage({location: location.pathname}, function(response) {
    if(response.error==0){
        console.log("进入到付款页面，等待加载");
        billInfo=response.bill;
        Bill_EnterBillPage();
        Bill_InputPsw();

        setTimeout(Bill_InputEkey,700);
    }else{
        console.log(response.msg);
    }
  });
});
chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    console.log(sender.tab ?
                "from a content script:" + sender.tab.url :
                "from the extension");
    if(request.eKey){
    	SubmitEkey(request.eKey);
    }else{
    	console.log("无效的信息:",request);
    }
 });
window.addEventListener("message", function(e)
{
    switch(e.data.cmd){
      case "load":
        console.log("2333");
    }
}, false);

function Bill_EnterBillPage(){
  console.log("订单付款开始,psw:"+billInfo.psw+",ekey:"+billInfo.eKey);
	$("#seledctPayBtn").click();
}
function Bill_InputPsw(){
    console.log("输入密码");
    $("#shortPassword").val(billInfo.psw)
    $("#shortPasswordBtn").click()
}
function Bill_InputEkey(){
      if(billInfo.eKey){
        SubmitEkey(billInfo.eKey);
        console.log("订单付款结束");
      }else{
        console.log("尚未输入将军令,等待服务器");
      }
}
function SubmitEkey(eKey){
  var tryTime=10;
  do{
    $("#ekey").val(eKey);  
    console.log("输入将军令");
  }while($("#ekey").val()==""&&tryTime-->0);
  console.log("提交将军令");
  tryTime=10;
	do{
    $("#ekyBtn").click();
  }while($("#ekey").val()!=""&&tryTime-->0);
}





// 向页面注入JS
function injectCustomJs(jsPath)
{
    jsPath = jsPath || 'js/inject.js';
    var temp = document.createElement('script');
    temp.setAttribute('type', 'text/javascript');
    // 获得的地址类似：chrome-extension://ihcokhadfjfchaeagdoclpnjdiokfakg/js/inject.js
    temp.src = chrome.extension.getURL(jsPath);
    temp.onload = function()
    {
        // 放在页面不好看，执行完后移除掉
        this.parentNode.removeChild(this);
    };
    document.head.appendChild(temp);
}