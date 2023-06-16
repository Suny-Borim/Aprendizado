using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi
{
	internal class Item
	{
        string nome;
		private string classe;
	    

        public string getItemNome()
        {
            return this.nome;
        }
        public void setItemNome(string nome)
        {
            this.nome = nome;
        }
        public string getClasse()
        {
            return this.classe;
        }
        public void setClasseItem(string classe)
        {
            this.classe = classe;
        }
    }
}
