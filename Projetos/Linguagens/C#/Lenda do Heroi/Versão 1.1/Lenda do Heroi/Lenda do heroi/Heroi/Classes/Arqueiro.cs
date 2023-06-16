using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi
{
    internal class Arqueiro : Heroi
    {
        private int flechas;
        public Arqueiro(string nome, int idade, int flechas)
        {
            this.setNome(nome);
            this.setIdade(idade);
            this.setClasse("Arqueiro");
            this.flechas = flechas;
            this.setXpMaximo(100);
            this.setLv(1);
            Status status = new Status(175, 30, 35, 20, 25, 20);
            Corpo corpo = new Corpo("cabeca", false, "torso", false, "maos", false, "pernas", false, "pes", false);
            this.setCorpo(corpo);
            this.setStatus(status);
        }
        public new void MostraStatus()
        {
            Console.WriteLine("\n======{0}======\nClasse:{1}\nVida:{2}\nFlechas:{3}\nMana:{4}\nForça:{5}\nDefesa:{6}\nAgilidade:{7}\nSorte:{8}\n================\n",
               this.getNome(), this.getClasse(), this.status.getVida(),this.flechas, this.status.mana, this.status.forca, this.status.defesa, this.status.agilidade, this.status.sorte);
        }
        public new float ataque()
        {
            if (this.flechas > 0)
            {
                this.flechas = this.flechas - 1;
                float dano = (this.status.forca + this.status.agilidade) * 1 + (new Random(DateTime.Now.Millisecond).Next(0, this.status.agilidade));
                Console.WriteLine("{0}", dano);
                return dano;
            }
            else
            {
                Console.WriteLine("Sem flechas!");
                return 0;
            }
        }
    }
}
