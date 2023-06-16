namespace Lenda_do_heroi

{
    internal class Status
    {
        private float vida;
        private float vidamaxima;
        public int mana;
        public float forca;
        public int defesa;
        public int agilidade;
        public int sorte;

        public Status(float vida, int mana, float forca, int defesa, int agilidade, int sorte)
        {
            this.vida = vida;
            this.vidamaxima = vida;
            this.mana = mana;
            this.forca = forca;
            this.defesa = defesa;
            this.agilidade = agilidade;
            this.sorte = sorte;
        }

        public float getVida()
        {
            return this.vida;
        }
        public void setVida(float vida)
        {
            if (this.vida + vida> vidamaxima)
            {
                this.vida = this.vidamaxima;
            }
            else this.vida = vida;
        }
        public float getVidaMaxima()
        {
            return this.vidamaxima;
        }
        public void setVidaMaxima(float vidamaxima)
        {
            this.vidamaxima = vidamaxima;
        }
    }
}
