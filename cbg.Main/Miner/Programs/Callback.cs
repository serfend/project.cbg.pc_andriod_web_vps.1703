using SfTcp.TcpClient;
using SfTcp.TcpMessage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Miner
{
    internal partial class Program
    {

		#region MinerCallBack

		private static void MinerCallBackInit()
		{
			MinerCallBack.Init();
			MinerCallBack.RegCallback(TcpMessageEnum.MsgHeartBeat, MinerCallBack_MsgHeartBeat);
			MinerCallBack.RegCallback(TcpMessageEnum.CmdSetClientName, MinerCallBack_CmdSetClientName);
			MinerCallBack.RegCallback(TcpMessageEnum.CmdSynInit, MinerCallBack_CmdSynInit);
			MinerCallBack.RegCallback(TcpMessageEnum.CmdServerRun, MinerCallBack_CmdServerRun);
			MinerCallBack.RegCallback(TcpMessageEnum.MsgSynFileList, MinerCallBack_MsgSynFileList);
			MinerCallBack.RegCallback(TcpMessageEnum.CmdTransferFile, MinerCallBack_CmdTransferFile);
			MinerCallBack.RegCallback(TcpMessageEnum.CmdModefyTargetUrl, MinerCallBack_CmdModefyTargetUrl);
			MinerCallBack.RegCallback(TcpMessageEnum.CmdReRasdial, MinerCallBack_CmdReRasdial);
			MinerCallBack.RegCallback(TcpMessageEnum.CmdStartNewProgram, MinerCallBack_CmdStartNewProgram);
			MinerCallBack.RegCallback(TcpMessageEnum.CmdSubClose, MinerCallBack_CmdSubClose);
			MinerCallBack.RegCallback(TcpMessageEnum.MsgSynSession, MinerCallBack_MsgSynSession);
			MinerCallBack.RegCallback(TcpMessageEnum.CmdServerRunSchedule, MinerCallBack_CmdServerRunSchedule);
		}


        private static void MinerCallBack_MsgHeartBeat(ClientMessageEventArgs e)
		{
			Console.WriteLine("服务器保持连接确认");
		}

		private static void MinerCallBack_CmdSetClientName(ClientMessageEventArgs e)
		{
			var ClientName = e.Message["NewName"]?.ToString();
			setting = new Setting(ClientName);
			clientId.SetInfo("VpsClientId", ClientName);
			Tcp.Send(new RpNameModefiedMessage(ClientName, true));
		}

		private static void MinerCallBack_CmdSynInit(ClientMessageEventArgs e)
		{
			var interval = e.Message["Interval"];
			var assumePriceRate = e.Message["AssumePriceRate"];
			if (interval == null || assumePriceRate == null)
			{
				Tcp.Send(new RpMsgInvalidMessage("synInit"));
				return;
			}
			InitSetting(Convert.ToInt32(interval), Convert.ToDouble(assumePriceRate));
			Program.vpsStatus = VpsStatus.Syning;
			Tcp.Send(new RpInitCompletedMessage());
		}

		private static void MinerCallBack_CmdServerRun(ClientMessageEventArgs e)
		{
			ServerResetConfig();
		}

		private static void MinerCallBack_MsgSynFileList(ClientMessageEventArgs e)
		{
			var rawList = e.Message["List"];
			var list = new List<SynSingleFile>();

			foreach (var item in rawList)
			{
				list.Add(new SynSingleFile()
				{
					Name = item["Name"]?.ToString(),
					Version = item["Version"]?.ToString()
				});
			}

			var synFileList = new MsgSynFileListMessage(list);
			SynFile(synFileList);
		}

		private static void MinerCallBack_CmdTransferFile(ClientMessageEventArgs e)
		{
			TranslateFileStart();
		}

		private static void MinerCallBack_CmdModefyTargetUrl(ClientMessageEventArgs e)
		{
			InnerTargetUrl = e.Message["NewUrl"]?.ToString();
		}

		private static void MinerCallBack_CmdReRasdial(ClientMessageEventArgs e)
		{
			Tcp.Send(new RpReRasdialMessage("cmd"));
			RedialToInternet();
		}

		private static void MinerCallBack_CmdStartNewProgram(ClientMessageEventArgs e)
		{
			StartNewProgram();
		}

		private static void MinerCallBack_CmdSubClose(ClientMessageEventArgs e)
		{
			Environment.Exit(0);
		}

		private static void MinerCallBack_MsgSynSession(ClientMessageEventArgs e)
		{
			var synLoginItemList = new List<SynSessionItem>();
			var synLoginSession = new MsgSynSessionMessage(synLoginItemList);
			SynServerLoginSession(synLoginSession);
		}

		private static void MinerCallBack_CmdServerRunSchedule(ClientMessageEventArgs e)
		{
			var s = new Thread(() =>
			{
				var nextRuntimeStamp = Convert.ToInt32(e.Message["TaskStamp"]?.ToString());
				ServerBeginRun(nextRuntimeStamp);
			})
			{ IsBackground = true };
			s.Start();
		}

		private static void ServerBeginRun(int nextRuntimeStamp)
		{
			vpsStatus = VpsStatus.Running;
			if (vpsIsDigging)
			{
				Console.WriteLine("警告,同时出现多个采集实例");
				return;
			}
			vpsIsDigging = true;
			try
			{
				//if (nextRuntimeStamp > 499) Tcp.Send(new RpClientWaitMessage(0, 0, 101));//开始等待
				Thread.Sleep(nextRuntimeStamp);
				//if (nextRuntimeStamp > 499) Tcp.Send(new RpClientWaitMessage(0, 0, -101));//结束等待
				//	if (servers == null)
				//	{
				//		Console.WriteLine("servers未初始化");
				//		return;
				//	}
				var ticker = new Win32.HiperTicker();
				ticker.Record();
				//Thread.Sleep(60);
				int hdlGoodNum = servers.ServerRun();
				var avgInterval = (int)(ticker.Duration / 1000);// Program.setting.threadSetting.RefreshRunTime((int)(ticker.Duration / 1000));
																//TODO 此处估价似乎也有延迟
				Program.Tcp?.Send(new RpClientWaitMessage(avgInterval, hdlGoodNum, 0));
			}
			catch (Exception ex)
			{
				Console.WriteLine($"处理日程失败;{ex.Message}\n{ex.StackTrace}");
			}
			finally
			{
				vpsIsDigging = false;
			}
		}

		#endregion MinerCallBack
	}
}
