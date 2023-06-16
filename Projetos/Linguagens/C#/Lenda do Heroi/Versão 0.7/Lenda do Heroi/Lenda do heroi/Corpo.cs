namespace Lenda_do_heroi
{
    internal class Corpo
    {
        public string cabeca;
        public string torso;
        public bool maos;
        public string pernas;
        public string pes;
        public Armas arma;

        public Corpo(string cabeca, string torso, bool maos, string pernas, string pes)
        {
            this.cabeca = cabeca;
            this.torso = torso;
            this.maos = maos;
            this.pernas = pernas;
            this.pes = pes;
        }
    }
}
