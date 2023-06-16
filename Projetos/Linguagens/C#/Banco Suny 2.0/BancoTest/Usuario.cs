using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BancoTest
{
    public class Usuario
    {
        public string nome;
        public string cpf;
        public Usuario(string nome,string cpf)
        {
            this.cpf = cpf;
            this.nome = nome;
        }
    }
}
