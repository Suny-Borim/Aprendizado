using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi.Properties
{
    internal class Aranha:Monstro
    {
        public Aranha(string Name,int lv)
        {
            this.SetNomeM("Aranha");
            this.setLvM(lv);
            Status status = new Status(40, 0, 20, 10, 25, 10);
            this.setStatusM(status);
        }
    }
}
