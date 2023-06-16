using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi

{
    internal class Status 
    {
        private float vida;
        public int mana;
        public float forca;
        public int defesa;
        public int agilidade;
        public int sorte;
      

        public Status(float vida, int mana, float forca, int defesa, int agilidade, int sorte)
        {
            this.vida = vida;
            this.mana = mana;
            this.forca = forca;
            this.defesa = defesa;
            this.agilidade = agilidade;
            this.sorte = sorte;
        }

        public float getVida()
        {
            return this.vida; 
        }
        public void setVida(float vida)
        {
            this.vida = vida;
        }
 
    }
}
