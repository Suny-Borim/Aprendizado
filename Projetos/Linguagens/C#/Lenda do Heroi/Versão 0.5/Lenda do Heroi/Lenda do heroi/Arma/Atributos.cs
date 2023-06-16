using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi.Arma
{
    internal class Atributos
    {
        public float vida;
        public float forca;
        public int defesa;
        public int mana;
        public int agilidade;
        public Atributos(float vida,int forca,int defesa, int mana, int agilidade)
        {
            this.vida = vida;
            this.forca = forca; 
            this.defesa = defesa;
            this.mana = mana;
            this.agilidade = agilidade;
        }
    }

   
}
