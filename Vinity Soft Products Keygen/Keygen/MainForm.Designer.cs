namespace Keygen
{
    partial class MainForm
    {
        /// <summary>
        /// Designer variable used to keep track of non-visual components.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.PictureBox picBanner;
        private System.Windows.Forms.ComboBox cboProduct;
        private System.Windows.Forms.Button btnCopy;
        private System.Windows.Forms.Button btnAbout;
        private System.Windows.Forms.LinkLabel lblHomepage;
        private System.Windows.Forms.Label lblIdCode;
        private System.Windows.Forms.Label lblProduct;
        private System.Windows.Forms.TextBox txtIdCode;
        private System.Windows.Forms.Label lblActivationCode;
        private System.Windows.Forms.TextBox txtActivationCode;
        private System.Windows.Forms.Label lblEdition;
        private System.Windows.Forms.ComboBox cboEdition;
        private System.Windows.Forms.Label label1;
        
        /// <summary>
        /// Disposes resources used by the form.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing) {
                if (components != null) {
                    components.Dispose();
                }
            }
            base.Dispose(disposing);
        }
        
        /// <summary>
        /// This method is required for Windows Forms designer support.
        /// Do not change the method contents inside the source code editor. The Forms designer might
        /// not be able to load this method if it was changed manually.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.picBanner = new System.Windows.Forms.PictureBox();
            this.cboProduct = new System.Windows.Forms.ComboBox();
            this.btnCopy = new System.Windows.Forms.Button();
            this.btnAbout = new System.Windows.Forms.Button();
            this.lblHomepage = new System.Windows.Forms.LinkLabel();
            this.lblIdCode = new System.Windows.Forms.Label();
            this.lblProduct = new System.Windows.Forms.Label();
            this.txtIdCode = new System.Windows.Forms.TextBox();
            this.lblActivationCode = new System.Windows.Forms.Label();
            this.txtActivationCode = new System.Windows.Forms.TextBox();
            this.lblEdition = new System.Windows.Forms.Label();
            this.cboEdition = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.picBanner)).BeginInit();
            this.SuspendLayout();
            // 
            // picBanner
            // 
            this.picBanner.Dock = System.Windows.Forms.DockStyle.Top;
            this.picBanner.Image = ((System.Drawing.Image)(resources.GetObject("picBanner.Image")));
            this.picBanner.Location = new System.Drawing.Point(0, 0);
            this.picBanner.Name = "picBanner";
            this.picBanner.Size = new System.Drawing.Size(220, 84);
            this.picBanner.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBanner.TabIndex = 0;
            this.picBanner.TabStop = false;
            // 
            // cboProduct
            // 
            this.cboProduct.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboProduct.FormattingEnabled = true;
            this.cboProduct.Location = new System.Drawing.Point(12, 108);
            this.cboProduct.Name = "cboProduct";
            this.cboProduct.Size = new System.Drawing.Size(198, 21);
            this.cboProduct.TabIndex = 1;
            this.cboProduct.SelectedIndexChanged += new System.EventHandler(this.CboProductSelectedIndexChanged);
            // 
            // btnCopy
            // 
            this.btnCopy.Location = new System.Drawing.Point(120, 288);
            this.btnCopy.Name = "btnCopy";
            this.btnCopy.Size = new System.Drawing.Size(60, 24);
            this.btnCopy.TabIndex = 10;
            this.btnCopy.Text = "Copy";
            this.btnCopy.UseVisualStyleBackColor = true;
            this.btnCopy.Click += new System.EventHandler(this.BtnCopyClick);
            // 
            // btnAbout
            // 
            this.btnAbout.Location = new System.Drawing.Point(186, 288);
            this.btnAbout.Name = "btnAbout";
            this.btnAbout.Size = new System.Drawing.Size(24, 24);
            this.btnAbout.TabIndex = 11;
            this.btnAbout.Text = "?";
            this.btnAbout.UseVisualStyleBackColor = true;
            this.btnAbout.Click += new System.EventHandler(this.BtnAboutClick);
            // 
            // lblHomepage
            // 
            this.lblHomepage.Location = new System.Drawing.Point(12, 288);
            this.lblHomepage.Name = "lblHomepage";
            this.lblHomepage.Size = new System.Drawing.Size(108, 24);
            this.lblHomepage.TabIndex = 9;
            this.lblHomepage.TabStop = true;
            this.lblHomepage.Text = "Products Homepage";
            this.lblHomepage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblHomepage.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LblHomepageLinkClicked);
            // 
            // lblIdCode
            // 
            this.lblIdCode.Location = new System.Drawing.Point(12, 174);
            this.lblIdCode.Name = "lblIdCode";
            this.lblIdCode.Size = new System.Drawing.Size(198, 18);
            this.lblIdCode.TabIndex = 4;
            this.lblIdCode.Text = "Identification Code:";
            this.lblIdCode.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lblProduct
            // 
            this.lblProduct.Location = new System.Drawing.Point(12, 90);
            this.lblProduct.Name = "lblProduct";
            this.lblProduct.Size = new System.Drawing.Size(198, 18);
            this.lblProduct.TabIndex = 0;
            this.lblProduct.Text = "Product:";
            this.lblProduct.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txtIdCode
            // 
            this.txtIdCode.Location = new System.Drawing.Point(12, 192);
            this.txtIdCode.Name = "txtIdCode";
            this.txtIdCode.Size = new System.Drawing.Size(198, 20);
            this.txtIdCode.TabIndex = 5;
            this.txtIdCode.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.txtIdCode.TextChanged += new System.EventHandler(this.OnChange);
            // 
            // lblActivationCode
            // 
            this.lblActivationCode.Location = new System.Drawing.Point(12, 216);
            this.lblActivationCode.Name = "lblActivationCode";
            this.lblActivationCode.Size = new System.Drawing.Size(198, 18);
            this.lblActivationCode.TabIndex = 6;
            this.lblActivationCode.Text = "Activation Code:";
            this.lblActivationCode.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txtActivationCode
            // 
            this.txtActivationCode.BackColor = System.Drawing.SystemColors.Control;
            this.txtActivationCode.Location = new System.Drawing.Point(12, 234);
            this.txtActivationCode.Name = "txtActivationCode";
            this.txtActivationCode.ReadOnly = true;
            this.txtActivationCode.Size = new System.Drawing.Size(198, 20);
            this.txtActivationCode.TabIndex = 7;
            this.txtActivationCode.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // lblEdition
            // 
            this.lblEdition.Location = new System.Drawing.Point(12, 132);
            this.lblEdition.Name = "lblEdition";
            this.lblEdition.Size = new System.Drawing.Size(198, 18);
            this.lblEdition.TabIndex = 2;
            this.lblEdition.Text = "Edition:";
            this.lblEdition.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cboEdition
            // 
            this.cboEdition.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboEdition.FormattingEnabled = true;
            this.cboEdition.Location = new System.Drawing.Point(12, 150);
            this.cboEdition.Name = "cboEdition";
            this.cboEdition.Size = new System.Drawing.Size(198, 21);
            this.cboEdition.TabIndex = 3;
            this.cboEdition.SelectedIndexChanged += new System.EventHandler(this.OnChange);
            // 
            // label1
            // 
            this.label1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label1.ForeColor = System.Drawing.Color.Red;
            this.label1.Location = new System.Drawing.Point(12, 264);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(198, 18);
            this.label1.TabIndex = 8;
            this.label1.Text = "NOTE: Restart app after activation!";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(220, 322);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtActivationCode);
            this.Controls.Add(this.lblActivationCode);
            this.Controls.Add(this.txtIdCode);
            this.Controls.Add(this.lblIdCode);
            this.Controls.Add(this.lblHomepage);
            this.Controls.Add(this.btnAbout);
            this.Controls.Add(this.btnCopy);
            this.Controls.Add(this.cboEdition);
            this.Controls.Add(this.cboProduct);
            this.Controls.Add(this.picBanner);
            this.Controls.Add(this.lblEdition);
            this.Controls.Add(this.lblProduct);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.KeyPreview = true;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.MainFormLoad);
            this.Shown += new System.EventHandler(this.MainFormShown);
            this.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.MainFormKeyPress);
            ((System.ComponentModel.ISupportInitialize)(this.picBanner)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }
    }
}
