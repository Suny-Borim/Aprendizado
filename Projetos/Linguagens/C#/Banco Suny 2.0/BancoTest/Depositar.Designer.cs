namespace BancoTest
{
    partial class Depositar
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
            this.txtvalor = new System.Windows.Forms.TextBox();
            this.Quantia = new System.Windows.Forms.Label();
            this.bttDepositar = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // txtvalor
            // 
            this.txtvalor.Location = new System.Drawing.Point(71, 31);
            this.txtvalor.Name = "txtvalor";
            this.txtvalor.Size = new System.Drawing.Size(100, 23);
            this.txtvalor.TabIndex = 0;
            this.txtvalor.TextChanged += new System.EventHandler(this.txtvalor_TextChanged);
            // 
            // Quantia
            // 
            this.Quantia.AutoSize = true;
            this.Quantia.Location = new System.Drawing.Point(16, 34);
            this.Quantia.Name = "Quantia";
            this.Quantia.Size = new System.Drawing.Size(49, 15);
            this.Quantia.TabIndex = 2;
            this.Quantia.Text = "Quantia";
            // 
            // bttDepositar
            // 
            this.bttDepositar.Location = new System.Drawing.Point(108, 65);
            this.bttDepositar.Name = "bttDepositar";
            this.bttDepositar.Size = new System.Drawing.Size(75, 23);
            this.bttDepositar.TabIndex = 3;
            this.bttDepositar.Text = "Depositar";
            this.bttDepositar.UseVisualStyleBackColor = true;
            this.bttDepositar.Click += new System.EventHandler(this.bttDepositar_Click);
            // 
            // Depositar
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.ClientSize = new System.Drawing.Size(214, 100);
            this.ControlBox = false;
            this.Controls.Add(this.bttDepositar);
            this.Controls.Add(this.Quantia);
            this.Controls.Add(this.txtvalor);
            this.MaximumSize = new System.Drawing.Size(230, 139);
            this.Name = "Depositar";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Depositar";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private TextBox txtvalor;
        private Label Quantia;
        private Button bttDepositar;
    }
}