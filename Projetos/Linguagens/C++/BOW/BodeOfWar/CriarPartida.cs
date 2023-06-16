using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using BodeOfWarServer;

namespace BodeOfWar
{
    public partial class CriarPartida : Form
    {
        public CriarPartida()
        {
            InitializeComponent();
        }

        private void CriarPartida_Load(object sender, EventArgs e)
        {
            this.Location = MousePosition;
        }

        private void mostraErro(string erro)
        {
            MessageBox.Show(erro, "Erro", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }

        private void btnCriarPartida_Click_1(object sender, EventArgs e)
        {
            string nomeP = txtNome.Text;
            string senhaP = txtSenha.Text;

            int idPartida;

            string erro = Jogo.CriarPartida(nomeP, senhaP);
            if (!(int.TryParse(erro, out idPartida)))
            {
                mostraErro(erro);
                return;
            }

            this.Close();
        }
    }
}
