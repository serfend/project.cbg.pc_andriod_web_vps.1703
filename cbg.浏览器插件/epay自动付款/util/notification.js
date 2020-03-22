function Notify(defaultName,defaultIcon,newNotiCallback){
	this.defaultName=defaultName;
	this.defaultIcon=defaultIcon;
	/**
	 * 显示通知
	 * @param {string} msg 标题
	 * @param {string} title   内容
	 * @param {string} icon  图标地址
	 * @param {int} timeout 显示时间
	 * @param {function} onClick 鼠标点击时回调 
	 */
	this.ShowDataOnPage=(msg,title,icon,timeout,onClick)=>{ 
			console.log("noti.show"+title+":"+msg);
			if(window.Notification&&this.CheckPermission()){ 
				var n = new Notification(title||this.defaultName, 
						{ 
							"icon": icon||this.defaultIcon, 
							"body": msg
						}); 
				n.onshow = function () {
					if(newNotiCallback){
						newNotiCallback(n);
					} 
					setTimeout(function () { n.close() },timeout || 5000); 
				}; 
				n.onclick = function () { 
					onClick();
		 			n.close(); 
		 		}; 
		 		n.onclose = function () { 
		 			
		 		}; 
		 		n.onerror = function () {
		  			console.err('弹出消息'); 
				};
				return n;
			}else{ 
				alert(title+":"+msg); 
			} 
		}
}

Notify.prototype.CheckPermission=()=>{
	if (window.Notification.permission != 'granted') {
		Notification.requestPermission(
			function (status) {
	           //status是授权状态，如果用户允许显示桌面通知，则status为'granted'
	           console.log('status: ' + status);
	           //permission只读属性:
	           //  default 用户没有接收或拒绝授权 不能显示通知
	           //  granted 用户接受授权 允许显示通知
	           //  denied  用户拒绝授权 不允许显示通知
	           var permission = Notification.permission;
	           console.log('permission: ' + permission);
       });
	}
	return window.Notification.permission == 'granted';
}