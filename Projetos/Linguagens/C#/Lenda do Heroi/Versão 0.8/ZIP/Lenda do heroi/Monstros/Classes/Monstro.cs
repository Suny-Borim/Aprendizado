using System;

namespace Lenda_do_heroi
{
    internal class Monstro
    {
        private string nome;
        private int level { get; set; }
        private Status status { get; set; }
        public void MostraStatus()
        {
            Console.WriteLine("\n======{0}======\nVida:{1}\nMana{2}\nForça{3}\nDefesa:{4}\nAgilidade{5}\nSorte:{6}\n================\n",
                this.nome, this.status.getVida(), this.status.mana, this.status.forca, this.status.defesa, this.status.agilidade, this.status.sorte);
        }
        public string getNomeM()
        {
            return this.nome;
        }
        public void SetNomeM(string nome)
        {
            this.nome = nome;
        }
        public string getLvM()
        {
            return this.nome;
        }
        public void setLvM(int lv)
        {
            this.level = lv;
        }
        public Status getStatusM()
        {
            return this.status;
        }
        public void setStatusM(Status status)
        {
            this.status = status;
        }
        public float ataque()
        {
            float dano = (this.status.forca + this.status.agilidade) * 1 + (new Random(DateTime.Now.Millisecond).Next(0, this.status.agilidade));
            Console.WriteLine("{0}", dano);
            return dano;
        }
        public int defesa()
        {
            return (this.status.defesa + this.status.agilidade) + (1 + new Random(DateTime.Now.Millisecond).Next(0, this.status.sorte));
        }
        public void recebeDano(float dano)
        {
            float recebe = this.defesa() - dano;
            if (recebe < 0)
            {
                this.status.setVida(this.status.getVida() + recebe);
            }
        }
    }
}
