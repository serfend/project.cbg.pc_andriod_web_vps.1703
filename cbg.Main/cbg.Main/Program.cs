using SfTcp.TcpClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace cbg.Main
{
	static class Program
	{
		public static TcpClient Tcp ;

		
		/// <summary>
		/// 应用程序的主入口点。
		/// </summary>
		[STAThread]
		static void Main(string[] args)
		{
			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(false);
			Init(args);
			AppDomain.CurrentDomain.UnhandledException += CurrentDomain_UnhandledException; ;
			Application.ThreadException += new System.Threading.ThreadExceptionEventHandler(Application_ThreadException);

			try
			{
				Application.Run(new FrmMain());
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message + "\n" + ex.StackTrace);
			}
		}
		private static void Application_ThreadException(object sender, ThreadExceptionEventArgs e)
		{
			MessageBox.Show($"{e.Exception.Message}\n{e.Exception.StackTrace}", "线程错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
		}

		private static void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
		{
			MessageBox.Show(e.ExceptionObject.ToString(), "系统错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
		}
		public static DotNet4.Utilities.UtilReg.Reg reg ;
		public static string thisExeThreadId;
		private static void Init(string[] args)
		{
			if (args.Length == 0)
			{
				thisExeThreadId = "1";
			}
			else
			{
				thisExeThreadId = args[0];
			}

			reg = new DotNet4.Utilities.UtilReg.Reg("sfMinerDigger");
			//MessageBox.Show(string.Format("子线程已创建到{0}号线程",thisExeThreadId));
		}
	}
}
