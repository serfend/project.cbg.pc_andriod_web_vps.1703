using SfTcp.TcpMessage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace 订单信息服务器
{
	public partial class Form1
	{
		private Dictionary<string, string> BrowserIp = new Dictionary<string, string>();//浏览器进程对应终端ip

		private void SendCmdToAllBrowserClient(CmdCheckBillMessage cmdInfo)
		{
			foreach (var i in BrowserIp)
			{
				var client = server[i.Value];
				if (client == null)
					AppendLog("系统", $"未找到目标浏览器{i.Key}");
				else
					client.Send(cmdInfo);
			}
		}
	}
}