using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Miner.ServerHandle
{
	public class Order_headers
	{
		/// <summary>
		///
		/// </summary>
		public string field { get; set; }

		/// <summary>
		///
		/// </summary>
		public List<string> direction { get; set; }

		/// <summary>
		/// 最新
		/// </summary>
		public string name { get; set; }
	}

	public class Equip_list
	{
		/// <summary>
		/// 小孩:2 最高评价:4808
		/// </summary>
		public string subtitle { get; set; }

		/// <summary>
		///
		/// </summary>
		public int raw_equip_status { get; set; }

		/// <summary>
		/// 齐云灵脉
		/// </summary>
		public string equip_server_name { get; set; }

		/// <summary>
		///
		/// </summary>
		public int storage_type { get; set; }

		/// <summary>
		///
		/// </summary>
		public int collect_num { get; set; }

		/// <summary>
		///
		/// </summary>
		public int equip_status { get; set; }

		/// <summary>
		///
		/// </summary>
		public string appointed_roleid { get; set; }

		/// <summary>
		///
		/// </summary>
		public int areaid { get; set; }

		/// <summary>
		/// 齐云灵脉
		/// </summary>
		public string server_name { get; set; }

		/// <summary>
		/// 飞升159级
		/// </summary>
		public string level_desc { get; set; }

		/// <summary>
		///
		/// </summary>
		public List<string> highlights { get; set; }

		/// <summary>
		/// 魔界
		/// </summary>
		public string equip_area_name { get; set; }

		/// <summary>
		///
		/// </summary>
		public int equip_serverid { get; set; }

		/// <summary>
		///
		/// </summary>
		public bool allow_urs_bargain { get; set; }

		/// <summary>
		/// 魔界
		/// </summary>
		public string area_name { get; set; }

		/// <summary>
		/// 小孩:2 最高评价:4808
		/// </summary>
		public string desc_sumup_short { get; set; }

		/// <summary>
		///
		/// </summary>
		public int status { get; set; }

		/// <summary>
		///
		/// </summary>
		public string product { get; set; }

		/// <summary>
		///
		/// </summary>
		public int price { get; set; }

		/// <summary>
		///
		/// </summary>
		public int pass_fair_show { get; set; }

		/// <summary>
		/// 上架中
		/// </summary>
		public string status_desc { get; set; }

		/// <summary>
		///
		/// </summary>
		public string price_desc { get; set; }

		/// <summary>
		///
		/// </summary>
		public int serverid { get; set; }

		/// <summary>
		///
		/// </summary>
		public string icon { get; set; }

		/// <summary>
		///
		/// </summary>
		public string unit_price_desc { get; set; }

		/// <summary>
		/// 小孩:2 最高评价:4808
		/// </summary>
		public string desc_sumup { get; set; }

		/// <summary>
		///
		/// </summary>
		public int equip_areaid { get; set; }

		/// <summary>
		///
		/// </summary>
		public string game_ordersn { get; set; }

		/// <summary>
		///
		/// </summary>
		public string equip_face_img { get; set; }

		/// <summary>
		/// 狐美人
		/// </summary>
		public string equip_name { get; set; }

		/// <summary>
		///
		/// </summary>
		public string eid { get; set; }

		/// <summary>
		/// 狐美人
		/// </summary>
		public string format_equip_name { get; set; }
	}

	public class GoodListItem
	{
		/// <summary>
		///
		/// </summary>
		public int status { get; set; }

		/// <summary>
		///
		/// </summary>
		public string product { get; set; }

		/// <summary>
		///
		/// </summary>
		public string order_field { get; set; }

		/// <summary>
		///
		/// </summary>
		public List<int> kind_id { get; set; }

		/// <summary>
		///
		/// </summary>
		public List<Order_headers> order_headers { get; set; }

		/// <summary>
		///
		/// </summary>
		public string search_type { get; set; }

		/// <summary>
		///
		/// </summary>
		public string order_direction { get; set; }

		/// <summary>
		///
		/// </summary>
		public int num_per_page { get; set; }

		/// <summary>
		///
		/// </summary>
		public List<Equip_list> equip_list { get; set; }

		/// <summary>
		///
		/// </summary>
		public bool can_cross_buy { get; set; }

		/// <summary>
		///
		/// </summary>
		public int page { get; set; }

		/// <summary>
		///
		/// </summary>
		public bool is_login { get; set; }

		/// <summary>
		///
		/// </summary>
		public bool is_last_page { get; set; }
	}
}