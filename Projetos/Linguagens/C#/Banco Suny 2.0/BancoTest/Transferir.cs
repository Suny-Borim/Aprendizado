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
    public partial class Transferir : Form
    {
        Conta contaatual;
        List<Conta> contaList;
        public Transferir(Conta contaa,List<Conta> lista)
        {
            InitializeComponent();
            this.contaatual = contaa;
            this.contaList = lista;
        }

        private void bttTransferir_Click(object sender, EventArgs e)
        {
            foreach(Conta conta in this.contaList)
            {
                if (conta.PIX == txtPIX.Text)
                {
                    this.contaatual.transferir(conta, Int32.Parse(txtValor.Text));
                }
            }
            this.Close();
        }
    }
}
