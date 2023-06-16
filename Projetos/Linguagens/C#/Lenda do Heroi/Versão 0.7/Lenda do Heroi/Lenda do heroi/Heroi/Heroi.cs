using System;

namespace Lenda_do_heroi
{
    internal class Heroi
    {
        private string nome { get; set; }
        private int idade { get; set; }
        private int level { get; set; }
        private string classe { get; set; }

        public Status status;
        public Corpo corpo;
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

        public string getClasse()
        {
            return this.classe;
        }
        public void setClasse(string classe)
        {
            this.classe = classe;
        }
        public void setStatus(Status status)
        {
            this.status = status;
        }
        public void setCorpo(Corpo corpo)
        {
            this.corpo = corpo;
        }
        public void equiparArma(Armas arma)
        {
            if (this.corpo.maos == false)
            {
                Console.WriteLine("Equipada em maos: {0}", arma.getNomeArmas());
                this.status.setVida(this.status.getVida() + arma.atributos.vida);
                this.status.forca = this.status.forca + arma.atributos.forca;
                this.status.agilidade = this.status.agilidade + arma.atributos.agilidade;
                this.corpo.maos = true;
                this.mostarCorpo();
                this.MostraStatus();
            }
            else
            {
                Desequipar(arma);
                this.corpo.maos = false;
                this.mostarCorpo();
                this.MostraStatus();
            }

        }
        public void Desequipar(Armas arma)
        {
            Console.WriteLine("Desequipada em maos: {0}", arma.getNomeArmas());
            this.status.setVida(this.status.getVida() - arma.atributos.vida);
            this.status.forca = this.status.forca - arma.atributos.forca;
            this.status.agilidade = this.status.agilidade - arma.atributos.agilidade;
            this.corpo.maos = false;
        }
        public void mostarCorpo()
        {
            Console.WriteLine("\n======{0}======\n{1}\n{2}\n{3}\n{4}\n{5}\n================\n",
                this.nome, this.corpo.cabeca, this.corpo.torso, this.corpo.maos, this.corpo.pernas, this.corpo.pes);
        }
        public void MostraStatus()
        {
            Console.WriteLine("\n======{0}======\nClasse:{1}\nVida:{2}\nMana{3}\nForça{4}\nDefesa:{5}\nAgilidade{6}\nSorte:{7}\n================\n",
                this.nome,this.getClasse(),this.status.getVida(), this.status.mana, this.status.forca, this.status.defesa, this.status.agilidade, this.status.sorte);
        }
        public float ataque()
        {
            float dano = (this.status.forca + this.status.agilidade) * 1 + (new Random(DateTime.Now.Millisecond).Next(0, this.status.agilidade));
            Console.WriteLine("{0}", dano);
            return dano;
        }
    }

}
