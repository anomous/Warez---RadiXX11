namespace Activator
{
    partial class MainForm
    {
        /// <summary>
        /// Designer variable used to keep track of non-visual components.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.PictureBox picBanner;
        private System.Windows.Forms.Label lblSourceDB;
        private System.Windows.Forms.Label lblProduct;
        private System.Windows.Forms.ComboBox cboEdition;
        private System.Windows.Forms.Button btnActivate;
        private System.Windows.Forms.Button btnAbout;
        private System.Windows.Forms.LinkLabel lblHomepage;
        private System.Windows.Forms.GroupBox gboDBType;
        private System.Windows.Forms.ComboBox cboTargetDB;
        private System.Windows.Forms.Label lblTargetDB;
        private System.Windows.Forms.ComboBox cboSourceDB;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog;
        
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
            this.lblProduct = new System.Windows.Forms.Label();
            this.cboEdition = new System.Windows.Forms.ComboBox();
            this.btnActivate = new System.Windows.Forms.Button();
            this.btnAbout = new System.Windows.Forms.Button();
            this.lblHomepage = new System.Windows.Forms.LinkLabel();
            this.gboDBType = new System.Windows.Forms.GroupBox();
            this.cboTargetDB = new System.Windows.Forms.ComboBox();
            this.lblTargetDB = new System.Windows.Forms.Label();
            this.cboSourceDB = new System.Windows.Forms.ComboBox();
            this.lblSourceDB = new System.Windows.Forms.Label();
            this.folderBrowserDialog = new System.Windows.Forms.FolderBrowserDialog();
            ((System.ComponentModel.ISupportInitialize)(this.picBanner)).BeginInit();
            this.gboDBType.SuspendLayout();
            this.SuspendLayout();
            // 
            // picBanner
            // 
            this.picBanner.Dock = System.Windows.Forms.DockStyle.Top;
            this.picBanner.Image = ((System.Drawing.Image)(resources.GetObject("picBanner.Image")));
            this.picBanner.Location = new System.Drawing.Point(0, 0);
            this.picBanner.Name = "picBanner";
            this.picBanner.Size = new System.Drawing.Size(224, 65);
            this.picBanner.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBanner.TabIndex = 0;
            this.picBanner.TabStop = false;
            // 
            // lblProduct
            // 
            this.lblProduct.Location = new System.Drawing.Point(6, 78);
            this.lblProduct.Name = "lblProduct";
            this.lblProduct.Size = new System.Drawing.Size(54, 20);
            this.lblProduct.TabIndex = 0;
            this.lblProduct.Text = "Edition:";
            this.lblProduct.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cboEdition
            // 
            this.cboEdition.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboEdition.FormattingEnabled = true;
            this.cboEdition.Location = new System.Drawing.Point(60, 78);
            this.cboEdition.Name = "cboEdition";
            this.cboEdition.Size = new System.Drawing.Size(156, 21);
            this.cboEdition.TabIndex = 1;
            this.cboEdition.SelectedIndexChanged += new System.EventHandler(this.CboEditionSelectedIndexChanged);
            // 
            // btnActivate
            // 
            this.btnActivate.Location = new System.Drawing.Point(114, 192);
            this.btnActivate.Name = "btnActivate";
            this.btnActivate.Size = new System.Drawing.Size(72, 23);
            this.btnActivate.TabIndex = 2;
            this.btnActivate.Text = "Activate";
            this.btnActivate.UseVisualStyleBackColor = true;
            this.btnActivate.Click += new System.EventHandler(this.BtnActivateClick);
            // 
            // btnAbout
            // 
            this.btnAbout.Location = new System.Drawing.Point(192, 192);
            this.btnAbout.Name = "btnAbout";
            this.btnAbout.Size = new System.Drawing.Size(24, 23);
            this.btnAbout.TabIndex = 3;
            this.btnAbout.Text = "?";
            this.btnAbout.UseVisualStyleBackColor = true;
            this.btnAbout.Click += new System.EventHandler(this.BtnAboutClick);
            // 
            // lblHomepage
            // 
            this.lblHomepage.Location = new System.Drawing.Point(6, 192);
            this.lblHomepage.Name = "lblHomepage";
            this.lblHomepage.Size = new System.Drawing.Size(102, 23);
            this.lblHomepage.TabIndex = 1;
            this.lblHomepage.TabStop = true;
            this.lblHomepage.Text = "Product Homepage";
            this.lblHomepage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblHomepage.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LblHomepageLinkClicked);
            // 
            // gboDBType
            // 
            this.gboDBType.Controls.Add(this.cboTargetDB);
            this.gboDBType.Controls.Add(this.lblTargetDB);
            this.gboDBType.Controls.Add(this.cboSourceDB);
            this.gboDBType.Controls.Add(this.lblSourceDB);
            this.gboDBType.Location = new System.Drawing.Point(6, 108);
            this.gboDBType.Name = "gboDBType";
            this.gboDBType.Size = new System.Drawing.Size(210, 72);
            this.gboDBType.TabIndex = 0;
            this.gboDBType.TabStop = false;
            this.gboDBType.Text = "Database Types (DataLoader Edition)";
            // 
            // cboTargetDB
            // 
            this.cboTargetDB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboTargetDB.FormattingEnabled = true;
            this.cboTargetDB.Location = new System.Drawing.Point(54, 42);
            this.cboTargetDB.Name = "cboTargetDB";
            this.cboTargetDB.Size = new System.Drawing.Size(150, 21);
            this.cboTargetDB.TabIndex = 3;
            this.cboTargetDB.SelectedIndexChanged += new System.EventHandler(this.DBSelectedIndexChanged);
            // 
            // lblTargetDB
            // 
            this.lblTargetDB.Location = new System.Drawing.Point(6, 42);
            this.lblTargetDB.Name = "lblTargetDB";
            this.lblTargetDB.Size = new System.Drawing.Size(48, 20);
            this.lblTargetDB.TabIndex = 2;
            this.lblTargetDB.Text = "Target:";
            this.lblTargetDB.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // cboSourceDB
            // 
            this.cboSourceDB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboSourceDB.FormattingEnabled = true;
            this.cboSourceDB.Location = new System.Drawing.Point(54, 18);
            this.cboSourceDB.Name = "cboSourceDB";
            this.cboSourceDB.Size = new System.Drawing.Size(150, 21);
            this.cboSourceDB.TabIndex = 1;
            this.cboSourceDB.SelectedIndexChanged += new System.EventHandler(this.DBSelectedIndexChanged);
            // 
            // lblSourceDB
            // 
            this.lblSourceDB.Location = new System.Drawing.Point(6, 18);
            this.lblSourceDB.Name = "lblSourceDB";
            this.lblSourceDB.Size = new System.Drawing.Size(48, 20);
            this.lblSourceDB.TabIndex = 0;
            this.lblSourceDB.Text = "Source:";
            this.lblSourceDB.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // folderBrowserDialog
            // 
            this.folderBrowserDialog.Description = "Select installation folder:";
            this.folderBrowserDialog.ShowNewFolderButton = false;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(224, 223);
            this.Controls.Add(this.gboDBType);
            this.Controls.Add(this.lblHomepage);
            this.Controls.Add(this.btnAbout);
            this.Controls.Add(this.btnActivate);
            this.Controls.Add(this.cboEdition);
            this.Controls.Add(this.lblProduct);
            this.Controls.Add(this.picBanner);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.MainFormLoad);
            ((System.ComponentModel.ISupportInitialize)(this.picBanner)).EndInit();
            this.gboDBType.ResumeLayout(false);
            this.ResumeLayout(false);

        }
    }
}
