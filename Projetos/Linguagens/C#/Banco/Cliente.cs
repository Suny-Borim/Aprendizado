using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Banco
{
    internal class Cliente
    {
        public string titular, cpf, endereco;
        public Cliente(string titular,string cpf,string endereco)
        {
            this.titular = titular;
            this.cpf = cpf; 
            this.endereco = endereco;   

        }
    }
}
