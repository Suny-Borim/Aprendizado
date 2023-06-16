using System;

namespace Lenda_do_heroi
{
    internal class Heroi
    {
        private string nome { get; set; }
        private int idade { get; set; }
        private int level { get; set; }
        private float xp { get; set; }
        private float xpMax { get; set; }
        private string classe { get; set; }

        Mochila mochila = new Mochila();
        private Armas arma { get; set; }
        public Status status;
        private Corpo corpo { get; set; }


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
        public float getXp()
        {
            return this.xp;
        }
        public void setXp(float xp)
        {
            this.xp = xp;
        }
        public float getXpMaximo()
        {
            return this.xpMax;
        }
        public void setXpMaximo(float xp)
        {
            this.xpMax = xp;
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
        public string getArmas()
        {
            return this.arma.getItemNome();
        }
        public void setArmas(Armas arma)
        {
            this.arma = arma;
        }
        public void setCorpo(Corpo corpo)
        {
            this.corpo = corpo;
        }
        public void colocar(Item item)
        {
            for (int i = 0; i < 10; i++)
            {
                if (mochila.slot[i].item.getItemNome() == item.getItemNome())
                {
                    mochila.slot[i].item.quantidade += 1;
                    return;
                }
                else
                {
                    if (mochila.slot[i].item.GetType().Equals(typeof(Item)))
                    {
                        mochila.slot[i].item = item;
                        return;
                    }
                }
            }
        }
        public void mostrarmochila()
        {
            for (int i = 0; i < this.mochila.tamanho; i++)
            {
                if (mochila.slot[i].GetType().Equals(typeof(Item)))
                {
                    Console.WriteLine("Mochila vazia!");
                    return;
                }
                else
                {
                    Console.Write($"\nMochila {i}: {mochila.slot[i].item.getItemNome()} {mochila.slot[i].item.quantidade}x\n");
                }
            }
        }
        public void equiparArmadura(armadura armadura)
        {
            switch (armadura.getpartedocorpo()) {
                case ("cabeca"):
                    if (this.corpo.cabecabool == false && armadura.getClasse() == this.getClasse())
                    {
                        Console.WriteLine($"Equipada em {this.corpo.cabeca} {armadura.getItemNome()}");
                        this.corpo.cabecabool = true;
                        this.corpo.cabecaarmadura = armadura;
                        this.status.setVidaMaxima(this.status.getVidaMaxima() + armadura.Atributos.vida);
                        this.status.setVida(this.status.getVida() + armadura.Atributos.vida);
                        this.status.forca = this.status.forca + armadura.Atributos.forca;
                        this.status.defesa = this.status.defesa + armadura.Atributos.defesa;
                        this.status.agilidade = this.status.agilidade + armadura.Atributos.agilidade;
                    }
                    else Console.WriteLine($"Esse item pertence a classe {armadura.getClasse()}, sua classe é {this.classe}");
                   break;
                default:  Console.WriteLine($"erro {armadura.getpartedocorpo()}");
                    break;
        }
        }
        public void equiparArma(Armas arma)
        {
            if (this.corpo.maosbool == false)
                if (this.getClasse() == arma.getClasse())
                {
                    this.setArmas(arma);
                    Console.WriteLine("Equipada em {0}: {1}", this.corpo.maos, this.arma.getItemNome());
                    this.status.setVida(this.status.getVida() + this.arma.atributos.vida);
                    this.status.forca = this.status.forca + this.arma.atributos.forca;
                    this.status.agilidade = this.status.agilidade + this.arma.atributos.agilidade;
                    this.corpo.maosbool = true;
                    this.MostraStatus();
                }
                else
                {
                    Console.WriteLine("Você não pertence a classe {0}", arma.getClasse());
                }
            else Console.WriteLine("Você possui um item equipado! {0} : {1}", this.corpo.maos, this.getArmas());
        }
        public void Desequipar(Armas arma)
        {
            if (this.corpo.maosbool == true&& this.arma.getItemNome() == arma.getItemNome())
            {
                Console.WriteLine("Desequipada em {0}: {1}", this.corpo.maos, this.arma.getItemNome());
                this.status.setVida(this.status.getVida() - this.arma.atributos.vida);
                this.status.forca = this.status.forca - this.arma.atributos.forca;
                this.status.agilidade = this.status.agilidade - this.arma.atributos.agilidade;
                this.corpo.maosbool = false;
            }
            else Console.WriteLine("Não há armas equipadas ou essa arma não te pertence\n");
        }
        public void mostarCorpo()
        {
       
            Console.WriteLine($"\n======{this.nome}======\n{this.corpo.cabeca} {this.corpo.cabecaarmadura.getItemNome()}\n{this.corpo.torso}\n" +
                $"{this.corpo.maos} {this.arma.getItemNome()}\n{this.corpo.pernas}\n{this.corpo.pes}\n================\n");
        }
        public void MostraStatus()
        {
            Console.WriteLine($"\n======{this.getNome()}======\nClasse:{this.getClasse()} Lv{this.getLv()} Xp:{this.xp}/{this.xpMax}\nVida:{this.status.getVida()}/{this.status.getVidaMaxima()}\nMana:{this.status.mana}/{this.status.manamaxima}\nForça:{this.status.forca}\nDefesa:{this.status.defesa}\nAgilidade:{this.status.agilidade}\nSorte:{this.status.sorte}\n================\n");
        }
        public void LevelUP()
        {
            if(this.xp >= this.xpMax)
            {
                this.setLv(this.getLv() + 1);
                this.setXpMaximo(this.getXpMaximo() + this.getXpMaximo() * 0.1f);
                this.xp = 0;
                this.colocarPontos();
            }
        }
        public void colocarPontos()
        {
            int pontos = 30, escolha;
            while (pontos >0)
            {
                Console.WriteLine($"Escolha onde você quer atributir seus pontos!\n1-Vida\n2-Mana\n3-forca\n4-defesa\n Você tem {pontos}");
                escolha = Int32.Parse(Console.ReadLine());
                switch (escolha)
                {
                    case 1:
                        Console.WriteLine("Quantos pontos deseja aplicar?\n");
                        escolha = Int32.Parse(Console.ReadLine());
                        if (escolha <= pontos&&escolha>0)
                        {
                            this.status.setVidaMaxima(this.status.getVidaMaxima() + escolha);
                            pontos = pontos - escolha;
                            break;
                        }
                        Console.WriteLine("Operação negada!");
                        break;
                    case 2:
                        Console.WriteLine("Quantos pontos deseja aplicar?\n");
                        escolha = Int32.Parse(Console.ReadLine());
                        if (escolha <= pontos && escolha > 0)
                        {
                            this.status.setManaMaxima(this.status.manamaxima + escolha);
                            pontos = pontos - escolha;
                            break;
                        }
                        Console.WriteLine("Operação negada!");
                        break;
                    case 3:
                        Console.WriteLine("Quantos pontos deseja aplicar?\n");
                        escolha = Int32.Parse(Console.ReadLine());
                        if (escolha <= pontos && escolha > 0)
                        {
                            this.status.forca = this.status.forca + escolha;
                            pontos = pontos - escolha;
                            break;
                        }
                        Console.WriteLine("Operação negada!");
                        break;
                    case 4:
                        Console.WriteLine("Quantos pontos deseja aplicar?\n");
                        escolha = Int32.Parse(Console.ReadLine());
                        if (escolha <= pontos && escolha > 0)
                        {
                            this.status.defesa = this.status.defesa + escolha;
                            pontos = pontos - escolha;
                            break;
                        }
                        Console.WriteLine("Operação negada!");
                        break;
                    default:
                        Console.WriteLine("Valor invalido");
                        break;
                }
            }

        }
        public void consumir(Consumivel item)
        {
            if(item.quantidade > 0)
            switch (item.Tipo)
            {
                case ("cura"):
                    Console.WriteLine("Você curou " + item.valor + " Usando " + item.getItemNome());
                    this.status.setVida(this.status.getVida() + item.valor);
                    item.quantidade = item.quantidade - 1;
                        this.mochila.verificarquantidade(item);
                    break;
                    case ("mana"):
                        Console.WriteLine("Você recuperou " + item.valor + " Usando " + item.getItemNome());
                        this.status.setMana(this.status.getMana() + item.valor);
                        item.quantidade = item.quantidade - 1;
                        this.mochila.verificarquantidade(item);
                    break;
            }
        }
        public void droparItem(Item item)
        {
            this.mochila.verificarquantidade(item);
            for (int i = 0; i < this.mochila.tamanho; i++)
            {
                if (mochila.slot[i].item.getItemNome() == item.getItemNome())
                {
                    mochila.slot[i] = new slot();
                    return;
                }
            }
        }
        public float ataque()
        {
            float dano = (this.status.forca + this.status.agilidade) * 1 + (new Random(DateTime.Now.Millisecond).Next(0, this.status.agilidade));
            Console.WriteLine($"{dano}");
            return dano;
        }
        public void recebeDano(Monstro montro)
        {

            float recebe = this.status.defesa - montro.ataque();
            if (recebe < 0)
            {
                this.status.setVida(this.status.getVida() + recebe);
            }
        }
    }

}
