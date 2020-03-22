﻿using DotNet4.Utilities.UtilInput;
using DotNet4.Utilities.UtilReg;
using Newtonsoft.Json;
using SfTcp;
using SfTcp.TcpServer;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using 订单信息服务器.Bill;
using 订单信息服务器.Properties.Bill;
using 订单信息服务器.WebServerControl;

namespace 订单信息服务器
{
	public partial class Form1 : Form
	{
		/// <summary>
		/// 手机号对应的登录
		/// </summary>
		private Dictionary<string, PayUser> _paySession = new Dictionary<string, PayUser>();

		/// <summary>
		/// 区号对应手机号
		/// </summary>
		private Dictionary<string, string> _payServerHdl = new Dictionary<string, string>();

		private Reg regMain = new Reg().In("Setting").In("PaySession");

		/// <summary>
		/// 用于记录注册表索引,请勿外部使用
		/// </summary>
		private Dictionary<int, string> _keyPairPaySession = new Dictionary<int, string>();

		private string _authKey;

		/// <summary>
		/// 初始化支付登录凭证记录
		/// </summary>
		private void InitPaySession()
		{
			for (int i = 1; ; i++)
			{
				var name = regMain.GetInfo(i.ToString());
				if (name == null || name.Length == 0) return;
				_keyPairPaySession.Add(i, name);
				var item = regMain.In(name);
				var session = item.GetInfo("session");
				var hdlServer = item.GetInfo("hdlServer");
				var psw = item.GetInfo("psw");
				var data = new string[4];
				data[0] = name;
				data[1] = session;
				data[2] = hdlServer;
				data[3] = psw;
				_paySession.Add(name, new PayUser(name, session, hdlServer, psw));
				CmdPaySaveItem(name, session, hdlServer, psw);
				var tmp = new ListViewItem(data);
				LstPayClient.Items.Add(tmp);
			}
		}

		private void CmdPay_NewVerify_Click(object sender, EventArgs e)
		{
			var phone = InputBox.ShowInputBox("输入账号", "支付页面登录的账号");
			var item = GetVerifyItem(phone);

			if (item == null)
			{
				var data = new string[4];
				data[0] = phone;
				item = new ListViewItem(data);
				LstPayClient.MultiSelect = false;
				item.Selected = true;
				LstPayClient.Items.Add(item);
			}
			else
			{
				if (MessageBox.Show(this, $"已存在手机号{phone}\nkey:{item.SubItems[1].Text}\n新增将导致覆盖,确认新增吗?", "确认", MessageBoxButtons.OKCancel) == DialogResult.Cancel)
				{
					return;
				};
			}

			CmdPay_EditVerify_Click(this, EventArgs.Empty);
		}

		private void CmdPay_EditVerify_Click(object sender, EventArgs e)
		{
			if (LstPayClient.SelectedItems.Count == 0)
			{
				MessageBox.Show("未选中任何项");
				return;
			}
			var item = LstPayClient.SelectedItems[0];
			var session = InputBox.ShowInputBox("输入登录凭证", "凭证可从网页listView.html中复制cookie的值", item.SubItems[1].Text);
			var hdlServer = InputBox.ShowInputBox("输入管理区", "管理区以区号码记录，\"|\"分割", item.SubItems[2].Text);
			var psw = InputBox.ShowInputBox("输入密码", "账号的密码", item.SubItems[3].Text);
			item.SubItems[1].Text = session;

			var list = hdlServer.Split('|');
			var sortlist = list.ToList<string>();
			sortlist.Sort((x, y) =>
			{
				return Convert.ToInt32(x) - Convert.ToInt32(y);
			});
			item.SubItems[2].Text = string.Join<string>("|", sortlist);
			item.SubItems[3].Text = psw;
			var user = new PayUser(item.SubItems[0].Text, session, hdlServer, psw);
			if (!_paySession.ContainsKey(item.SubItems[0].Text)) _paySession.Add(user.UserName, user);
			else _paySession[user.UserName] = user;

			CmdPaySaveItem(item.SubItems[0].Text, session, hdlServer, psw);
		}

		private void CmdPaySaveItem(string phone, string session, string hdlServer, string psw)
		{
			var item = regMain.In(phone);
			if (!_keyPairPaySession.ContainsValue(phone))
			{
				_keyPairPaySession.Add(_keyPairPaySession.Count + 1, phone);
				regMain.SetInfo(_keyPairPaySession.Count.ToString(), phone);
			}
			var list = hdlServer.Split('|');
			foreach (var i in list)
			{
				if (!_payServerHdl.ContainsKey(i))
				{
					_payServerHdl.Add(i, phone);
				}
				else
				{
					_payServerHdl[i] = phone;
				}
			}

			item.SetInfo("session", session);
			item.SetInfo("hdlServer", hdlServer);
			item.SetInfo("psw", psw);
		}

		/// <summary>
		///
		/// </summary>
		/// <param name="serverNo"></param>
		/// <param name="InnerInfo"></param>
		/// <param name="callback">完成付款流程回调</param>
		public void PayCurrentBill(string serverNo, string InnerInfo = "", Action<string> callback = null)
		{
			AppendLog($"开始对{InnerInfo}进行付款");
			if (_payServerHdl.ContainsKey(serverNo))
			{
				var phoneTarget = _payServerHdl[serverNo];
				if (_paySession.ContainsKey(phoneTarget))
				{
					//TODO 获取支付凭证并付款
					var session = _paySession[phoneTarget];
					var item = payClient[payClientIp[phoneTarget]];
					item.ViewItem.SubItems[1].Text = $"处理{serverNo}订单";
					if (!IpCheckBeforePay.Checked || MessageBox.Show(this, $"订单:\n{InnerInfo}", "付款确认", MessageBoxButtons.YesNo) == DialogResult.Yes)
					{
						//PayCurrentBill(session,(x)=> {
						//	callback?.Invoke(x);
						//	item.ViewItem.SubItems[1].Text = x;
						//});
					}
				}
				else
				{
					callback?.Invoke($"当前区{serverNo}管理的账号{phoneTarget}无支付凭证");
				}
			}
			else
			{
				callback?.Invoke($"当前区{serverNo}暂无管理的账号");
			};
		}

		/// <summary>
		/// 提交当前订单付款行为
		/// 【future】当密码或将军令为空时，将从基类中获取数据
		/// </summary>
		/// <param name="name">下单用户名称</param>
		/// <param name="session">付款凭证</param>
		/// <param name="psw">预置密码</param>
		private void PayCurrentBill(string name, string session, string psw = null, Action<string> callback = null)
		{
			if (!payClientIp.ContainsKey(name))
			{
				callback?.Invoke($"用户名{name}所对应的浏览器未开启");
				return;
			};
			if (!payClient.ContainsKey(payClientIp[name]))
			{
				callback?.Invoke($"浏览器终端[{name}]未启动");
				return;
			}
			var root = new BillInfo(session);
			var getBillInfo = new Task(() =>
			{
				//try
				//{
				//	root.GetData(10,callback);
				//}
				//catch (Exception ex)
				//{
				//	anyException = true;
				//	callback?.Invoke($"订单失败:{ex.Message}  z");
				//	return;
				//}
			});

			getBillInfo.Start();
			Task.WaitAll(new Task[] { getBillInfo });
		}

		/// <summary>
		/// 广播到所有终端
		/// </summary>
		/// <param name="item"></param>
		public void PayCurrentBill(Action<string> callback = null)
		{
			NewBillMessage item = null;

			var userInput = new Task(() =>
			{
				var authKey = AuthKey;
				// if (authKey == null) authKey = InputBox.ShowInputBox("输入将军令", "当前将军令为空，请输入", "111111");
				//修改为广播 client = payClient[payClientIp[name]];
				item = new NewBillMessage()
				{
					BillInfo = new NewBillMessage.SubmitBillInfo()
					{
						Ekey = authKey,
						Psw = "111111",
					}
				};
			});
			var t = new Thread(() =>
			{
				userInput.Start();
				Task.WaitAll(new Task[] { userInput });
				//item.BillInfo.OrderId = root.FirstBill.orderId;
				//修改为广播
				var str = JsonConvert.SerializeObject(item);
				foreach (var client in payClient)
				{
					client.Value?.Session?.Send(str);
				}
				callback?.Invoke($"付款信息已提交至浏览器插件");
			})
			{ IsBackground = true };
			t.Start();
		}

		/// <summary>
		/// 检查订单号是否被处理过
		/// </summary>
		private Dictionary<string, bool> _BillRecord = new Dictionary<string, bool>();

		private string lastExceptAuthCode;

		public string AuthKey
		{
			get => _authKey; set
			{
				if (value.Length != 6)
				{
					if (lastExceptAuthCode == value)
						AppendLog($"【警告】新的将军令可能有误,其为:{value}");
					lastExceptAuthCode = value;
					return;
				}
				OpAuthCodeShow.Text = $"将军令:{value}";
				_authKey = value;
			}
		}

		/// <summary>
		/// 将新的物品添加到商品列表
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="targetItem"></param>
		/// <param name="InnerInfo"></param>
		public void HdlNewCheckBill(TcpConnection sender, ListViewItem targetItem, string InnerInfo)
		{
			try
			{
				var tmp = InnerInfo.Split(new string[] { "##" }, StringSplitOptions.None);
				if (tmp.Length < 10)
				{
					AppendLog($"{sender.AliasName} 无效的订单信息:{InnerInfo}");
					return;
				}
				var serverName = tmp[0];
				var goodName = tmp[1];
				var priceInfo = tmp[2];
				var Rank = tmp[3];
				var ITalent = tmp[4];
				var IAchievement = tmp[5];
				var IChengjiu = tmp[6];
				var ISingleEnergyRate = tmp[7];
				var BuyUrl = tmp[8];
				var serverNum = tmp[9];
				if (_BillRecord.ContainsKey(BuyUrl))
				{
					//AppendLog(ordersn + "已出现过此订单," + serverName);
					return;
				}
				AppendLog(priceInfo);
				var price = priceInfo.Split('/');
				double priceNum = 0, priceNumAssume = 0;
				if (price.Length == 2)
				{
					priceNum = Convert.ToDouble(price[0]);
					priceNumAssume = Convert.ToDouble(price[1]);
				}
				var priceMinRequireRate = Convert.ToDouble(IpMinHandlePrice.Text) / 100;
				_BillRecord.Add(BuyUrl, true);
				LstGoodShow.Items.Insert(0, new ListViewItem(tmp));
				if (LstGoodShow.Items.Count > 10) LstGoodShow.Items[10].Remove();
				var priceNumAssumeMinRequire = priceNumAssume * priceMinRequireRate;
				if (priceNum > priceNumAssumeMinRequire)
				{
					AppendLog($"{serverName} {goodName}:标价过高{priceNum}/最高估价{priceNumAssumeMinRequire}");
					return;
				}
				else
				{
					AppendLog($"新的订单:{priceNum}/{priceNumAssumeMinRequire}@ {BuyUrl}");
					var earnNum = priceNumAssume - priceNum;
					if (earnNum / priceNum < 5)
					{
						ManagerHttpBase.RecordMoneyGet += earnNum;
						ManagerHttpBase.RecordMoneyGetTime++;
						ManagerHttpBase.RecordBill(goodName, priceNum, priceNumAssume);
					}
				}
				SendCmdToAllBrowserClient(new SfTcp.TcpMessage.CmdCheckBillMessage(SfTcp.TcpMessage.CmdCheckBillMessage.Action.submit, BuyUrl, priceNumAssume, priceNum));
				//TODO 发送到脚本终端 SendCmdToAllScriptClient(new SfTcp.TcpMessage.CmdCheckBillMessage(SfTcp.TcpMessage.CmdCheckBillMessage.Action.submit,BuyUrl,priceNumAssume,priceNum));
				ManagerHttpBase.FitWebShowTime++;
			}
			catch (Exception ex)
			{
				new Thread(() => { MessageBox.Show($"订单处理异常:{ex.Message}\n\n{ex.StackTrace}"); }).Start();
			}
		}

		/// <summary>
		/// 通过账号获取item
		/// </summary>
		/// <param name="key"></param>
		/// <returns></returns>
		private ListViewItem GetVerifyItem(string key)
		{
			foreach (var item in LstPayClient.Items)
			{
				if (item is ListViewItem i)
				{
					if (i.SubItems[0].Text == key) return i;
				}
			}
			return null;
		}
	}
}