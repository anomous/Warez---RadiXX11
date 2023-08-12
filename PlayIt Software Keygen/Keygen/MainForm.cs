using System;
using System.Diagnostics;
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
            
            foreach (var product in ProductInfo.ProductList)
                cboProduct.Items.Add(product.Name);
            
            if (cboProduct.Items.Count > 0)
                cboProduct.SelectedIndex = 0;
            
            txtName.Text = Environment.UserName;
            txtEMail.Text = "some@email.com";
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
                Process.Start("https://www.playitsoftware.com");
            }
            catch
            {
                MessageBox.Show("Cannot open default web browser!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        
        void OnChange(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtName.Text))
            {
                txtKey.Text = "Enter a Name...";
                btnGenerate.Enabled = false;
                btnCopy.Enabled = false;
            }
            else if (string.IsNullOrEmpty(txtEMail.Text))
            {
                txtKey.Text = "Enter an EMail...";
                btnGenerate.Enabled = false;
                btnCopy.Enabled = false;
            }
            else
            {
                txtKey.Text = "Click Generate...";
                btnGenerate.Enabled = true;
                btnCopy.Enabled = false;                    
            }
        }
        
        void BtnGenerateClick(object sender, EventArgs e)
        {
            if (cboProduct.SelectedIndex >= 0)
            {
                txtKey.Text = LicenseManager.GenerateLicenseKey(ProductInfo.ProductList[cboProduct.SelectedIndex], txtName.Text, txtEMail.Text, "", DateTime.MaxValue);
                btnCopy.Enabled = !string.IsNullOrEmpty(txtKey.Text);
            }
        }
    }
}
