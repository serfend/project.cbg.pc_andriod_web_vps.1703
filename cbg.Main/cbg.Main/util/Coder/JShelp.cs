using DotNet4.Utilities.UtilReg;
using MSScriptControl;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace JsHelp
{
	class JShelp
	{
		public JShelp()
		{
			scriptControl = new ScriptControl
			{
				UseSafeSubset = true,
				Language = "JavaScript",
				AllowUI=true
			};
		}
		StringBuilder cmdInfo=new StringBuilder();
		/// <summary>
		/// 向预置指令中添加指令，等待调用{ExcuteScript()}时使用此指令
		/// </summary>
		/// <param name="expressionLine"></param>
		public void AddCmd(string expressionLine)
		{
			cmdInfo.Append(expressionLine).Append("\r\n");
		}
		/// <summary>
		/// 清空缓存的指令
		/// </summary>
		public void Clear()
		{
			cmdInfo.Clear();
		}
		public object Excute()
		{
			return Excute(cmdInfo.ToString());
		}
		public readonly ScriptControl scriptControl;
		public object Excute(string sExpression)
		{
			try
			{
				return scriptControl.Eval(sExpression);
			}
			catch (Exception ex)
			{
				MessageBox.Show($"ExcuteScript(){ex.Message}=>\n{ex.StackTrace}");
				//Logger.SysLog(ex.Message+'\n'+ex.StackTrace,"主记录");
			}
			return null;
		}
		/// <summary>
		/// 加载js文件到缓存
		/// </summary>
		/// <param name="jsPath"></param>
		public void Load(string jsPath)
		{
			scriptControl.AddCode(System.IO.File.ReadAllText(jsPath));
			
		}
		/// <summary>
		/// 加载一系列js文件到缓存
		/// </summary>
		/// <param name="jsPath"></param>
		public void Load(string[] jsPath)
		{
			var cstr = new StringBuilder();
			foreach (var jsFile in jsPath)
			{
				Load(jsFile);				 
			}
		}
	}
}
