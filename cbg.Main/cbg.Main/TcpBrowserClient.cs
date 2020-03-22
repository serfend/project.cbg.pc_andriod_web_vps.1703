using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cbg.Main
{
	public class TcpBrowserClient:SfTcp.TcpClient.TcpClient
	{
		public TcpBrowserClient():base("127.0.0.1",8009) {
			
		}
	}
}
