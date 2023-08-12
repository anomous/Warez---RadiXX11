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
            
            foreach (var product in License.ProductList)
                cboProduct.Items.Add(product.Name);
            
            if (cboProduct.Items.Count > 0)
                cboProduct.SelectedIndex = 0;
        }
        
        void MainFormKeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 27)
                Close();
        }
        
        void btnCopyActivationKeyClick(object sender, EventArgs e)
        {
            txtActivationKey.SelectAll();
            txtActivationKey.Copy();
            txtActivationKey.SelectionLength = 0;
        }
        
        void BtnCopyLicenseKeyClick(object sender, EventArgs e)
        {
            txtLicenseKey.SelectAll();
            txtLicenseKey.Copy();
            txtLicenseKey.SelectionLength = 0;
        }
        
        void BtnAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("{0}\n\nVersion {1}\n\n© 2020, RadiXX11", Application.ProductName, Application.ProductVersion), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        
        void LblHomepageLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                Process.Start("https://www.programming.de");
            }
            catch
            {
                MessageBox.Show("Cannot open default web browser!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        
        void CboProductSelectedIndexChanged(object sender, EventArgs e)
        {
            btnGenerate.PerformClick();
        }
        
        void BtnGenerateClick(object sender, EventArgs e)
        {
            if (cboProduct.SelectedIndex >= 0)
            {
                txtLicenseKey.Text = License.GenerateLicenseKey();
                txtActivationKey.Text = License.ProductList[cboProduct.SelectedIndex].GenerateActivationKey(txtLicenseKey.Text);
                btnCopyLicenseKey.Enabled = !string.IsNullOrEmpty(txtLicenseKey.Text);
                btnCopyActivationKey.Enabled = !string.IsNullOrEmpty(txtActivationKey.Text);
            }
        }   
    }
}
