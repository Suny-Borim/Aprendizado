using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Lenda_do_heroi.Arma;
namespace Lenda_do_heroi
{
    internal class Program
    {
        static void Main(string[] args)
        {
            bool Guerreira, Arqueira, Maga;
            Console.WriteLine("Welcome challenger!\nChoose your class!:\n1-Guerreiro\n2-Mago\n");
            int escolha = (Int32.Parse(Console.ReadLine()));
            switch (escolha)
            {
                case 1:
                    Console.WriteLine("Qual seu nome Guerreira?\n");
                    string nome = Console.ReadLine();
                    Guerreiro Suny = new Guerreiro(nome, 18);
                    Suny.MostraStatus();
                    
                    Goblin goblin1 = new Goblin(1);

                    float dano = Suny.ataque();

                    goblin1.recebeDano(dano);
                    goblin1.MostraStatus();
                    Console.ReadLine();
                    break;
            }
           
        }
    }
}
