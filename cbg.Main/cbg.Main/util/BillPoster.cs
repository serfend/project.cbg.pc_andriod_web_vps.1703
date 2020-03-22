using DotNet4.Utilities.UtilCode;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace cbg.Main.util
{
	class BillPoster
	{
		private string loginSession;
		private string reonsale_identify;
		private string equipid;
		private string serverid;
		public BillPoster(string infoInit,string loginSession)
		{
			this.LoginSession = loginSession;
			var tmp = HttpUtil.GetElement(infoInit, "reonsale_identify", "/>");
			Reonsale_identify = HttpUtil.GetElement(tmp, "value=\"", "\"");
			tmp = HttpUtil.GetElement(infoInit, "equipid", "/>");
			Equipid = HttpUtil.GetElement(tmp, "value=\"", "\"");
			tmp = HttpUtil.GetElement(infoInit, "serverid", "/>");
			Serverid = HttpUtil.GetElement(tmp, "value=\"", "\"");
			billInfo.Add("act", "buy");
			billInfo.Add("device_id", (697659108 + new Random().Next(1, 55)).ToString());
			
		}

		public void Submit(Action<string, bool> CallBack, FrmMain frm)
		{
			var http = new HttpClient(new HttpClientHandler() { UseCookies = false });
			var httpMsg = new HttpRequestMessage(HttpMethod.Post, "https://xy2.cbg.163.com/cgi-bin/usertrade.py") {

			};
			
			httpMsg.Content = new FormUrlEncodedContent(BillInfo);
			frm.Text = $"获取登录凭证{LoginSession}";
			httpMsg.Headers.Add("Cookie", LoginSession);
			var rawInfo = http.SendAsync(httpMsg).Result.Content.ReadAsStringAsync().Result;
			frm.Invoke((EventHandler)delegate
			{
				var result = HttpUtil.GetElement(rawInfo, "<!--页面内容-->", "</");
				frm.Text = "提交成功:" + result;
				for (int i = result.Length - 1; i > 0; i--)
				{
					if (result[i] == '>')
					{
						result = result.Substring(i);
						break;
					}
				}
				if (result.Length == 1)
				{
					if (rawInfo.Contains("建议尽快完成支付，最先完成支付的玩家才可以成功购得该商品"))
					{
						CallBack.Invoke("下单成功", true);
						return;
					}
					CallBack.Invoke(result, false);
				}
				CallBack.Invoke("下单失败:" + result, false);
			});
		}
		private Dictionary<string, string> billInfo=new Dictionary<string, string>();
		private Dictionary<string,string> BillInfo { get {
				return billInfo;
				
			} }
		private List<KeyValuePair<string, string>> paramList = new List<KeyValuePair<string, string>>();
		public string LoginSession { get => loginSession; set => loginSession = value; }
		public string Reonsale_identify { get => reonsale_identify; set {
				reonsale_identify = value;
				billInfo["reonsale_identify"] = value;
			} }
		public string Equipid { get => equipid; set {
				equipid = value;
				billInfo["equipid"] = value;
			} }
		public string Serverid { get => serverid; set {
				serverid = value;
				billInfo["serverid"] = value;
			} }
	}
}
