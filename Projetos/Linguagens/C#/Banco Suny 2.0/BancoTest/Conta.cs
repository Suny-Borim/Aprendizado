using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BancoTest
{
    public class Conta 
    {
        public string titular;
        public string agencia;
        private string senha {get; set;}
        public string PIX;
        public double saldo;
        public Usuario usuario;
        public List<string> extrato;
        public Conta(string titular, string agencia, string senha , string pix, Usuario usuario)
        {
            this.titular = titular;
            this.agencia = agencia;
            this.senha = senha;
            this.PIX = pix;
            this.usuario = usuario;
            this.saldo = 0;
            this.extrato = new List<string>();
        }
        public void log(string log)
        {
            this.extrato.Add(log);
        }
        public bool senhacerta(string senha)
        {
            return this.senha.Equals(senha);
        }
        public bool depositar(double valor)
        {
            if(valor > 0)
            {
                this.saldo += valor;
                this.log($"Valor depositado na sua conta no valor de R${valor}");
                return true;
            }
            return false;
        }
        public bool sacar(double valor)
        {
            if(this.saldo <= valor)
            {
                this.saldo -= valor;
                this.log($"Saque realizado no valor de $R{valor}");
                return true;
            }
            return false;
        }
        public bool transferir(Conta conta,double valor)
        {
            if (valor > 0 && this.saldo >= valor)
            {
                conta.receber(valor);
                this.transferirvalor(valor);
                this.log($"Valor transferido entre contas do mesmo banco no valor de R${valor} para {conta.titular}");
                return true;
            }
            return false;
        }
        public void receber(double valor)
        {
            this.saldo += valor;
            this.log($"PIX recebido no valor de R${valor}");
        }
        public void transferirvalor(double valor)
        {
            this.saldo = this.saldo - valor;
        }
    }
}
