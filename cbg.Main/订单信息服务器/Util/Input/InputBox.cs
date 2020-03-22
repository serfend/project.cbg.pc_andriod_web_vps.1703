﻿using System;
using System.Windows.Forms;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DotNet4.Utilities.UtilInput
{
	class InputBox:Form
	{
		private System.Windows.Forms.TextBox txtData;
		private System.Windows.Forms.Label lblInfo;
		private System.ComponentModel.Container components = null;

		private InputBox()
		{
			InitializeComponent();
		}

		protected override void Dispose(bool disposing)
		{
			if (disposing)
			{
				if (components != null)
				{
					components.Dispose();
				}

			}
			base.Dispose(disposing);
		}

		private void InitializeComponent()
		{
			this.txtData = new System.Windows.Forms.TextBox();
			this.lblInfo = new System.Windows.Forms.Label();
			this.SuspendLayout();
			// 
			// txtData
			// 
			this.txtData.Font = new System.Drawing.Font("宋体", 10.5F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
			this.txtData.Location = new System.Drawing.Point(19, 8);
			this.txtData.Name = "txtData";
			this.txtData.Size = new System.Drawing.Size(317, 23);
			this.txtData.TabIndex = 0;
			this.txtData.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtData_KeyDown);
			// 
			// lblInfo
			// 
			this.lblInfo.BackColor = System.Drawing.SystemColors.Info;
			this.lblInfo.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
			this.lblInfo.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.lblInfo.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
			this.lblInfo.ForeColor = System.Drawing.Color.Gray;
			this.lblInfo.Location = new System.Drawing.Point(19, 32);
			this.lblInfo.Name = "lblInfo";
			this.lblInfo.Size = new System.Drawing.Size(317, 16);
			this.lblInfo.TabIndex = 1;
			this.lblInfo.Text = "[Enter]确认 | [Esc]取消";
			// 
			// InputBox
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(6, 14);
			this.ClientSize = new System.Drawing.Size(350, 48);
			this.ControlBox = false;
			this.Controls.Add(this.lblInfo);
			this.Controls.Add(this.txtData);
			this.Name = "InputBox";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "InputBox";
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		//对键盘进行响应
		private void txtData_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
		{
			if (e.KeyCode == Keys.Enter)
			{
				this.Close();
			}

			else if (e.KeyCode == Keys.Escape)
			{
				txtData.Text = defaultInfo;
				this.Close();
			}

		}
		private string defaultInfo;
		/// <summary>
		/// 显示输入框
		/// 需要在主线程调用
		/// </summary>
		/// <param name="Title">输入框标题</param>
		/// <param name="keyInfo">输入框内容</param>
		/// <param name="defaultInfo">默认输入信息</param>
		/// <param name="callback">输入完成回调</param>
		/// <returns></returns>
		public static string ShowInputBox(string Title, string keyInfo,string defaultInfo="",Action<string>callback=null)
		{
			
			InputBox inputbox = new InputBox
			{
				Text = Title,
				defaultInfo = defaultInfo
			};
			inputbox.txtData.Text = defaultInfo;
			if (keyInfo.Trim() != string.Empty)
				inputbox.lblInfo.Text = keyInfo;
			inputbox.ShowDialog();
			callback?.Invoke(inputbox.txtData.Text);
			return inputbox.txtData.Text;
		}


	}
}
