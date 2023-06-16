using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi
{
    internal class armadura : Item
    {
        public Atributos Atributos;
        private string partedocorpo { get; set; }

        public armadura(string nome,string partedocorpo,string classe,Atributos atributos)
        {
            this.setItemNome(nome);
            this.setClasseItem(classe);
            this.partedocorpo = partedocorpo;
            this.quantidade = 1;
            this.Atributos = atributos;
        }
        public string getpartedocorpo()
        {
            return this.partedocorpo;
        }
    }
}
