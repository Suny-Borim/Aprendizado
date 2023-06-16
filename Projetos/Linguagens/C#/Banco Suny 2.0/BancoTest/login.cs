using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BancoTest
{
    public partial class login : Form
    {
        List<Conta> ListaDecontas { get; set; }
        public login(List<Conta> lista)
        {
            InitializeComponent();
            this.ListaDecontas = lista;
        }

        private void login_Load(object sender, EventArgs e)
        {
        }
        private void bttEntrar_Click(object sender, EventArgs e)
        {
            foreach (Conta conta in this.ListaDecontas)
            {
                if (txtCPF.Text == conta.usuario.cpf && conta.senhacerta(txtsenha.Text))
                {
                    ContaAtual contaatual = new ContaAtual(conta,this.ListaDecontas);
                    this.Close();
                    contaatual.ShowDialog();
                }
            }
        }
    }
}
