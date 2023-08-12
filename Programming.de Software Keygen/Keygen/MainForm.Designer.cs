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
        private System.Windows.Forms.Button btnCopyLicenseKey;
        private System.Windows.Forms.Button btnAbout;
        private System.Windows.Forms.LinkLabel lblHomepage;
        private System.Windows.Forms.Label lblProduct;
        private System.Windows.Forms.Label lblActivationKey;
        private System.Windows.Forms.TextBox txtActivationKey;
        private System.Windows.Forms.Label lblLicenseKey;
        private System.Windows.Forms.Button btnGenerate;
        private System.Windows.Forms.TextBox txtLicenseKey;
        private System.Windows.Forms.Button btnCopyActivationKey;
        private System.Windows.Forms.ToolTip toolTip;
        
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.picBanner = new System.Windows.Forms.PictureBox();
            this.cboProduct = new System.Windows.Forms.ComboBox();
            this.btnCopyLicenseKey = new System.Windows.Forms.Button();
            this.btnAbout = new System.Windows.Forms.Button();
            this.lblHomepage = new System.Windows.Forms.LinkLabel();
            this.lblProduct = new System.Windows.Forms.Label();
            this.lblActivationKey = new System.Windows.Forms.Label();
            this.txtActivationKey = new System.Windows.Forms.TextBox();
            this.lblLicenseKey = new System.Windows.Forms.Label();
            this.btnGenerate = new System.Windows.Forms.Button();
            this.txtLicenseKey = new System.Windows.Forms.TextBox();
            this.btnCopyActivationKey = new System.Windows.Forms.Button();
            this.toolTip = new System.Windows.Forms.ToolTip(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.picBanner)).BeginInit();
            this.SuspendLayout();
            // 
            // picBanner
            // 
            this.picBanner.Dock = System.Windows.Forms.DockStyle.Top;
            this.picBanner.Image = ((System.Drawing.Image)(resources.GetObject("picBanner.Image")));
            this.picBanner.Location = new System.Drawing.Point(0, 0);
            this.picBanner.Name = "picBanner";
            this.picBanner.Size = new System.Drawing.Size(282, 80);
            this.picBanner.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBanner.TabIndex = 0;
            this.picBanner.TabStop = false;
            // 
            // cboProduct
            // 
            this.cboProduct.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboProduct.FormattingEnabled = true;
            this.cboProduct.Location = new System.Drawing.Point(6, 108);
            this.cboProduct.Name = "cboProduct";
            this.cboProduct.Size = new System.Drawing.Size(270, 21);
            this.cboProduct.TabIndex = 1;
            this.cboProduct.SelectedIndexChanged += new System.EventHandler(this.CboProductSelectedIndexChanged);
            // 
            // btnCopyLicenseKey
            // 
            this.btnCopyLicenseKey.Location = new System.Drawing.Point(258, 150);
            this.btnCopyLicenseKey.Name = "btnCopyLicenseKey";
            this.btnCopyLicenseKey.Size = new System.Drawing.Size(18, 20);
            this.btnCopyLicenseKey.TabIndex = 4;
            this.btnCopyLicenseKey.Text = "C";
            this.toolTip.SetToolTip(this.btnCopyLicenseKey, "Copy License Key");
            this.btnCopyLicenseKey.UseVisualStyleBackColor = true;
            this.btnCopyLicenseKey.Click += new System.EventHandler(this.BtnCopyLicenseKeyClick);
            // 
            // btnAbout
            // 
            this.btnAbout.Location = new System.Drawing.Point(252, 228);
            this.btnAbout.Name = "btnAbout";
            this.btnAbout.Size = new System.Drawing.Size(24, 24);
            this.btnAbout.TabIndex = 10;
            this.btnAbout.Text = "?";
            this.btnAbout.UseVisualStyleBackColor = true;
            this.btnAbout.Click += new System.EventHandler(this.BtnAboutClick);
            // 
            // lblHomepage
            // 
            this.lblHomepage.Location = new System.Drawing.Point(6, 228);
            this.lblHomepage.Name = "lblHomepage";
            this.lblHomepage.Size = new System.Drawing.Size(108, 24);
            this.lblHomepage.TabIndex = 8;
            this.lblHomepage.TabStop = true;
            this.lblHomepage.Text = "Products Homepage";
            this.lblHomepage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblHomepage.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LblHomepageLinkClicked);
            // 
            // lblProduct
            // 
            this.lblProduct.Location = new System.Drawing.Point(6, 90);
            this.lblProduct.Name = "lblProduct";
            this.lblProduct.Size = new System.Drawing.Size(270, 18);
            this.lblProduct.TabIndex = 0;
            this.lblProduct.Text = "Product:";
            this.lblProduct.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lblActivationKey
            // 
            this.lblActivationKey.Location = new System.Drawing.Point(6, 174);
            this.lblActivationKey.Name = "lblActivationKey";
            this.lblActivationKey.Size = new System.Drawing.Size(252, 18);
            this.lblActivationKey.TabIndex = 5;
            this.lblActivationKey.Text = "Activation Key:";
            this.lblActivationKey.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txtActivationKey
            // 
            this.txtActivationKey.BackColor = System.Drawing.SystemColors.Control;
            this.txtActivationKey.Location = new System.Drawing.Point(6, 192);
            this.txtActivationKey.Name = "txtActivationKey";
            this.txtActivationKey.ReadOnly = true;
            this.txtActivationKey.Size = new System.Drawing.Size(252, 20);
            this.txtActivationKey.TabIndex = 6;
            this.txtActivationKey.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // lblLicenseKey
            // 
            this.lblLicenseKey.Location = new System.Drawing.Point(6, 132);
            this.lblLicenseKey.Name = "lblLicenseKey";
            this.lblLicenseKey.Size = new System.Drawing.Size(252, 18);
            this.lblLicenseKey.TabIndex = 2;
            this.lblLicenseKey.Text = "License Key:";
            this.lblLicenseKey.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnGenerate
            // 
            this.btnGenerate.Location = new System.Drawing.Point(138, 228);
            this.btnGenerate.Name = "btnGenerate";
            this.btnGenerate.Size = new System.Drawing.Size(108, 24);
            this.btnGenerate.TabIndex = 9;
            this.btnGenerate.Text = "Generate";
            this.btnGenerate.UseVisualStyleBackColor = true;
            this.btnGenerate.Click += new System.EventHandler(this.BtnGenerateClick);
            // 
            // txtLicenseKey
            // 
            this.txtLicenseKey.BackColor = System.Drawing.SystemColors.Control;
            this.txtLicenseKey.Location = new System.Drawing.Point(6, 150);
            this.txtLicenseKey.Name = "txtLicenseKey";
            this.txtLicenseKey.ReadOnly = true;
            this.txtLicenseKey.Size = new System.Drawing.Size(252, 20);
            this.txtLicenseKey.TabIndex = 3;
            this.txtLicenseKey.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // btnCopyActivationKey
            // 
            this.btnCopyActivationKey.Location = new System.Drawing.Point(258, 192);
            this.btnCopyActivationKey.Name = "btnCopyActivationKey";
            this.btnCopyActivationKey.Size = new System.Drawing.Size(18, 20);
            this.btnCopyActivationKey.TabIndex = 7;
            this.btnCopyActivationKey.Text = "C";
            this.toolTip.SetToolTip(this.btnCopyActivationKey, "Copy Activation Key");
            this.btnCopyActivationKey.UseVisualStyleBackColor = true;
            this.btnCopyActivationKey.Click += new System.EventHandler(this.btnCopyActivationKeyClick);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(282, 259);
            this.Controls.Add(this.btnCopyActivationKey);
            this.Controls.Add(this.txtLicenseKey);
            this.Controls.Add(this.btnGenerate);
            this.Controls.Add(this.txtActivationKey);
            this.Controls.Add(this.lblActivationKey);
            this.Controls.Add(this.lblHomepage);
            this.Controls.Add(this.btnAbout);
            this.Controls.Add(this.btnCopyLicenseKey);
            this.Controls.Add(this.cboProduct);
            this.Controls.Add(this.picBanner);
            this.Controls.Add(this.lblLicenseKey);
            this.Controls.Add(this.lblProduct);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.KeyPreview = true;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.MainFormLoad);
            this.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.MainFormKeyPress);
            ((System.ComponentModel.ISupportInitialize)(this.picBanner)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }
    }
}
