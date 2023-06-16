namespace Lenda_do_heroi
{
    internal class Goblin : Monstro
    {
        public Goblin(int lv)
        {
            this.SetNomeM("Goblin");
            this.setLvM(lv);
            this.setXp(100);
            Status statusGoblin = new Status(50, 0, 35, 15, 20, 10);
            this.setStatusM(statusGoblin);
        }
    }
}
