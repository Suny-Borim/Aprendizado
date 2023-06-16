namespace BancoTest
{
    partial class ContaAtual
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.lblNome = new System.Windows.Forms.Label();
            this.lblSaldo = new System.Windows.Forms.Label();
            this.lbxExtrato = new System.Windows.Forms.ListBox();
            this.bttDepositar = new System.Windows.Forms.Button();
            this.bttTransferir = new System.Windows.Forms.Button();
            this.bttSair = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // lblNome
            // 
            this.lblNome.AutoSize = true;
            this.lblNome.Location = new System.Drawing.Point(12, 9);
            this.lblNome.Name = "lblNome";
            this.lblNome.Size = new System.Drawing.Size(40, 15);
            this.lblNome.TabIndex = 0;
            this.lblNome.Text = "Nome";
            // 
            // lblSaldo
            // 
            this.lblSaldo.AutoSize = true;
            this.lblSaldo.Font = new System.Drawing.Font("Segoe UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.lblSaldo.Location = new System.Drawing.Point(23, 40);
            this.lblSaldo.Name = "lblSaldo";
            this.lblSaldo.Size = new System.Drawing.Size(62, 25);
            this.lblSaldo.TabIndex = 1;
            this.lblSaldo.Text = "Saldo";
            this.lblSaldo.Click += new System.EventHandler(this.lblSaldo_Click);
            // 
            // lbxExtrato
            // 
            this.lbxExtrato.FormattingEnabled = true;
            this.lbxExtrato.ItemHeight = 15;
            this.lbxExtrato.Location = new System.Drawing.Point(282, 87);
            this.lbxExtrato.Name = "lbxExtrato";
            this.lbxExtrato.Size = new System.Drawing.Size(495, 274);
            this.lbxExtrato.TabIndex = 2;
            // 
            // bttDepositar
            // 
            this.bttDepositar.Location = new System.Drawing.Point(23, 87);
            this.bttDepositar.Name = "bttDepositar";
            this.bttDepositar.Size = new System.Drawing.Size(161, 66);
            this.bttDepositar.TabIndex = 3;
            this.bttDepositar.Text = "Depositar";
            this.bttDepositar.UseVisualStyleBackColor = true;
            this.bttDepositar.Click += new System.EventHandler(this.bttDepositar_Click);
            // 
            // bttTransferir
            // 
            this.bttTransferir.Location = new System.Drawing.Point(23, 176);
            this.bttTransferir.Name = "bttTransferir";
            this.bttTransferir.Size = new System.Drawing.Size(161, 66);
            this.bttTransferir.TabIndex = 4;
            this.bttTransferir.Text = "Transferir";
            this.bttTransferir.UseVisualStyleBackColor = true;
            this.bttTransferir.Click += new System.EventHandler(this.bttTransferir_Click);
            // 
            // bttSair
            // 
            this.bttSair.Location = new System.Drawing.Point(702, 367);
            this.bttSair.Name = "bttSair";
            this.bttSair.Size = new System.Drawing.Size(75, 23);
            this.bttSair.TabIndex = 5;
            this.bttSair.Text = "Sair";
            this.bttSair.UseVisualStyleBackColor = true;
            this.bttSair.Click += new System.EventHandler(this.bttSair_Click);
            // 
            // ContaAtual
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(789, 395);
            this.Controls.Add(this.bttSair);
            this.Controls.Add(this.bttTransferir);
            this.Controls.Add(this.bttDepositar);
            this.Controls.Add(this.lbxExtrato);
            this.Controls.Add(this.lblSaldo);
            this.Controls.Add(this.lblNome);
            this.MinimumSize = new System.Drawing.Size(805, 434);
            this.Name = "ContaAtual";
            this.Text = "ContaAtual";
            this.Load += new System.EventHandler(this.ContaAtual_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Label lblNome;
        private Label lblSaldo;
        private ListBox lbxExtrato;
        private Button bttDepositar;
        private Button bttTransferir;
        private Button bttSair;
    }
}