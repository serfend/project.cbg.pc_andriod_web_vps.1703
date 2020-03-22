
var targetIp = '111.225.10.93'// 创建一个Socket实例
this.socket = new WebSocket('ws://' + targetIp + ':16550') // new WebSocket('wss://2y155s0805.51mypc.cn');//
var sendReport = function (title, msg) {
	var message = {
		t: title,
		m: msg
	}
	var rawInfo = JSON.stringify(message)
	this.socket.send(rawInfo)
}
var initData = {
	name: 'getClientName()',
	version: "1.0.0",
	description: "基础实现"
}
var init = () => {
	sendReport('init', initData)
}
// 打开Socket
this.socket.onopen = (event) => {
	console.log('连接成功')
}
this.socket.onmessage = (data) => {
	console.log(data)
}
this.socket.onclose = function (event) {
	console.log('丢失连接' + event.code)
}
this.socket.onerror = function (event) {
	console.log("连接发生异常")
}


/**
 * 用于保持服务器连接
 * @param {function} oncloseCallback 当连接被断开时回调
 */
function SfConnect(targetIp, oncloseCallback) {
	/**
	 * 向服务器发送数据
	 * @param  {string} title 标题
	 * @param  {json} msg   json数据
	 * 	 
	 */
	this.sendReport = function (title, msg) {
		var message = {
			t: title,
			m: msg
		}
		var rawInfo = JSON.stringify(message)
		this.socket.send(rawInfo)
	}
	this.newMessage = function (event) {
		if (!running) {
			this.socket.close()
			setTimeout(Init, 5000)
			return
		}
		if (event.data) {
			var msg = event.data
			var data = JSON.parse(msg)
			switch (data.title) {
				case "cmd":
					eavl(data)
					break
				case "init":
					if (data.error) {
						noti.ShowDataOnPage(data.error, "终端初始化失败")
						alert(data.error)
						running = false
						this.socket.close()
					} else {
						noti.ShowDataOnPage(data.content, "终端初始化成功")
					}

					break
				case "newBill":
					billInfo = data.billInfo
					noti.ShowDataOnPage(msg, "新订单")
					var newUrl = "https://epay.163.com/cashier/m/standardCashier?orderId=" + billInfo.orderId + "#/1&key=INDEX"
					chrome.tabs.getSelected(null, function (tab) {
						chrome.tabs.update(
							tab.id,
							{
								url: newUrl
							},
							function () {
								//页面开始加载
							}
						)
					})
					break
				case "justEnterEkey":
					ekey = data.content
					chrome.tabs.getSelected(null, function (tab) {
						chrome.tabs.sendMessage(tab.id, {
							eKey: ekey
						})
					})
					break
				case "ping":
					break
				default:
					noti.ShowDataOnPage("无效的服务器数据")
					return
			}
		}
	}

	this.initClient = () => {
		var initData = {
			name: getClientName(),
			version: "1.0.0",
			description: "基础实现"
		}
		this.sendReport("init", initData)
		setInterval(() => {
			this.sendReport("RHB")
		}, 20000)
	}


	noti.ShowDataOnPage("服务器连接:" + targetIp)
	// 创建一个Socket实例
	this.socket = new WebSocket('ws://' + targetIp + ':16550') // new WebSocket('wss://2y155s0805.51mypc.cn');//

	// 打开Socket
	this.socket.onopen = (event) => {
		noti.ShowDataOnPage('与服务器建立连接成功')
		this.initClient()
	}
	this.socket.onmessage = this.newMessage
	this.socket.onclose = function (event) {
		noti.ShowDataOnPage('已丢失连接' + event.code)
		oncloseCallback(event)
	}
	this.socket.onerror = function (event) {
		noti.ShowDataOnPage("连接发生异常")
	}

}
var running = true
var billInfo
chrome.runtime.onMessage.addListener(
	function (request, sender, sendResponse) {
		if (request.location == "/cashier/m/standardCashier")
			if (billInfo)
				sendResponse({ bill: billInfo, msg: "订单提交", error: 0 })
			else
				sendResponse({ msg: "暂无订单", error: 1 })
	})
