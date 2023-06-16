using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi
{
    internal class Dragao:Monstro
    {
        public Dragao(string nome, int lv)
        {
            this.SetNomeM(nome);
            this.setLvM(lv);
            this.setXp(50);
            Status status = new Status(80, 0, 50, 10, 25, 10);
            this.setStatusM(status);
        }
    }
}
