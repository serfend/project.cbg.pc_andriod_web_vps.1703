﻿using DotNet4.Utilities.UtilReg;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Miner.Goods;
using Miner.Server;
using Miner.Goods.Summon;
using System.Threading;
using System.Windows.Forms;
using DotNet4.Utilities.UtilCode;

using System.IO;
using File_Transfer;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Reflection;
using Miner.ServerHandle;
using SfTcp.TcpClient;
using SfTcp.TcpMessage;
using TcpFiletransfer.TcpTransferEngine.Connections;
using Newtonsoft.Json.Linq;

namespace Miner
{
	internal partial class Program
	{
		public static Setting setting;
		public static ServerList servers;
		public static TcpClient Tcp;

		private static void StartNewProgram()
		{
			new Thread(() =>
			{
				Thread.Sleep(3000);
				Process.Start(Process.GetCurrentProcess().MainModule.FileName);
			}).Start();
		}

		private static void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
		{
			StartNewProgram();
			new Task(() => { MessageBox.Show("UnhandledException" + e.ExceptionObject.ToString()); }).Start();
			Thread.Sleep(5000);
			Environment.Exit(-1); //有此句则不弹异常对话框
		}

		public static Reg rootReg;
		public static Reg clientId;

		public enum VpsStatus
		{
			WaitConnect,
			Connecting,
			Syning,
			Running,
			Idle,
			Exception
		}

		public static VpsStatus vpsStatus = 0;
		private static int disconnectTime = 10;
		private static int idleTime = 30;
		private static int connectFailTime = 0;

		public static string TcpMainTubeIp = "127.0.0.1";
		public static int TcpMainTubePort = 8009;
		public static string TcpFileTubeIp = "127.0.0.1";
		public static int TcpFileTubePort = 8010;


		[STAThreadAttribute]
		private static void Main(string[] args)
		{
			var fileName = Process.GetCurrentProcess().MainModule.FileName;
			var targetIp = HttpUtil.GetElement(fileName, "(", ")");
			if (targetIp != null)
			{
				var tmpInfo = targetIp.Split('!');
				if (tmpInfo.Length == 4)
				{
					TcpMainTubeIp = tmpInfo[0];
					TcpMainTubePort = Convert.ToInt32(tmpInfo[1]);
					TcpFileTubeIp = tmpInfo[2];
					TcpFileTubePort = Convert.ToInt32(tmpInfo[3]);
				}
			}

			rootReg = new Reg("sfMinerDigger");
			clientId = rootReg.In("Main").In("Setting");
			CheckLastLoadEquipmentSetting();
			if (rootReg.In("Setting").GetInfo("developeModel") == "1")
            {
				Logger.OnLog += (x, xx) => { Console.WriteLine(xx.LogInfo); };
				Logger.IsOnDevelopeModel = true;
			}

			try
			{
				var mainThreadCounter = rootReg.In("Main").In("Thread").In("Main");
				while (true)
				{
					Thread.Sleep(1000);
					if (VpsStatus.Running != vpsStatus)
						Console.WriteLine(vpsStatus);
					switch (vpsStatus)
					{
						case VpsStatus.Connecting:
							{
								if (disconnectTime++ > 5 && anyTaskWorking == false)
								{
									disconnectTime = 0;
									vpsStatus = VpsStatus.WaitConnect;
								}
								break;
							}
						case VpsStatus.WaitConnect:
							{
								if (disconnectTime++ > 5 && anyTaskWorking == false)
								{
									if (connectFailTime++ > 2)
									{
										connectFailTime = 0;
										RedialToInternet();
										Program.setting.LogInfo("连接到服务器失败次数达上限,重新拨号", "通讯记录");
									}
									else
									{
										disconnectTime = 0;
										vpsStatus = VpsStatus.Connecting;
										InitTcp();
									};//尝试连接次数过多，则重连宽带

									disconnectTime = 0;
								}

								break;
							}
						case VpsStatus.Idle:
							{
								if (idleTime-- < 0 && anyTaskWorking == false)
								{
									CheckLastLoadEquipmentSetting();
									HelloToServer();
									idleTime = 30;
								}
								break;
							}
						case VpsStatus.Running:
							{
								if (Environment.TickCount - servers.LastServerRunTime > 10000)
								{
									vpsIsDigging = false;
									ServerBeginRun(0);
								}
								break;
							}
						case VpsStatus.Syning:
							{
								if (Tcp == null)
								{
									vpsStatus = VpsStatus.WaitConnect;
								}
								else
								{
									if (disconnectTime++ > 15 && anyTaskWorking == false)
									{
										disconnectTime = 0;
										vpsStatus = VpsStatus.WaitConnect;
									}
								}
								break;
							}
					}
				}
			}
			catch (Exception ex)
			{
				var info = ex.Message + "\n" + ex.Source + "\n" + ex.StackTrace;
				Logger.SysLog(info, "ExceptionLog");
				Clipboard.SetText(info);
				Thread.Sleep(5000);
			}
		}
		private static void TranslateFileStart()
		{
			Logger.SysLog("准备接收文件", "主记录");
			var fileEngine = new TransferFileEngine(Connection.EngineModel.AsClient, TcpFileTubeIp, TcpFileTubePort);
			fileEngine.Connection.ConnectedToServer += (xs, xxx) =>
			{
				if (xxx.Success)
				{
					setting.LogInfo("连接到文件服务器,准备开始接收文件", "主记录");
					fileEngine.ReceiveFile(Environment.CurrentDirectory + "\\setting");
				}
				else
				{
					setting.LogInfo("请求文件失败/结束:" + xxx.Info, "主记录");
				}
			};
			fileEngine.Receiver.ReceivingCompletedEvent += (xs, xxx) =>
			{
				if (xxx.Result == File_Transfer.Model.ReceiverFiles.ReceiveResult.Completed)
				{
					setting.LogInfo("成功接收文件:" + xxx.Message + "(" + ++fileNowReceive + "/" + fileWaitToUpdate + ")");
					if (fileNowReceive >= fileWaitToUpdate)
					{
						setting.LogInfo("文件已同步完成");
						ServerResetConfig();
						return;
					}
					fileEngine.ReceiveFile(Environment.CurrentDirectory + "/setting");
				}
				else
				{
					setting.LogInfo(xxx.Title + ":" + xxx.Message);
				}
			};
			fileEngine.Receiver.ReceivingStartedEvent += (xs, xxx) =>
			{
				setting.LogInfo($"开始传输文件:{xxx.FileName}");
			};
			fileEngine.Connect();
		}

		private static int fileWaitToUpdate = 0, fileNowReceive = 0;

		public static string InnerTargetUrl { get; internal set; }
		public static object TcpFiletransfer { get; private set; }

		private static int settingDelayTime;
		private static double settingAssumePriceRate;

		private static void InitSetting(int interval, double assumePriceRate)
		{
			settingDelayTime = interval;
			settingAssumePriceRate = assumePriceRate;
		}

		private static void SynFile(MsgSynFileListMessage fileList)
		{
			Logger.SysLog("尝试同步设置", "主记录");
			var requestFileList = new List<SynSingleFile>();
			fileWaitToUpdate = fileNowReceive = 0;
			foreach (var f in fileList.List)
			{
				var localFile = HttpUtil.GetMD5ByMD5CryptoService("setting/" + f.Name);
				if (f.Version != localFile)
				{
					fileWaitToUpdate++;
					//检测到hash不相同则更新
					requestFileList.Add(new SynSingleFile()
					{
						Name = f.Name
					});
				};
			}
			if (requestFileList.Count > 0)
			{
				StringBuilder logInfo = new StringBuilder();
				requestFileList.ForEach((x) => logInfo.Append('\n').Append(x.Name));
				Logger.SysLog(logInfo.ToString(), "主记录");
				Tcp.Send(new MsgSynFileListMessage(requestFileList));
			}
			else
			{
				ServerResetConfig();
			}
		}

		public static bool anyTaskWorking = false;

		private static void ServerResetConfig()
		{
			vpsStatus = VpsStatus.Running;
			anyTaskWorking = true;
			servers = new ServerList();
			SummomPriceRule.Init();
			Goods.Equiment.EquimentPrice.Init();
			servers.ResetConfig(settingDelayTime, settingAssumePriceRate);
			Tcp.Send(new RpClientRunReadyMessage());
		}

	}
}