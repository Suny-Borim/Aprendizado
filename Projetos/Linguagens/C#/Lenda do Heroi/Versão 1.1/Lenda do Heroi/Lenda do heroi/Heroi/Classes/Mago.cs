using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi
{
    internal class Mago:Heroi
    {
        public Mago(string nome,int Idade)
        {
            this.setNome(nome);
            this.setClasse("Mago");
            this.setIdade(Idade);
            this.setLv(1);
            this.setXpMaximo(100);
            Status status = new Status(170, 45, 40, 20, 15, 20);
            Corpo corpo = new Corpo("cabeca", false, "torso", false, "maos", false, "pernas", false, "pes", false);
            this.setStatus(status);
            this.setCorpo(corpo);
        }
        
        public void curar()
        {
            this.status.mana = this.status.mana - 30;
            this.status.setVida(this.status.getVida() + this.status.getVida() *(1/10));
        }
    }
}
