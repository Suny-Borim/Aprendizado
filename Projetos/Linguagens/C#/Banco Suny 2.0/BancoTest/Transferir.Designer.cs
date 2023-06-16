namespace BancoTest
{
    partial class Transferir
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
            this.bttTransferir = new System.Windows.Forms.Button();
            this.lblDestinatario = new System.Windows.Forms.Label();
            this.lblValor = new System.Windows.Forms.Label();
            this.txtPIX = new System.Windows.Forms.TextBox();
            this.txtValor = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // bttTransferir
            // 
            this.bttTransferir.Location = new System.Drawing.Point(137, 105);
            this.bttTransferir.Name = "bttTransferir";
            this.bttTransferir.Size = new System.Drawing.Size(75, 23);
            this.bttTransferir.TabIndex = 0;
            this.bttTransferir.Text = "Transferir";
            this.bttTransferir.UseVisualStyleBackColor = true;
            this.bttTransferir.Click += new System.EventHandler(this.bttTransferir_Click);
            // 
            // lblDestinatario
            // 
            this.lblDestinatario.AutoSize = true;
            this.lblDestinatario.Location = new System.Drawing.Point(29, 30);
            this.lblDestinatario.Name = "lblDestinatario";
            this.lblDestinatario.Size = new System.Drawing.Size(24, 15);
            this.lblDestinatario.TabIndex = 1;
            this.lblDestinatario.Text = "PIX";
            // 
            // lblValor
            // 
            this.lblValor.AutoSize = true;
            this.lblValor.Location = new System.Drawing.Point(20, 71);
            this.lblValor.Name = "lblValor";
            this.lblValor.Size = new System.Drawing.Size(33, 15);
            this.lblValor.TabIndex = 2;
            this.lblValor.Text = "Valor";
            // 
            // txtPIX
            // 
            this.txtPIX.Location = new System.Drawing.Point(73, 27);
            this.txtPIX.Name = "txtPIX";
            this.txtPIX.Size = new System.Drawing.Size(100, 23);
            this.txtPIX.TabIndex = 3;
            // 
            // txtValor
            // 
            this.txtValor.Location = new System.Drawing.Point(73, 68);
            this.txtValor.Name = "txtValor";
            this.txtValor.Size = new System.Drawing.Size(100, 23);
            this.txtValor.TabIndex = 4;
            // 
            // Transferir
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(222, 135);
            this.ControlBox = false;
            this.Controls.Add(this.txtValor);
            this.Controls.Add(this.txtPIX);
            this.Controls.Add(this.lblValor);
            this.Controls.Add(this.lblDestinatario);
            this.Controls.Add(this.bttTransferir);
            this.Name = "Transferir";
            this.Text = "Transferir";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Button bttTransferir;
        private Label lblDestinatario;
        private Label lblValor;
        private TextBox txtPIX;
        private TextBox txtValor;
    }
}