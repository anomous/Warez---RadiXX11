using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

namespace Activator
{
    /// <summary>
    /// Description of MainForm.
    /// </summary>
    public partial class MainForm : Form
    {
        private readonly LicenseInfo[] ProductList = {
            new LicenseInfo("Log Parser Lizard 7.x", "LogParserLizard7", true, Path.Combine(System.Environment.GetFolderPath(System.Environment.SpecialFolder.LocalApplicationData), "LizardLabs", "Log Parser Lizard.config"), false),
            new LicenseInfo("Report Fabricator 2.x", "ReportFabricator2", false, Path.Combine(System.Environment.GetFolderPath(System.Environment.SpecialFolder.ApplicationData), "LizardLabs", "ReportFabricator.config"), true),
            new LicenseInfo("Ultimate Maps Downloader 4.x", "UltimateMapsDownloader4", false, Path.Combine(System.Environment.GetFolderPath(System.Environment.SpecialFolder.LocalApplicationData), "UltimateMapsDownloader", "mysettings.config"), true)
        };
        
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
            rdbPro.Checked = true;
            
            foreach (var licenseInfo in ProductList)
                cboProduct.Items.Add(licenseInfo.AppName);
            
            if (cboProduct.Items.Count > 0)
                cboProduct.SelectedIndex = 0;
        }
        
        void BtnAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("{0}\n\nVersion {1}\n\n© 2019, RadiXX11", Application.ProductName, Application.ProductVersion), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        
        void LblHomepageLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                Process.Start("http://lizard-labs.com");
            }
            catch
            {
                MessageBox.Show("Cannot open default web browser!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        
        void MainFormShown(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtName.Text))
                txtName.Focus();
            else
                btnActivate.Focus();
        }
        
        void CboProductSelectedIndexChanged(object sender, EventArgs e)
        {
            rdbPro.Enabled = ProductList[cboProduct.SelectedIndex].HasProLicense;            
            rdbStandard.Checked |= !rdbPro.Enabled;
        }
        
        void BtnActivateClick(object sender, EventArgs e)
        {
            if (ProductList[cboProduct.SelectedIndex].Save(txtName.Text, rdbPro.Checked))
                MessageBox.Show("License info saved successfully.", Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
            else
                MessageBox.Show("Cannot save license info!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }
        
        void TxtNameTextChanged(object sender, EventArgs e)
        {
            btnActivate.Enabled = !string.IsNullOrEmpty(txtName.Text);
        }
    }
}
