namespace Lenda_do_heroi
{
    internal class Armas
    {
        private string nome { get; set; }
        private string Classe;
        public Atributos atributos;

        public Armas(string nome, Atributos atributos,string Classe)
        {
            this.setNomeArmas(nome);
            this.atributos = atributos;
            this.setClasse(Classe);
        }
        public string getNomeArmas()
        {
            return this.nome;
        }
        public void setNomeArmas(string nome)
        {
            this.nome = nome;
        }
        public string getClasse()
        {
            return this.Classe;
        }
        public void setClasse(string classe)
        {
            this.Classe = classe;
        }
    }
}
