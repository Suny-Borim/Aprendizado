using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Lenda_do_heroi.Arma
{
    internal class Armas
    {
        private string nome { get; set; }
        public Atributos atributos;

        
        public Armas(string nome,Atributos atributos)
        {
            this.nome = nome;
            this.atributos = atributos;
        }
        public string getNomeArmas()
        {
            return this.nome;
        }
        public void setNomeArmas(string nome)
        {
            this.nome = nome;
        }
    }
}
