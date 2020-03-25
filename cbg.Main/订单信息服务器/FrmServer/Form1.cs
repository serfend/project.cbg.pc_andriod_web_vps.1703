using DotNet4.Utilities.UtilCode;
using DotNet4.Utilities.UtilReg;
using SfTcp;
using SfTcp.TcpMessage;
using SfTcp.TcpServer;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using 订单信息服务器.Bill;
using 订单信息服务器.WebServerControl;

namespace 订单信息服务器
{
	public partial class Form1 : Form
	{
		private TcpServer server;
		private Reg regSetting;

		public Form1()
		{
			regSetting = new Reg("sfMinerDigger").In("Setting");
			regSettingVps = regSetting.In("vps");
			regServerInfo = regSetting.In("ServerInfo");
			InitializeComponent();
			InitHistorySettingOnFormctl();
			InitTransferEngine();
			//InitServerTaskList();
			Initserver();
			StartTaskSchedule();
			InitPaySession();
			//ServerJsManager.Init();
			//InitWebBrowserControl();  // websocket方式连接
			LstConnection.AfterLabelEdit += CheckIfUserEditName;
		}

		private bool ctlSaveLoaded = false;

		private void InitHistorySettingOnFormctl()
		{
			var frmSetting = regSetting.In("Form").In("ServerFormMain");
			foreach (var ctl in this.TabMain_Setting.Controls)
			{
				if (ctl is TextBox t)
				{
					t.Text = frmSetting.GetInfo(t.Name, t.Text);
					if (!ctlSaveLoaded)
					{
						t.TextChanged += (x, xx) =>
						{
							frmSetting.SetInfo(t.Name, t.Text);
						};
					}
				}
				else if (ctl is CheckBox c)
				{
					c.Checked = frmSetting.GetInfo(c.Name, c.Checked.ToString()) == "true";
					if (!ctlSaveLoaded)
					{
						c.CheckedChanged += (x, xx) =>
						{
							frmSetting.SetInfo(c.Name, c.Checked);
						};
					}
				}
			}

			ctlSaveLoaded = true;
		}

		private bool _taskAllocatePause = false;

		private void CheckIfUserEditName(object sender, LabelEditEventArgs e)
		{
			var ip = LstConnection.Items[e.Item].SubItems[2].Text;
			try
			{
				var target = server[ip];
				var clientName = e.Label;
				regSettingVps.In(target.AliasName).SetInfo("clientName", clientName);
				target.Send(new CmdSetClientNameMessage(clientName));
			}
			catch (Exception ex)
			{
				AppendLog(ip, $"修改终端名称失败:{ex.Message}");
			}
		}

		public void AppendLog(string from, string info)
		{
			var data = new string[] {
				DateTime.Now.ToString("hh:mm:ss"),from,info
			};
			OpLog.Items.Insert(0, new ListViewItem(data));
			if (OpLog.Items.Count > 50)
			{
				OpLog.Items.RemoveAt(49);
			}
		}

		public ListViewItem GetItem(string ip)
		{
			if (_ConnectVpsClientLstViewItem.ContainsKey(ip)) return _ConnectVpsClientLstViewItem[ip];
			return null;
		}

		/// <summary>
		/// 页面listview
		/// </summary>
		private Dictionary<string, ListViewItem> _ConnectVpsClientLstViewItem = new Dictionary<string, ListViewItem>();

		#region event

		private void CmdDisconnect_Click(object sender, EventArgs e)
		{
			try
			{
				var nowSelect = LstConnection.SelectedItems[0].SubItems[2].Text;
				var tcp = server[nowSelect];
				tcp.Disconnect();
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message);
			}
		}

		private void CmdRedial_Click(object sender, EventArgs e)
		{
			try
			{
				if (LstConnection.SelectedItems[0].SubItems[1].Text != "vps")
				{
					MessageBox.Show("仅VPS终端支持重新拨号");
					return;
				}
				var nowSelect = LstConnection.SelectedItems[0].SubItems[2].Text;
				var tcp = server[nowSelect];
				tcp.Send(new CmdReRasdialMessage());
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message);
			}
		}

		private EquipBaseInfo GetEquipBaseInfoFromSelect(ListViewItem item)
		{
			var price = item.SubItems[2].Text.Split('/');
			return new EquipBaseInfo()
			{
				Name = item.SubItems[1].Text,
				Server = item.SubItems[0].Text,
				Level = item.SubItems[3].Text,
				Url = item.SubItems[8].Text,
				PriceAssume = price[1],
				PriceRequire = price[0]
			};
		}

		private void LstGoodShow_DoubleClick_1(object sender, EventArgs e)
		{
			var target = LstGoodShow.SelectedItems[0];
			var targetUrl = target.SubItems[8].Text;
			Clipboard.SetText(targetUrl);
			ManagerHttpBase.UserWebShowTime++;
			var priceInfo = target.SubItems[2].Text;
			var price = Convert.ToDouble(priceInfo.Split('/')[0]);
			var assumePrice = Convert.ToDouble(priceInfo.Split('/')[1]);
			SendCmdToAllBrowserClient(new CmdCheckBillMessage(CmdCheckBillMessage.Action.show, targetUrl, assumePrice, price));
			//SendCmdToBrowserClient(target.SubItems[9].Text, new CmdCheckBillMessage(CmdCheckBillMessage.Action.show, targetUrl));
		}

		private void CmdServerOn_Click(object sender, EventArgs e)
		{
			try
			{
				var nowSelect = LstConnection.SelectedItems[0].SubItems[2].Text;
				var tcp = server[nowSelect];
				tcp.Send(new NormalMessage(IpSender.Text, ""));
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message);
			}
		}

		private void CmdPauseTaskAllocate_Click(object sender, EventArgs e)
		{
			_taskAllocatePause = !_taskAllocatePause;
			if (_taskAllocatePause) CmdPauseTaskAllocate.Text = "唤醒终端";
			else CmdPauseTaskAllocate.Text = "暂停终端";
		}

		#endregion event

		private void CmdPayBill_Click(object sender, EventArgs e)
		{
			if (LstGoodShow.SelectedItems.Count == 0)
			{
				MessageBox.Show("请先选中需要下单的商品");
				if (LstGoodShow.Items.Count > 0)
					LstGoodShow.Items[0].Selected = true;
				return;
			}
			var info = GetEquipBaseInfoFromSelect(LstGoodShow.SelectedItems[0]);

			PayCurrentBill(info);
			//修改为直接广播
			//var targetUser = InputBox.ShowInputBox("输入付款浏览器名称", "输入付款浏览器名称", "");
			//if (!_paySession.ContainsKey(targetUser))
			//{
			//	MessageBox.Show($"无效的浏览器名称:{targetUser}");
			//	return;
			//}
			//var item = payClient[payClientIp[targetUser]];
			//PayCurrentBill(_paySession[targetUser],(x)=> {
			//	if (item == null)
			//		AppendLog($"{targetUser}用户主动下单状态{x}");
			//	else
			//		item.ViewItem.SubItems[1].Text = x;
			//});
		}

		private void CmdSubmitBill_Click(object sender, EventArgs e)
		{
		}
	}
}