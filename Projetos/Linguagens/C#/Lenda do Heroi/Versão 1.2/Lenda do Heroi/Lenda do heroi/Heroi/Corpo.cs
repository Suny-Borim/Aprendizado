namespace Lenda_do_heroi
{
    internal class Corpo
    {
        public string cabeca;
        public armadura cabecaarmadura;
        public bool cabecabool;
        public string torso;
        public bool torsobool;
        public string maos;
        public bool maosbool;
        public string pernas;
        public bool pernasbool;
        public string pes;
        public bool pesbool;

        public Corpo(string cabeca,bool cabecabool, string torso,bool torsobool,string maos,
                      bool maosbool, string pernas,bool pernasbool, string pes,bool pesbool)
        {
            this.cabeca = cabeca;
            this.cabecabool = cabecabool;
            this.torso = torso;
            this.torsobool = torsobool;
            this.maos = maos;
            this.maosbool = maosbool;
            this.pernas = pernas;
            this.pernasbool = pesbool;
            this.pes = pes;
            this.pesbool = pesbool;
        }
    }
}
