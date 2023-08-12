namespace Keygen
{
    partial class MainForm
    {
        /// <summary>
        /// Designer variable used to keep track of non-visual components.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Label lblName;
        private System.Windows.Forms.TextBox txtName;
        private System.Windows.Forms.Label lblLicenses;
        private System.Windows.Forms.NumericUpDown txtLicenses;
        private System.Windows.Forms.TextBox txtKey;
        private System.Windows.Forms.Label lblKey;
        private System.Windows.Forms.Button btnCopy;
        private System.Windows.Forms.Button btnAbout;
        private System.Windows.Forms.LinkLabel lblHomepage;
        private System.Windows.Forms.Label lblPlugin;
        private System.Windows.Forms.ComboBox cboPlugin;
        
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
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.lblName = new System.Windows.Forms.Label();
            this.txtName = new System.Windows.Forms.TextBox();
            this.lblLicenses = new System.Windows.Forms.Label();
            this.txtLicenses = new System.Windows.Forms.NumericUpDown();
            this.txtKey = new System.Windows.Forms.TextBox();
            this.lblKey = new System.Windows.Forms.Label();
            this.btnCopy = new System.Windows.Forms.Button();
            this.btnAbout = new System.Windows.Forms.Button();
            this.lblHomepage = new System.Windows.Forms.LinkLabel();
            this.lblPlugin = new System.Windows.Forms.Label();
            this.cboPlugin = new System.Windows.Forms.ComboBox();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtLicenses)).BeginInit();
            this.SuspendLayout();
            // 
            // pictureBox1
            // 
            this.pictureBox1.Dock = System.Windows.Forms.DockStyle.Top;
            this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
            this.pictureBox1.Location = new System.Drawing.Point(0, 0);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(384, 54);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            // 
            // lblName
            // 
            this.lblName.Location = new System.Drawing.Point(150, 60);
            this.lblName.Name = "lblName";
            this.lblName.Size = new System.Drawing.Size(42, 18);
            this.lblName.TabIndex = 2;
            this.lblName.Text = "Name:";
            this.lblName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txtName
            // 
            this.txtName.Location = new System.Drawing.Point(150, 78);
            this.txtName.Name = "txtName";
            this.txtName.Size = new System.Drawing.Size(138, 20);
            this.txtName.TabIndex = 3;
            this.txtName.TextChanged += new System.EventHandler(this.OnChange);
            // 
            // lblLicenses
            // 
            this.lblLicenses.Location = new System.Drawing.Point(294, 60);
            this.lblLicenses.Name = "lblLicenses";
            this.lblLicenses.Size = new System.Drawing.Size(66, 18);
            this.lblLicenses.TabIndex = 4;
            this.lblLicenses.Text = "# Licenses:";
            this.lblLicenses.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txtLicenses
            // 
            this.txtLicenses.Location = new System.Drawing.Point(294, 78);
            this.txtLicenses.Name = "txtLicenses";
            this.txtLicenses.Size = new System.Drawing.Size(84, 20);
            this.txtLicenses.TabIndex = 5;
            this.txtLicenses.ValueChanged += new System.EventHandler(this.OnChange);
            // 
            // txtKey
            // 
            this.txtKey.BackColor = System.Drawing.SystemColors.Control;
            this.txtKey.Location = new System.Drawing.Point(6, 120);
            this.txtKey.Multiline = true;
            this.txtKey.Name = "txtKey";
            this.txtKey.ReadOnly = true;
            this.txtKey.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtKey.Size = new System.Drawing.Size(372, 54);
            this.txtKey.TabIndex = 7;
            // 
            // lblKey
            // 
            this.lblKey.Location = new System.Drawing.Point(6, 102);
            this.lblKey.Name = "lblKey";
            this.lblKey.Size = new System.Drawing.Size(42, 18);
            this.lblKey.TabIndex = 6;
            this.lblKey.Text = "Key:";
            this.lblKey.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // btnCopy
            // 
            this.btnCopy.Location = new System.Drawing.Point(222, 186);
            this.btnCopy.Name = "btnCopy";
            this.btnCopy.Size = new System.Drawing.Size(126, 24);
            this.btnCopy.TabIndex = 9;
            this.btnCopy.Text = "Copy";
            this.btnCopy.UseVisualStyleBackColor = true;
            this.btnCopy.Click += new System.EventHandler(this.BtnCopyClick);
            // 
            // btnAbout
            // 
            this.btnAbout.Location = new System.Drawing.Point(354, 186);
            this.btnAbout.Name = "btnAbout";
            this.btnAbout.Size = new System.Drawing.Size(24, 24);
            this.btnAbout.TabIndex = 10;
            this.btnAbout.Text = "?";
            this.btnAbout.UseVisualStyleBackColor = true;
            this.btnAbout.Click += new System.EventHandler(this.BtnAboutClick);
            // 
            // lblHomepage
            // 
            this.lblHomepage.Location = new System.Drawing.Point(6, 186);
            this.lblHomepage.Name = "lblHomepage";
            this.lblHomepage.Size = new System.Drawing.Size(100, 24);
            this.lblHomepage.TabIndex = 8;
            this.lblHomepage.TabStop = true;
            this.lblHomepage.Text = "Product Homepage";
            this.lblHomepage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblHomepage.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LblHomepageLinkClicked);
            // 
            // lblPlugin
            // 
            this.lblPlugin.Location = new System.Drawing.Point(6, 60);
            this.lblPlugin.Name = "lblPlugin";
            this.lblPlugin.Size = new System.Drawing.Size(42, 18);
            this.lblPlugin.TabIndex = 0;
            this.lblPlugin.Text = "Plugin:";
            this.lblPlugin.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cboPlugin
            // 
            this.cboPlugin.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboPlugin.FormattingEnabled = true;
            this.cboPlugin.Location = new System.Drawing.Point(6, 78);
            this.cboPlugin.Name = "cboPlugin";
            this.cboPlugin.Size = new System.Drawing.Size(138, 21);
            this.cboPlugin.TabIndex = 1;
            this.cboPlugin.SelectedIndexChanged += new System.EventHandler(this.OnChange);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(384, 217);
            this.Controls.Add(this.cboPlugin);
            this.Controls.Add(this.lblPlugin);
            this.Controls.Add(this.lblHomepage);
            this.Controls.Add(this.btnAbout);
            this.Controls.Add(this.btnCopy);
            this.Controls.Add(this.lblKey);
            this.Controls.Add(this.txtKey);
            this.Controls.Add(this.txtLicenses);
            this.Controls.Add(this.lblLicenses);
            this.Controls.Add(this.txtName);
            this.Controls.Add(this.lblName);
            this.Controls.Add(this.pictureBox1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.MainFormLoad);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtLicenses)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }
    }
}
