using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lenda_do_heroi
{
    internal class Arqueiro : Heroi
    {
        private int flechas;
        public Arqueiro(string nome, int idade, int flechas)
        {
            this.setNome(nome);
            this.setIdade(idade);
            this.flechas = flechas;
            this.setLv(1);
            Corpo corpo = new Corpo("cabeca", false, "torso", false, "maos", false, "pernas", false, "pes", false);
            this.setCorpo(corpo);
            Status status = new Status(10, 10, 10, 10, 10, 10);
            this.setStatus(status);

        }

    }
}
