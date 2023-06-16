
namespace BodeOfWar
{
    partial class Form1
    {
        /// <summary>
        /// Variável de designer necessária.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpar os recursos que estão sendo usados.
        /// </summary>
        /// <param name="disposing">true se for necessário descartar os recursos gerenciados; caso contrário, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código gerado pelo Windows Form Designer

        /// <summary>
        /// Método necessário para suporte ao Designer - não modifique 
        /// o conteúdo deste método com o editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnPartida = new System.Windows.Forms.Button();
            this.lstPartida = new System.Windows.Forms.ListBox();
            this.btnExibirPartidade = new System.Windows.Forms.Button();
            this.txtIdPartida = new System.Windows.Forms.TextBox();
            this.lblIdPartida = new System.Windows.Forms.Label();
            this.lblJogadores = new System.Windows.Forms.Label();
            this.txtJogadores = new System.Windows.Forms.TextBox();
            this.lblVersao = new System.Windows.Forms.Label();
            this.btnSelecionarPartida = new System.Windows.Forms.Button();
            this.btnCriar = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnPartida
            // 
            this.btnPartida.Location = new System.Drawing.Point(120, 178);
            this.btnPartida.Name = "btnPartida";
            this.btnPartida.Size = new System.Drawing.Size(94, 23);
            this.btnPartida.TabIndex = 0;
            this.btnPartida.Text = "Listar Partidas";
            this.btnPartida.UseVisualStyleBackColor = true;
            this.btnPartida.Click += new System.EventHandler(this.btnPartida_Click);
            // 
            // lstPartida
            // 
            this.lstPartida.FormattingEnabled = true;
            this.lstPartida.Location = new System.Drawing.Point(15, 12);
            this.lstPartida.Name = "lstPartida";
            this.lstPartida.Size = new System.Drawing.Size(199, 160);
            this.lstPartida.TabIndex = 1;
            // 
            // btnExibirPartidade
            // 
            this.btnExibirPartidade.Location = new System.Drawing.Point(285, 123);
            this.btnExibirPartidade.Name = "btnExibirPartidade";
            this.btnExibirPartidade.Size = new System.Drawing.Size(75, 23);
            this.btnExibirPartidade.TabIndex = 2;
            this.btnExibirPartidade.Text = "Exibir";
            this.btnExibirPartidade.UseVisualStyleBackColor = true;
            this.btnExibirPartidade.Click += new System.EventHandler(this.btnExibirPartidade_Click);
            // 
            // txtIdPartida
            // 
            this.txtIdPartida.Location = new System.Drawing.Point(285, 16);
            this.txtIdPartida.Name = "txtIdPartida";
            this.txtIdPartida.ReadOnly = true;
            this.txtIdPartida.Size = new System.Drawing.Size(60, 20);
            this.txtIdPartida.TabIndex = 3;
            // 
            // lblIdPartida
            // 
            this.lblIdPartida.AutoSize = true;
            this.lblIdPartida.Location = new System.Drawing.Point(258, 19);
            this.lblIdPartida.Name = "lblIdPartida";
            this.lblIdPartida.Size = new System.Drawing.Size(21, 13);
            this.lblIdPartida.TabIndex = 4;
            this.lblIdPartida.Text = "ID:";
            // 
            // lblJogadores
            // 
            this.lblJogadores.AutoSize = true;
            this.lblJogadores.Location = new System.Drawing.Point(220, 46);
            this.lblJogadores.Name = "lblJogadores";
            this.lblJogadores.Size = new System.Drawing.Size(59, 13);
            this.lblJogadores.TabIndex = 5;
            this.lblJogadores.Text = "Jogadores:";
            // 
            // txtJogadores
            // 
            this.txtJogadores.Location = new System.Drawing.Point(285, 42);
            this.txtJogadores.Multiline = true;
            this.txtJogadores.Name = "txtJogadores";
            this.txtJogadores.ReadOnly = true;
            this.txtJogadores.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtJogadores.Size = new System.Drawing.Size(91, 75);
            this.txtJogadores.TabIndex = 6;
            // 
            // lblVersao
            // 
            this.lblVersao.AutoSize = true;
            this.lblVersao.Location = new System.Drawing.Point(12, 212);
            this.lblVersao.Name = "lblVersao";
            this.lblVersao.Size = new System.Drawing.Size(35, 13);
            this.lblVersao.TabIndex = 12;
            this.lblVersao.Text = "label1";
            // 
            // btnSelecionarPartida
            // 
            this.btnSelecionarPartida.Location = new System.Drawing.Point(285, 178);
            this.btnSelecionarPartida.Name = "btnSelecionarPartida";
            this.btnSelecionarPartida.Size = new System.Drawing.Size(75, 23);
            this.btnSelecionarPartida.TabIndex = 13;
            this.btnSelecionarPartida.Text = "Entrar";
            this.btnSelecionarPartida.UseVisualStyleBackColor = true;
            this.btnSelecionarPartida.Click += new System.EventHandler(this.btnSelecionarPartida_Click);
            // 
            // btnCriar
            // 
            this.btnCriar.Location = new System.Drawing.Point(15, 178);
            this.btnCriar.Name = "btnCriar";
            this.btnCriar.Size = new System.Drawing.Size(75, 23);
            this.btnCriar.TabIndex = 14;
            this.btnCriar.Text = "Criar";
            this.btnCriar.UseVisualStyleBackColor = true;
            this.btnCriar.Click += new System.EventHandler(this.btnCriar_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(390, 234);
            this.Controls.Add(this.btnCriar);
            this.Controls.Add(this.btnSelecionarPartida);
            this.Controls.Add(this.lblVersao);
            this.Controls.Add(this.txtJogadores);
            this.Controls.Add(this.lblJogadores);
            this.Controls.Add(this.lblIdPartida);
            this.Controls.Add(this.txtIdPartida);
            this.Controls.Add(this.btnExibirPartidade);
            this.Controls.Add(this.lstPartida);
            this.Controls.Add(this.btnPartida);
            this.MaximizeBox = false;
            this.MaximumSize = new System.Drawing.Size(406, 273);
            this.MinimumSize = new System.Drawing.Size(406, 273);
            this.Name = "Form1";
            this.RightToLeftLayout = true;
            this.Text = "BodeOfWar";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnPartida;
        private System.Windows.Forms.ListBox lstPartida;
        private System.Windows.Forms.Button btnExibirPartidade;
        private System.Windows.Forms.TextBox txtIdPartida;
        private System.Windows.Forms.Label lblIdPartida;
        private System.Windows.Forms.Label lblJogadores;
        private System.Windows.Forms.TextBox txtJogadores;
        private System.Windows.Forms.Label lblVersao;
        private System.Windows.Forms.Button btnSelecionarPartida;
        private System.Windows.Forms.Button btnCriar;
    }
}

