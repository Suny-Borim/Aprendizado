using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi
{
	internal class Mochila
	{
		public slot[] slot = new slot[10];
		public Mochila() 
		{
			for (int i = 0; i < 10; i++) 
			{
				slot[i] = new slot();	
			}
		}
	}
}
