namespace Activator
{
    partial class MainForm
    {
        /// <summary>
        /// Designer variable used to keep track of non-visual components.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.PictureBox pbBanner;
        private System.Windows.Forms.Label lblBanner;
        private System.Windows.Forms.Label lblProduct;
        private System.Windows.Forms.ComboBox cbProduct;
        private System.Windows.Forms.Button btnActivate;
        private System.Windows.Forms.Button btnAbout;
        private System.Windows.Forms.LinkLabel lblHomepage;
        private System.Windows.Forms.Label lblExpiration;
        private System.Windows.Forms.DateTimePicker dtpExpiration;
        private System.Windows.Forms.Label lblVersion;
        private System.Windows.Forms.NumericUpDown nudVersion;
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
            this.pbBanner = new System.Windows.Forms.PictureBox();
            this.lblBanner = new System.Windows.Forms.Label();
            this.lblProduct = new System.Windows.Forms.Label();
            this.cbProduct = new System.Windows.Forms.ComboBox();
            this.btnActivate = new System.Windows.Forms.Button();
            this.btnAbout = new System.Windows.Forms.Button();
            this.lblHomepage = new System.Windows.Forms.LinkLabel();
            this.lblExpiration = new System.Windows.Forms.Label();
            this.dtpExpiration = new System.Windows.Forms.DateTimePicker();
            this.lblVersion = new System.Windows.Forms.Label();
            this.nudVersion = new System.Windows.Forms.NumericUpDown();
            this.toolTip = new System.Windows.Forms.ToolTip(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.pbBanner)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.nudVersion)).BeginInit();
            this.SuspendLayout();
            // 
            // pbBanner
            // 
            this.pbBanner.Dock = System.Windows.Forms.DockStyle.Top;
            this.pbBanner.Image = ((System.Drawing.Image)(resources.GetObject("pbBanner.Image")));
            this.pbBanner.Location = new System.Drawing.Point(0, 0);
            this.pbBanner.Name = "pbBanner";
            this.pbBanner.Size = new System.Drawing.Size(312, 64);
            this.pbBanner.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pbBanner.TabIndex = 0;
            this.pbBanner.TabStop = false;
            // 
            // lblBanner
            // 
            this.lblBanner.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.lblBanner.Dock = System.Windows.Forms.DockStyle.Top;
            this.lblBanner.Location = new System.Drawing.Point(0, 64);
            this.lblBanner.Name = "lblBanner";
            this.lblBanner.Size = new System.Drawing.Size(312, 2);
            this.lblBanner.TabIndex = 0;
            // 
            // lblProduct
            // 
            this.lblProduct.Location = new System.Drawing.Point(4, 72);
            this.lblProduct.Name = "lblProduct";
            this.lblProduct.Size = new System.Drawing.Size(140, 20);
            this.lblProduct.TabIndex = 1;
            this.lblProduct.Text = "Product:";
            this.lblProduct.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cbProduct
            // 
            this.cbProduct.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbProduct.FormattingEnabled = true;
            this.cbProduct.Location = new System.Drawing.Point(4, 92);
            this.cbProduct.Name = "cbProduct";
            this.cbProduct.Size = new System.Drawing.Size(140, 21);
            this.cbProduct.TabIndex = 2;
            this.cbProduct.SelectedIndexChanged += new System.EventHandler(this.CbProductSelectedIndexChanged);
            // 
            // btnActivate
            // 
            this.btnActivate.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnActivate.Location = new System.Drawing.Point(212, 128);
            this.btnActivate.Name = "btnActivate";
            this.btnActivate.Size = new System.Drawing.Size(68, 24);
            this.btnActivate.TabIndex = 8;
            this.btnActivate.Text = "Activate";
            this.btnActivate.UseVisualStyleBackColor = true;
            this.btnActivate.Click += new System.EventHandler(this.BtnActivateClick);
            // 
            // btnAbout
            // 
            this.btnAbout.Location = new System.Drawing.Point(284, 128);
            this.btnAbout.Name = "btnAbout";
            this.btnAbout.Size = new System.Drawing.Size(24, 24);
            this.btnAbout.TabIndex = 10;
            this.btnAbout.Text = "?";
            this.btnAbout.UseVisualStyleBackColor = true;
            this.btnAbout.Click += new System.EventHandler(this.BtnAboutClick);
            // 
            // lblHomepage
            // 
            this.lblHomepage.Location = new System.Drawing.Point(4, 128);
            this.lblHomepage.Name = "lblHomepage";
            this.lblHomepage.Size = new System.Drawing.Size(60, 24);
            this.lblHomepage.TabIndex = 7;
            this.lblHomepage.TabStop = true;
            this.lblHomepage.Text = "Homepage";
            this.lblHomepage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblHomepage.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LblHomepageLinkClicked);
            // 
            // lblExpiration
            // 
            this.lblExpiration.Location = new System.Drawing.Point(212, 72);
            this.lblExpiration.Name = "lblExpiration";
            this.lblExpiration.Size = new System.Drawing.Size(96, 20);
            this.lblExpiration.TabIndex = 5;
            this.lblExpiration.Text = "Expiration:";
            this.lblExpiration.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // dtpExpiration
            // 
            this.dtpExpiration.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dtpExpiration.Location = new System.Drawing.Point(212, 92);
            this.dtpExpiration.Name = "dtpExpiration";
            this.dtpExpiration.Size = new System.Drawing.Size(96, 21);
            this.dtpExpiration.TabIndex = 6;
            this.toolTip.SetToolTip(this.dtpExpiration, "Expiration date of the license.");
            // 
            // lblVersion
            // 
            this.lblVersion.Location = new System.Drawing.Point(152, 72);
            this.lblVersion.Name = "lblVersion";
            this.lblVersion.Size = new System.Drawing.Size(52, 20);
            this.lblVersion.TabIndex = 3;
            this.lblVersion.Text = "Version:";
            this.lblVersion.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // nudVersion
            // 
            this.nudVersion.Location = new System.Drawing.Point(152, 92);
            this.nudVersion.Name = "nudVersion";
            this.nudVersion.Size = new System.Drawing.Size(52, 21);
            this.nudVersion.TabIndex = 4;
            this.toolTip.SetToolTip(this.nudVersion, "Major version number of the selected product.\r\nChange this number only if needed " +
        "for newer releases.");
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(312, 156);
            this.Controls.Add(this.nudVersion);
            this.Controls.Add(this.lblVersion);
            this.Controls.Add(this.dtpExpiration);
            this.Controls.Add(this.lblExpiration);
            this.Controls.Add(this.lblHomepage);
            this.Controls.Add(this.btnAbout);
            this.Controls.Add(this.btnActivate);
            this.Controls.Add(this.cbProduct);
            this.Controls.Add(this.lblProduct);
            this.Controls.Add(this.lblBanner);
            this.Controls.Add(this.pbBanner);
            this.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.KeyPreview = true;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.MainFormKeyPress);
            ((System.ComponentModel.ISupportInitialize)(this.pbBanner)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.nudVersion)).EndInit();
            this.ResumeLayout(false);

        }
    }
}
