namespace Lenda_do_heroi
{
    internal class Armas
    {
        private string nome { get; set; }
        public Atributos atributos;

        public Armas(string nome, Atributos atributos)
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
