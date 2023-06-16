namespace Lenda_do_heroi

{
    internal class Status
    {
        private float vida;
        private float vidamaxima;
        public float mana;
        public float manamaxima;
        public float forca;
        public int defesa;
        public int agilidade;
        public int sorte;

        public Status(float vida, int mana, float forca, int defesa, int agilidade, int sorte)
        {
            this.vida = vida;
            this.vidamaxima = vida;
            this.manamaxima = mana;
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
        public float getMana()
        {
            return this.mana;
        }
        public void setMana(float mana)
        {
            if(this.mana + mana > manamaxima)
            {
                this.mana = this.manamaxima;
            }
            else this.mana = this.mana + mana;
        }
        public void setManaMaxima(float manamaxima)
        {
             this.manamaxima = this.mana + manamaxima;
        }
    }
}
