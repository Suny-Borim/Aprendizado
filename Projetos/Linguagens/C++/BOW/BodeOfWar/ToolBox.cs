using System;
using System.IO;
using System.Windows.Forms;

/*
    Funções usadas para facilitar algo ou repetidas em varios lugares que não fazem sentido estarem em uma classe especifica
 */

namespace BodeOfWar
{
    internal abstract class ToolBox
    {
        //Checa se o servidor retornou um erro se sim volta true e mostra uma Mensage box deste, se não retorna false
        public static bool Erro(string erro)
        {
            if (erro.Contains("ERRO:"))
            {
                MessageBox.Show(erro, "Erro", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return true;
            }
            return false;
        }
        public static bool ErroSemMensagem(string erro)
        {
            if (erro.Contains("ERRO:"))
            { 
                return true;
            }
            return false;
        }

        //salva em um arquivo login.txt as sequintes informações, e dessa maneira idJogador,senhaJogador,idPartida, valorBode
        public static void SalvaLogin(string idJogador, string senhaJogador, int idPartida, int valorBode)
        {
            try
            {
                string text = idJogador + "," + senhaJogador + "," + idPartida.ToString() + "," + valorBode.ToString();
                string file = AppDomain.CurrentDomain.BaseDirectory.ToString() + "login.txt";
                StreamWriter escreve = new StreamWriter(file);
                escreve.WriteLine(text);
                escreve.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine("Não foi possivel escrever no arquivo");
                Console.WriteLine(e.Message);
            }
        }

        //carerga as informações salvas no login.txt
        public static string[] CarregaLogin(int idPartida)
        {
            try
            {
                string file = AppDomain.CurrentDomain.BaseDirectory.ToString() + "login.txt";
                StreamReader ler = new StreamReader(file);
                string text = ler.ReadToEnd().Trim();
                ler.Close();
                string[] iten = text.Split(',');
                if (Int32.Parse(iten[2]) == idPartida)
                {
                    Console.WriteLine("Logando na partida");
                    return iten;
                }
                else
                {
                    Console.WriteLine("Nâo é a mesma partida");
                    return null;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Não foi possivel ler o arquivo");
                Console.WriteLine(e.Message);
            }
            return null;
        }
    }
}
