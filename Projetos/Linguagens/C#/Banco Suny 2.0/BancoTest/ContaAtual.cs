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
    public partial class ContaAtual : Form
    {
        Conta contaatual { get; set; }
        List<Conta> contas { get; set; }
        public ContaAtual(Conta conta,List<Conta> contas)
        {
            InitializeComponent();
            contaatual = conta;
            this.contas = contas;
        }

        private void ContaAtual_Load(object sender, EventArgs e)
        {
            lblNome.Text = contaatual.usuario.nome;
            lblSaldo.Text = contaatual.saldo.ToString();
            lbxExtrato.Items.Clear();
        }

        private void lblSaldo_Click(object sender, EventArgs e)
        {

        }

        private void bttDepositar_Click(object sender, EventArgs e)
        {
            Depositar depositar = new Depositar(contaatual);
            depositar.ShowDialog();
            atualiza();
        }

        public void atualiza()
        {
            lblNome.Text = contaatual.usuario.nome;
            lblSaldo.Text = contaatual.saldo.ToString();
            lbxExtrato.Items.Clear();
            foreach(string extrato in this.contaatual.extrato)
            {
                lbxExtrato.Items.Add(extrato);
            }
        }

        private void bttTransferir_Click(object sender, EventArgs e)
        {
            Transferir transferir = new Transferir(contaatual, contas);
            transferir.ShowDialog();
            atualiza();
        }

        private void bttSair_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
