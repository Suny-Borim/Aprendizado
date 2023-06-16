using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Banco
{
    internal class Conta
    {
        double saldo;
        int agencia, numero;
        Cliente cliente;

        public Conta(double saldo, int agencia, int numero,Cliente cliente)
        {
            this.saldo = saldo;
            this.agencia = agencia;
            this.numero = numero;
            this.cliente = cliente;

        }

        public bool saque(double valor)
        {
            /*
            Console.WriteLine("digite o valor que deseja sacar");
            int valor = int.Parse(Console.ReadLine());
            */
            if (valor <= saldo)
            {
                this.saldo -= valor;
                return true;
            }
            else Console.WriteLine("seu saldo é insuficiente");
            return false;
        }
        public void exibir()
        {
            Console.WriteLine("-----\nTitular:{0}\ncpf:{1}\nSaldo:{2}\n------\n", this.cliente.titular, this.cliente.cpf, this.saldo);
        }
        public void depositar(double valor)
        {
            if (valor > 0)
                this.saldo += valor;
            else Console.WriteLine("Transação cancelada");
        }
        public void transferir(Conta conta, double valor)
        {
            Console.WriteLine("Opção transferência selecionada");
            if (this.saque(valor))
            {
                Console.WriteLine("Depositado na conta de {0} foi {1}", conta.cliente.titular, valor);
                conta.depositar(valor);
            }
        }
    }
}
