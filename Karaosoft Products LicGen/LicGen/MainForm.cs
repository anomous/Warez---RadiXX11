using System;
using System.Diagnostics;
using System.Windows.Forms;

namespace LicGen
{
    /// <summary>
    /// Description of MainForm.
    /// </summary>
    public partial class MainForm : Form
    {
        private const string HostsFileEntry = "www.karaosoft.com";
        
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
            btnGenerate.Enabled = false;
            btnPatch.Enabled = !HostsFile.IsHostsFilePatched(HostsFileEntry);
            
            TxtEMailTextChanged(null, null);
        }
        
        void BtnAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("{0}\n\nVersion {1}\n\n© 2019, RadiXX11", Application.ProductName, Application.ProductVersion), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        
        void LblHomepageLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                Process.Start("http://www.karaosoft.com");
            }
            catch
            {
                MessageBox.Show("Cannot open default web browser!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        
        void BtnPatchClick(object sender, EventArgs e)
        {
            if (HostsFile.PatchHostsFile(HostsFileEntry))
            {
                if (HostsFile.IsHostsFilePatched(HostsFileEntry))
                {
                    btnPatch.Enabled = false;
                    MessageBox.Show("Hosts file has been patched successfully", Text, MessageBoxButtons.OK, MessageBoxIcon.Information);                
                    return;
                }
            }

            MessageBox.Show("Cannot patch hosts file!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }
        
        void BtnGenerateClick(object sender, EventArgs e)
        {
            if (cboProduct.SelectedIndex >= 0)
            {
                if (LicenseManager.GenerateLicenseFile(ProductInfo.ProductList[cboProduct.SelectedIndex], txtName.Text, DateTime.MaxValue))
                    MessageBox.Show("License file has been created successfully", Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
                else
                    MessageBox.Show("Cannot create license file!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        
        void MainFormShown(object sender, EventArgs e)
        {
            txtName.Focus();
        }
        
        void TxtEMailTextChanged(object sender, EventArgs e)
        {
            btnGenerate.Enabled = !string.IsNullOrEmpty(txtName.Text);
        }
    }
}
