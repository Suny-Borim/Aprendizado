namespace BancoTest
{
    public partial class Form1 : Form
    {
        List<Conta> ListaDecontas { get; set; }
        public Form1()
        {
            InitializeComponent();
            this.ListaDecontas = new List<Conta>();
            this.ListaDecontas.Add(new Conta("Suny", "0123", "123456", "1", new Usuario("Suny", "1")));
            this.ListaDecontas.Add(new Conta("Donzela", "0123", "123456", "2", new Usuario("Donzela", "2")));
        }

        private void bttlogin_Click(object sender, EventArgs e)
        {
            login login = new login(ListaDecontas);
            login.ShowDialog();
        }
    }
}