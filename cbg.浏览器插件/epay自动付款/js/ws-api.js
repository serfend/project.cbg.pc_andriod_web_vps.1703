
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
var init=()=>{
	sendReport('init',initData)
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