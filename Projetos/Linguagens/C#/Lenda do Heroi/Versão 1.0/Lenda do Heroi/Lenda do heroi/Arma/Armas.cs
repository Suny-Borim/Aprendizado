namespace Lenda_do_heroi
{
    internal class Armas : Item
    {
        public Atributos atributos;

        public Armas(string nome, Atributos atributos, string Classe)
        {
            base.setItemNome(nome);
            this.atributos = atributos;
            base.setClasseItem(Classe);
        }
    }
}
