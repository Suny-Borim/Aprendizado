using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Banco
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Cliente Suny = new Cliente("Suny", "23", "Dom quixote");
            Cliente Nicolly = new Cliente("Nicolly", "23", "Dom quixote");
            Conta carinha = new Conta(1000f, 0188, 125456,Suny);
            Conta carinha2 = new Conta(1000f, 0178, 127456,Nicolly);

            carinha2.saque(100f);
            carinha.transferir(carinha2, 100f);
            carinha.exibir();
            carinha2.exibir();
            Console.ReadLine();

        }
    }
}
