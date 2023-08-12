namespace LicGen
{
    partial class MainForm
    {
        /// <summary>
        /// Designer variable used to keep track of non-visual components.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.PictureBox picBanner;
        private System.Windows.Forms.Button btnGenerate;
        private System.Windows.Forms.Button btnAbout;
        private System.Windows.Forms.LinkLabel lblHomepage;
        private System.Windows.Forms.ComboBox cboLicense;
        private System.Windows.Forms.NumericUpDown txtMaxUsers;
        private System.Windows.Forms.TextBox txtName;
        private System.Windows.Forms.TextBox txtEMail;
        private System.Windows.Forms.Label lblName;
        private System.Windows.Forms.Label lblEMail;
        private System.Windows.Forms.Label lblMaxUsers;
        private System.Windows.Forms.Label lblLicense;
        
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
            this.btnGenerate = new System.Windows.Forms.Button();
            this.btnAbout = new System.Windows.Forms.Button();
            this.lblHomepage = new System.Windows.Forms.LinkLabel();
            this.cboLicense = new System.Windows.Forms.ComboBox();
            this.txtMaxUsers = new System.Windows.Forms.NumericUpDown();
            this.txtName = new System.Windows.Forms.TextBox();
            this.txtEMail = new System.Windows.Forms.TextBox();
            this.lblName = new System.Windows.Forms.Label();
            this.lblEMail = new System.Windows.Forms.Label();
            this.lblMaxUsers = new System.Windows.Forms.Label();
            this.lblLicense = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.picBanner)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtMaxUsers)).BeginInit();
            this.SuspendLayout();
            // 
            // picBanner
            // 
            this.picBanner.Dock = System.Windows.Forms.DockStyle.Top;
            this.picBanner.Image = ((System.Drawing.Image)(resources.GetObject("picBanner.Image")));
            this.picBanner.Location = new System.Drawing.Point(0, 0);
            this.picBanner.Name = "picBanner";
            this.picBanner.Size = new System.Drawing.Size(382, 78);
            this.picBanner.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBanner.TabIndex = 0;
            this.picBanner.TabStop = false;
            // 
            // btnGenerate
            // 
            this.btnGenerate.Location = new System.Drawing.Point(222, 186);
            this.btnGenerate.Name = "btnGenerate";
            this.btnGenerate.Size = new System.Drawing.Size(120, 24);
            this.btnGenerate.TabIndex = 9;
            this.btnGenerate.Text = "Generate License File";
            this.btnGenerate.UseVisualStyleBackColor = true;
            this.btnGenerate.Click += new System.EventHandler(this.BtnGenerateClick);
            // 
            // btnAbout
            // 
            this.btnAbout.Location = new System.Drawing.Point(348, 186);
            this.btnAbout.Name = "btnAbout";
            this.btnAbout.Size = new System.Drawing.Size(26, 24);
            this.btnAbout.TabIndex = 10;
            this.btnAbout.Text = "?";
            this.btnAbout.UseVisualStyleBackColor = true;
            this.btnAbout.Click += new System.EventHandler(this.BtnAboutClick);
            // 
            // lblHomepage
            // 
            this.lblHomepage.Location = new System.Drawing.Point(6, 186);
            this.lblHomepage.Name = "lblHomepage";
            this.lblHomepage.Size = new System.Drawing.Size(102, 24);
            this.lblHomepage.TabIndex = 8;
            this.lblHomepage.TabStop = true;
            this.lblHomepage.Text = "Product Homepage";
            this.lblHomepage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblHomepage.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LblHomepageLinkClicked);
            // 
            // cboLicense
            // 
            this.cboLicense.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboLicense.FormattingEnabled = true;
            this.cboLicense.Location = new System.Drawing.Point(60, 90);
            this.cboLicense.Name = "cboLicense";
            this.cboLicense.Size = new System.Drawing.Size(174, 21);
            this.cboLicense.TabIndex = 1;
            // 
            // txtMaxUsers
            // 
            this.txtMaxUsers.Location = new System.Drawing.Point(300, 90);
            this.txtMaxUsers.Name = "txtMaxUsers";
            this.txtMaxUsers.Size = new System.Drawing.Size(72, 20);
            this.txtMaxUsers.TabIndex = 3;
            this.txtMaxUsers.ValueChanged += new System.EventHandler(this.OnChange);
            // 
            // txtName
            // 
            this.txtName.Location = new System.Drawing.Point(60, 120);
            this.txtName.Name = "txtName";
            this.txtName.Size = new System.Drawing.Size(312, 20);
            this.txtName.TabIndex = 5;
            this.txtName.TextChanged += new System.EventHandler(this.OnChange);
            // 
            // txtEMail
            // 
            this.txtEMail.Location = new System.Drawing.Point(60, 150);
            this.txtEMail.Name = "txtEMail";
            this.txtEMail.Size = new System.Drawing.Size(312, 20);
            this.txtEMail.TabIndex = 7;
            this.txtEMail.TextChanged += new System.EventHandler(this.OnChange);
            // 
            // lblName
            // 
            this.lblName.Location = new System.Drawing.Point(12, 120);
            this.lblName.Name = "lblName";
            this.lblName.Size = new System.Drawing.Size(48, 20);
            this.lblName.TabIndex = 4;
            this.lblName.Text = "Name:";
            this.lblName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lblEMail
            // 
            this.lblEMail.Location = new System.Drawing.Point(12, 150);
            this.lblEMail.Name = "lblEMail";
            this.lblEMail.Size = new System.Drawing.Size(48, 20);
            this.lblEMail.TabIndex = 6;
            this.lblEMail.Text = "EMail:";
            this.lblEMail.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lblMaxUsers
            // 
            this.lblMaxUsers.Location = new System.Drawing.Point(240, 90);
            this.lblMaxUsers.Name = "lblMaxUsers";
            this.lblMaxUsers.Size = new System.Drawing.Size(60, 20);
            this.lblMaxUsers.TabIndex = 2;
            this.lblMaxUsers.Text = "Max Users:";
            this.lblMaxUsers.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lblLicense
            // 
            this.lblLicense.Location = new System.Drawing.Point(12, 90);
            this.lblLicense.Name = "lblLicense";
            this.lblLicense.Size = new System.Drawing.Size(48, 20);
            this.lblLicense.TabIndex = 0;
            this.lblLicense.Text = "License:";
            this.lblLicense.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(382, 219);
            this.Controls.Add(this.lblLicense);
            this.Controls.Add(this.lblMaxUsers);
            this.Controls.Add(this.lblEMail);
            this.Controls.Add(this.lblName);
            this.Controls.Add(this.txtEMail);
            this.Controls.Add(this.txtName);
            this.Controls.Add(this.txtMaxUsers);
            this.Controls.Add(this.cboLicense);
            this.Controls.Add(this.lblHomepage);
            this.Controls.Add(this.btnAbout);
            this.Controls.Add(this.btnGenerate);
            this.Controls.Add(this.picBanner);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.MainFormLoad);
            ((System.ComponentModel.ISupportInitialize)(this.picBanner)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtMaxUsers)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }
    }
}
