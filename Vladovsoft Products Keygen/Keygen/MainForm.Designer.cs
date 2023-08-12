namespace Keygen
{
    partial class MainForm
    {
        /// <summary>
        /// Designer variable used to keep track of non-visual components.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.PictureBox picBanner;
        private System.Windows.Forms.LinkLabel lblHomepage;
        private System.Windows.Forms.Button btnCopy;
        private System.Windows.Forms.Button btnAbout;
        private System.Windows.Forms.Label lblProduct;
        private System.Windows.Forms.TextBox txtProductID;
        private System.Windows.Forms.ComboBox cboProduct;
        private System.Windows.Forms.Label lblProductID;
        private System.Windows.Forms.Label lblUnlockCode;
        private System.Windows.Forms.TextBox txtUnlockCode;
        private System.Windows.Forms.Button btnRead;
        
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
            this.lblHomepage = new System.Windows.Forms.LinkLabel();
            this.btnCopy = new System.Windows.Forms.Button();
            this.btnAbout = new System.Windows.Forms.Button();
            this.lblProduct = new System.Windows.Forms.Label();
            this.txtProductID = new System.Windows.Forms.TextBox();
            this.cboProduct = new System.Windows.Forms.ComboBox();
            this.lblProductID = new System.Windows.Forms.Label();
            this.lblUnlockCode = new System.Windows.Forms.Label();
            this.txtUnlockCode = new System.Windows.Forms.TextBox();
            this.btnRead = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.picBanner)).BeginInit();
            this.SuspendLayout();
            // 
            // picBanner
            // 
            this.picBanner.Dock = System.Windows.Forms.DockStyle.Top;
            this.picBanner.Image = ((System.Drawing.Image)(resources.GetObject("picBanner.Image")));
            this.picBanner.Location = new System.Drawing.Point(0, 0);
            this.picBanner.Name = "picBanner";
            this.picBanner.Size = new System.Drawing.Size(276, 48);
            this.picBanner.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBanner.TabIndex = 0;
            this.picBanner.TabStop = false;
            // 
            // lblHomepage
            // 
            this.lblHomepage.ActiveLinkColor = System.Drawing.SystemColors.Highlight;
            this.lblHomepage.LinkColor = System.Drawing.SystemColors.HotTrack;
            this.lblHomepage.Location = new System.Drawing.Point(6, 162);
            this.lblHomepage.Name = "lblHomepage";
            this.lblHomepage.Size = new System.Drawing.Size(108, 23);
            this.lblHomepage.TabIndex = 7;
            this.lblHomepage.TabStop = true;
            this.lblHomepage.Text = "Products homepage";
            this.lblHomepage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblHomepage.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LblHomepageLinkClicked);
            // 
            // btnCopy
            // 
            this.btnCopy.Location = new System.Drawing.Point(174, 162);
            this.btnCopy.Name = "btnCopy";
            this.btnCopy.Size = new System.Drawing.Size(66, 23);
            this.btnCopy.TabIndex = 8;
            this.btnCopy.Text = "&Copy";
            this.btnCopy.UseVisualStyleBackColor = true;
            this.btnCopy.Click += new System.EventHandler(this.BtnCopyClick);
            // 
            // btnAbout
            // 
            this.btnAbout.Location = new System.Drawing.Point(246, 162);
            this.btnAbout.Name = "btnAbout";
            this.btnAbout.Size = new System.Drawing.Size(24, 23);
            this.btnAbout.TabIndex = 9;
            this.btnAbout.Text = "&?";
            this.btnAbout.UseVisualStyleBackColor = true;
            this.btnAbout.Click += new System.EventHandler(this.BtnAboutClick);
            // 
            // lblProduct
            // 
            this.lblProduct.Location = new System.Drawing.Point(6, 60);
            this.lblProduct.Name = "lblProduct";
            this.lblProduct.Size = new System.Drawing.Size(54, 18);
            this.lblProduct.TabIndex = 0;
            this.lblProduct.Text = "&Product:";
            this.lblProduct.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txtProductID
            // 
            this.txtProductID.Location = new System.Drawing.Point(96, 78);
            this.txtProductID.Name = "txtProductID";
            this.txtProductID.Size = new System.Drawing.Size(132, 20);
            this.txtProductID.TabIndex = 3;
            this.txtProductID.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.txtProductID.WordWrap = false;
            this.txtProductID.TextChanged += new System.EventHandler(this.TxtProductIDTextChanged);
            this.txtProductID.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.TxtProductIDKeyPress);
            // 
            // cboProduct
            // 
            this.cboProduct.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboProduct.FormattingEnabled = true;
            this.cboProduct.Location = new System.Drawing.Point(6, 78);
            this.cboProduct.Name = "cboProduct";
            this.cboProduct.Size = new System.Drawing.Size(84, 21);
            this.cboProduct.TabIndex = 1;
            this.cboProduct.SelectedIndexChanged += new System.EventHandler(this.CboProductSelectedIndexChanged);
            // 
            // lblProductID
            // 
            this.lblProductID.Location = new System.Drawing.Point(96, 60);
            this.lblProductID.Name = "lblProductID";
            this.lblProductID.Size = new System.Drawing.Size(132, 18);
            this.lblProductID.TabIndex = 2;
            this.lblProductID.Text = "Product &ID (hardware ID):";
            this.lblProductID.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lblUnlockCode
            // 
            this.lblUnlockCode.Location = new System.Drawing.Point(6, 108);
            this.lblUnlockCode.Name = "lblUnlockCode";
            this.lblUnlockCode.Size = new System.Drawing.Size(264, 18);
            this.lblUnlockCode.TabIndex = 5;
            this.lblUnlockCode.Text = "&Unlock Code:";
            this.lblUnlockCode.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // txtUnlockCode
            // 
            this.txtUnlockCode.Location = new System.Drawing.Point(6, 126);
            this.txtUnlockCode.Name = "txtUnlockCode";
            this.txtUnlockCode.ReadOnly = true;
            this.txtUnlockCode.Size = new System.Drawing.Size(264, 20);
            this.txtUnlockCode.TabIndex = 6;
            this.txtUnlockCode.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.txtUnlockCode.WordWrap = false;
            // 
            // btnRead
            // 
            this.btnRead.Location = new System.Drawing.Point(228, 78);
            this.btnRead.Name = "btnRead";
            this.btnRead.Size = new System.Drawing.Size(42, 20);
            this.btnRead.TabIndex = 4;
            this.btnRead.Text = "&Read";
            this.btnRead.UseVisualStyleBackColor = true;
            this.btnRead.Click += new System.EventHandler(this.BtnReadClick);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(276, 189);
            this.Controls.Add(this.btnRead);
            this.Controls.Add(this.lblUnlockCode);
            this.Controls.Add(this.txtUnlockCode);
            this.Controls.Add(this.lblProductID);
            this.Controls.Add(this.cboProduct);
            this.Controls.Add(this.txtProductID);
            this.Controls.Add(this.lblProduct);
            this.Controls.Add(this.btnAbout);
            this.Controls.Add(this.btnCopy);
            this.Controls.Add(this.lblHomepage);
            this.Controls.Add(this.picBanner);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.KeyPreview = true;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.MainFormLoad);
            this.Shown += new System.EventHandler(this.MainFormShown);
            ((System.ComponentModel.ISupportInitialize)(this.picBanner)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }
    }
}
