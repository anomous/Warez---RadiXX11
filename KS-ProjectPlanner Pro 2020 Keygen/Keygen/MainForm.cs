using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Windows.Forms;

namespace Keygen
{
    /// <summary>
    /// Description of MainForm.
    /// </summary>
    public partial class MainForm : Form
    {
        public MainForm()
        {
            //
            // The InitializeComponent() call is required for Windows Forms designer support.
            //
            InitializeComponent();
            
            //
            // TODO: Add constructor code after the InitializeComponent() call.
            //
        }
        
        void MainFormLoad(object sender, EventArgs e)
        {
            Text = Application.ProductName;
            txtName.Text = Environment.UserName;
            txtLicenses.Minimum = 1;
            txtLicenses.Maximum = int.MaxValue;
            txtLicenses.Value = 1000;
        }
        
        void BtnCopyClick(object sender, EventArgs e)
        {
            txtKey.SelectAll();
            txtKey.Copy();
            txtKey.SelectionLength = 0;
        }
        
        void BtnAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("{0}\n\nVersion {1}\n\n© 2019, RadiXX11", Application.ProductName, Application.ProductVersion), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        
        void LblHomepageLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                Process.Start("http://www.projectplanner.ch");
            }
            catch
            {
                MessageBox.Show("Cannot open default web browser!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        
        void OnChange(object sender, EventArgs e)
        {
            var key = License.GenerateKey(txtName.Text, (int)txtLicenses.Value);
            
            if (!string.IsNullOrEmpty(key))
            {
                txtKey.Text = key;
                btnCopy.Enabled = true;
            }
            else
            {
                txtKey.Text = "Enter a name/number of licenses...";
                btnCopy.Enabled = false;
            }
        }
    }
}
