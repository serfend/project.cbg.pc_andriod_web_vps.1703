function callinfo(){
	console.log(a.client);
}
function A(){
	this.editName=function(){
		this.client="3";
	}
	this.client="2";
}
A.prototype.client="0";
var a;

function Init(){
	a=new A();
}
Init();


callinfo();

a.editName();
callinfo();