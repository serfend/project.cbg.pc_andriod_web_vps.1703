using DotNet4.Utilities.UtilCode;
using DotNet4.Utilities.UtilReg;
using SfTcp.TcpClient;
using SfTcp.TcpMessage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Miner
{
    internal  partial class Program
    {

		private static void InitTcp()
		{
			Console.WriteLine("重置通信节点");
			if (Tcp != null)
			{
				Tcp?.Dispose();
				Tcp = null;
				Thread.Sleep(1000);//等待资源释放
			}
			try
			{
				Tcp = new TcpClient(TcpMainTubeIp, TcpMainTubePort);
			}
			catch (Exception ex)
			{
				Logger.SysLog("建立连接失败 " + ex.Message, "ExceptionLog");
				vpsStatus = VpsStatus.WaitConnect;
				return;
			}
			InitCallBackTcp();
		}

		private static bool vpsIsDigging = false;

		private static void InitCallBackTcp()
		{
			try
			{
				if (Tcp == null) return;
				Tcp.OnMessage += Tcp_OnMessage;
				Tcp.OnDisconnected += Tcp_OnDisconnected;
				Tcp.OnConnected += Tcp_OnConnected;
				MinerCallBackInit();
				Tcp.Client.Connect();
			}
			catch (Exception ex)
			{
				Console.WriteLine("InitCallBackTcp()" + ex.Message);
				vpsStatus = VpsStatus.WaitConnect;
			}
		}

		private static void Tcp_OnConnected(object sender, ServerConnectEventArgs e)
		{
			vpsStatus = VpsStatus.Syning;
			Thread.Sleep(1000);
			HelloToServer();
		}

		private static void Tcp_OnDisconnected(object sender, ServerDisconnectEventArgs e)
		{
			Logger.SysLog("与服务器丢失连接", "主记录");
			Tcp?.Dispose();
			Tcp = null;
			anyTaskWorking = false;
			Program.vpsStatus = VpsStatus.WaitConnect;
		}

		private static void Tcp_OnMessage(object sender, ClientMessageEventArgs e)
		{
			//Logger.SysLog(e.RawString, "通讯记录");
			try
			{
				Console.WriteLine($"来自服务器:{e.RawString}");
				MinerCallBack.Exec(e);
			}
			catch (ActionNotRegException ex)
			{
				Console.WriteLine($"读取数据发生异常:{ex.Message}\n{e.RawString}");
			}
		}

		private static void SynServerLoginSession(MsgSynSessionMessage setting)
		{
			foreach (var mdServer in setting.List)
			{
				foreach (var server in servers.HdlServer)
				{
					if (server.ServerName == mdServer.AliasName)
					{
						server.LoginSession = mdServer.LoginSession;
						Program.setting.LogInfo($"服务器登录凭证更新:{server.ServerName}->{mdServer.LoginSession}");
					}
				}
			}
		}

		public static void RedialToInternet()
		{
			//Program.Tcp?.Dispose();
			var t = new Task(() =>
			{
				Task.Delay(1000);
				var p = new CmdRasdial();
				p.DisRasdial();
				Task.Delay(1000);
				p.Rasdial();
				Program.vpsStatus = VpsStatus.WaitConnect;
			});
			t.Start();
		}

		private static void HelloToServer()
		{
			try
			{
				var vpsName = clientId.GetInfo("VpsClientId", "null");
				var clientDeviceId = clientId.GetInfo("clientDeviceId", HttpUtil.UUID);
				clientId.SetInfo("clientDeviceId", clientDeviceId);
				Tcp?.Send(new RpClientConnectMessage("vps", Assembly.GetExecutingAssembly().GetName().Version.ToString(), clientDeviceId, vpsName));
			}
			catch (Exception ex)
			{
				Console.WriteLine("HelloToServer()" + ex.Message);
			}
		}
	}
}
