using System;

namespace Lenda_do_heroi
{
    internal class Monstro
    {
        private string nome;
        private int level { get; set; }
        private float xp;
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

        public float getXp()
        {
            return this.xp;
        }
        public void setXp(float xp)
        {
            this.xp = xp;
        }
        public Status getStatusM()
        {
            return this.status;
        }
        public void setStatusM(Status status)
        {
            this.status = status;
        }
        public int defesa()
        {
            return (this.status.defesa + this.status.agilidade) + (1 + new Random(DateTime.Now.Millisecond).Next(0, this.status.sorte));
        }
        public void recebeDano(Heroi player,Monstro monstro,float dano)
        {
            float recebe = this.defesa() - dano;
            if (recebe < 0)
            {
                this.status.setVida(this.status.getVida() + recebe);
            }
            if(this.status.getVida() < 0)
            {
                this.darXp(player,monstro);
            }
        }
        public void darXp(Heroi player, Monstro monstro)
        {
            if (this.status.getVida() <= 0)
            {
                player.setXp(player.getXp() + monstro.getXp());
                player.LevelUP();
                
            }
        }
    }
}
