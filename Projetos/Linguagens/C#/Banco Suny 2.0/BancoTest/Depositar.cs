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
    public partial class Depositar : Form
    {
        Conta conta;
        public Depositar(Conta conta)
        {
            InitializeComponent();
            this.conta = conta;
        }

        private void txtvalor_TextChanged(object sender, EventArgs e)
        {

        }

        private void bttDepositar_Click(object sender, EventArgs e)
        {
            this.conta.depositar(Int32.Parse(txtvalor.Text));
            this.Close();
        }
    }
}
