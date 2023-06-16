using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi
{
    internal class Consumivel: Item
    {
        public string Tipo;
        public float valor;
        public Consumivel(string nome,string tipo,float valor)
        {
        this.setItemNome(nome);
        this.Tipo = tipo;
        this.valor = valor;
        this.quantidade = 1;
        }
    }
}
