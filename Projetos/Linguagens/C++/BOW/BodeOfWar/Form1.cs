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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            lblVersao.Text = Jogo.Versao;//mostra versao 
        }

        private void btnPartida_Click(object sender, EventArgs e)
        {
            lstPartida.Items.Clear(); //limpa a lstBox
            string retorno = Jogo.ListarPartidas("T");//T = todos, A = aberto

            if (retorno.Contains("ERRO:")) mostraErro(retorno);//se voltar um string de erro volta uma mensagem de erro
            else
            {
                retorno = retorno.Replace("\r", "");
                if(retorno.Length > 0) retorno = retorno.Substring(0, retorno.Length - 1);
                string[] partidas = retorno.Split('\n');

                for (int i = 0; i < partidas.Length; i++)
                {
                    lstPartida.Items.Add(partidas[i]);//adiciona na list box as partidas existentes
                }
            }

        }

        private void btnExibirPartidade_Click(object sender, EventArgs e)
        {
            if (lstPartida.SelectedItem != null)//verifica se o item na listbox existe
            {
                string partida = lstPartida.SelectedItem.ToString();
                string[] iten = partida.Split(',');

                txtIdPartida.Text = iten[0];//mostra id da partida selecionada
                string jogadores = Jogo.ListarJogadores(Int32.Parse(iten[0]));
                if (jogadores.Contains("ERRO:")) mostraErro(jogadores);//mostra erro
                else txtJogadores.Text = jogadores;

            }
            else mostraErro("ERRO: Nenhuma partida foi escolhida");
        }

        private void mostraErro(string erro)
        {
            MessageBox.Show(erro, "Erro", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }

        private void btnSelecionarPartida_Click(object sender, EventArgs e)
        {
            if (lstPartida.SelectedItem == null)
            {
                mostraErro("Nenhuma partida foi selecionado");
            }
            else
            {
                string partida = lstPartida.SelectedItem.ToString();
                string[] iten = partida.Split(',');
                var id = txtIdPartida.Text = iten[0];//pega o id da partida

                Login login = new Login(id);//manda o id da paritda para o login
                login.Show();//entra no forms do login
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void btnCriar_Click(object sender, EventArgs e)
        {
            CriarPartida partida = new CriarPartida();
            partida.Show();//entra no forms de criar partida
        }
    }
}
