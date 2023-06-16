using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi
{
    internal class Heroi 
    {
        private string nome { get; set; }
        private int idade { get; set; }
        private int level { get; set; }
        public Status status;
        public string getNome()
        {
            return nome;
        }
        public void setNome(string nome)
        {
            this.nome = nome;
        }
        public int getIdade()
        {
            return idade;
        }
        public void setIdade(int idade)
        {
            this.idade = idade;
        }
        public int getLv()
        {
            return level;
        }
        public void setLv(int Lv)
        {
            this.level = Lv;
        }
        public void MostraStatus()
        {
             Console.WriteLine("\n======{0}======\nVida:{1}\nMana{2}\nForça{3}\nDefesa:{4}\nAgilidade{5}\nSorte:{6}\n================\n", 
                 this.nome, this.status.getVida(), this.status.mana,this.status.forca, this.status.defesa, this.status.agilidade, this.status.sorte);
        }
        public float ataque()
        {
            float dano = (this.status.forca + this.status.agilidade) * 1 + (new Random(DateTime.Now.Millisecond).Next(0, this.status.agilidade));
            Console.WriteLine("{0}", dano);
            return dano;
        }
        public void setStatus(Status status)
        {
            this.status = status;  
        }
    }

  
}
