using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi
{
	internal class Mochila
	{
		public int tamanho = 10;
		public slot[] slot;
		public Mochila()
		{
			slot = new slot[this.tamanho];

			for (int i = 0; i < tamanho; i++)
			{
				slot[i] = new slot();
			}
		}

	}
}