using DotNet4.Utilities.UtilCode;
using DotNet4.Utilities.UtilReg;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace Miner
{
    internal partial class Program
    {

        private static void CheckLastLoadEquipmentSetting()
        {
            var v = clientId.GetInfo("LastDownloadEquipment", null);
            var lastDownloadEquipment = v!=null  ? DateTime.Parse(v) : DateTime.MinValue ;
            if (DateTime.Now.Subtract(lastDownloadEquipment).TotalDays < 1) return;
            clientId.SetInfo("LastDownloadEquipment",  DateTime.Now.ToString());
            Logger.SysLog($"上次加载配置({lastDownloadEquipment})已超过时限，重新加载", "装备加载");

            LoadEquipmentSetting();
        }
        private static void LoadEquipmentSetting()
        {
            Reg setting = new Reg("sfMinerDigger").In("Main").In("Setting").In("ServerData");
            var http = new HttpClient();
            var url = "https://cbg-xy2.res.netease.com/js/game_auto_config.js";
            Logger.SysLog($"下载装备配置", "装备加载");
            var response = http.GetAsync(url).Result;
            var rawInfo = response.Content.ReadAsStringAsync().Result;
            var info = HttpUtil.DecodeUnicode(rawInfo);
            var json_info = HttpUtil.GetElementRight(info, "var CBG_GAME_CONFIG=");
            var jsonItem = JsonConvert.DeserializeObject(json_info) as JObject;
            int cataCount = 0;
            foreach (var item in jsonItem)
            {
                var reg = setting.In(item.Key);
                var count = 0;
                foreach(var c in item.Value)
                {
                    if (c.Type == JTokenType.Property)
                    {
                        var p = c.ToObject<JProperty>();
                        var key = p.Name;
                        var v = p.Value;
                        reg.SetInfo(key, v);
                        count++;
                    }
                }
                Logger.SysLog($"{item.Key} 加载装备配置：{count}条","装备加载");
                if (count > 0) cataCount++;
            }
            Logger.SysLog($"加载装备配置：{cataCount}种", "装备加载");
        }
    }
}
