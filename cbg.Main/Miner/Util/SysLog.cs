using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;
using System.Net.Sockets;
using System.Threading;
using System.Globalization;
using System.Security.Cryptography;
using DotNet4.Utilities.UtilCode;

namespace DotNet4.Utilities.UtilReg
{
	public static class Logger
	{
		public static string defaultPath = "log";
		public static event OnLogHandler OnLog;
		public delegate void OnLogHandler(object sender, LogInfoEventArgs e);
		public class LogInfoEventArgs : EventArgs
		{
			string logInfo, logBase;

			public LogInfoEventArgs(string logInfo, string logBase)
			{
				this.LogInfo = logInfo;
				this.LogBase = logBase;
			}

			public string LogInfo { get => logInfo; set => logInfo = value; }
			public string LogBase { get => logBase; set => logBase = value; }
		}
		public static void SysLog(string logInfo,string logBase,string CataPath)
		{
			//AppendLogToFile(string.Format("{0}/{1}-{2}.log", logBase, DateTime.Now.ToString("yyMMdd"), CataPath), string.Format("{0}:{1}", HttpUtil.TimeStamp, logInfo));
			AppendLogToFile(string.Format("{0}/{1}-{2}.log", logBase, DateTime.Now.ToString("yyMMdd"), CataPath), string.Format("{0}:{1}", DateTime.Now.ToString("yyMMddhhmmss"), logInfo));
		}
		public static void SysLog(string logInfo,string CataPath)
        {
			//Console.WriteLine(logInfo);
			//TODO 关闭日志 
			SysLog(logInfo, defaultPath, CataPath);
		}
		private static bool isOnDevelopeModel=true;
        private static readonly object c = "";

		public static bool IsOnDevelopeModel { get => isOnDevelopeModel; set => isOnDevelopeModel = value; }

		public static void AppendLogToFile(string path, string logInfo)
        {
            //锁住，防止多线程引发错误
            lock (c)
            {
				var filePath = AppDomain.CurrentDomain.BaseDirectory + "/" + path;

				List<string> list = new List<string>();
				try
				{
					var fs_dir = new FileStream(filePath, FileMode.Append, FileAccess.Write);
					using (var sw = new StreamWriter(fs_dir))
					{
						if (isOnDevelopeModel) { sw.WriteLine(logInfo); }else { sw.WriteLine((logInfo)); }
						//System.Diagnostics.Debug.WriteLine("logger:" + logInfo);
						OnLog?.Invoke(null,new LogInfoEventArgs(logInfo, path));
					}
				}
				catch (DirectoryNotFoundException)
				{
					var pathRootIndex = filePath.LastIndexOf('/') ;
					var directoryPath = pathRootIndex>0? filePath.Substring(0, pathRootIndex):filePath;
					Directory.CreateDirectory(directoryPath);
				}
				catch (Exception e)
				{
					Console.WriteLine("Logger.SysLog(\"Logger.AppendLogToFile().Exception:\"" + e.Message + ");");
				}
            }

        }
     
    }
}
