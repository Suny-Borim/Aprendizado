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
    public partial class Login : Form
    {
        private string idPartida;
        public Login(String id)
        {
            this.idPartida = id;
            InitializeComponent();
        }

        private void Login_Load(object sender, EventArgs e)
        {
            this.Location = MousePosition;
        }

        private void btnLogar_Click(object sender, EventArgs e)
        {
            string senha = txtSenha.Text;
            string nome = txtNome.Text;
            int id = Int32.Parse(idPartida);

            //checa se esta re entrando em uma partida
            string[] info = ToolBox.CarregaLogin(id);
            if (info == null) //partida nova
            {
                //salva o login
                string idJogador = Jogo.EntrarPartida(id, nome, senha);
                if (ToolBox.Erro(idJogador))
                {
                    return;
                }
                string[] iten = idJogador.Split(',');

                ToolBox.SalvaLogin(iten[0], iten[1], id, 0);
                Bode bode = new Bode(iten[0], iten[1], Int32.Parse(this.idPartida), 0);
                bode.Show();
                this.Close();
            }
            else //logando de novo na partida
            {
                Bode bode = new Bode(info[0], info[1], Int32.Parse(info[2]), Int32.Parse(info[3]));
                bode.Show();
                this.Close();
            }
            
        }
    }
}
