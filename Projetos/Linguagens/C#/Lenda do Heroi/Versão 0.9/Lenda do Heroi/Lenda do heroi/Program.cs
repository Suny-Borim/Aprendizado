using System;
namespace Lenda_do_heroi
{
    internal class Program
    {
        static void Main(string[] args)
        {
            bool Guerreira, Arqueira, Maga;
            Atributos BrokenSwordStatus = new Atributos(0, 10, 0, 0, 30);

            Armas BrokenSword = new Armas("BrokenSword", BrokenSwordStatus,"Guerreiro");
            Console.WriteLine("Welcome challenger!\nChoose your class!:\n1-Warrior\n2-Archer\n");
            int escolha = (Int32.Parse(Console.ReadLine()));
            switch (escolha)
            {
                case 1:
                    Console.WriteLine("Qual seu nome Guerreira?\n");
                    string nome = Console.ReadLine();
                    
                    Guerreiro Warrior = new Guerreiro(nome, 18);
                    Warrior.MostraStatus();
                    Warrior.colocar(BrokenSword);
                    Warrior.mostrarmochila();
                    Warrior.equiparArma(BrokenSword);
                    Warrior.Desequipar(BrokenSword);
                    Warrior.MostraStatus();

                    Goblin goblin1 = new Goblin(1);

                    float dano = Warrior.ataque();

                    goblin1.recebeDano(dano);
                    goblin1.MostraStatus();
                    Console.ReadLine();
                    break;
                case 2:
                    Console.WriteLine("Qual seu nome Arqueira?\n");
                    string ArcherName = Console.ReadLine();

                    Arqueiro Archer = new Arqueiro(ArcherName, 18,100);
                    Archer.MostraStatus();
                    Console.ReadLine();

                    Goblin goblin2 = new Goblin(1);

                    float danoArcher = Archer.ataque();

                    goblin2.recebeDano(danoArcher);
                    goblin2.MostraStatus();
                    Archer.MostraStatus();

                    Console.ReadLine();
                    break;
                case 3:
                    Console.WriteLine("Qual seu nome Mago?\n");
                    string MageName = Console.ReadLine();

                    Arqueiro Mage = new Arqueiro(MageName, 18, 100);
                    Mage.MostraStatus();
                    Console.ReadLine();

                    Goblin goblin3 = new Goblin(1);

                    float danoMage = Mage.ataque();

                    goblin3.recebeDano(danoMage);
                    goblin3.MostraStatus();
                    Mage.MostraStatus();

                    Console.ReadLine();
                    break;

            }

        }
    }
}
