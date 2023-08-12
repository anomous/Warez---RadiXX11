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
        private const string HostsFileEntry = "api.tableplus.com";
        
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
            btnGenerate.Enabled = false;
            btnPatch.Enabled = !HostsFile.IsHostsFilePatched(HostsFileEntry);            
        }
        
        void BtnAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("{0}\n\nVersion {1}\n\n© 2019, RadiXX11", Application.ProductName, Application.ProductVersion), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        
        void LblHomepageLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                Process.Start("https://tableplus.com/windows");
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
            if (License.GenerateLicenseFile(txtEMail.Text))
                MessageBox.Show("License file has been created successfully", Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
            else
                MessageBox.Show("Cannot create license file!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }
        
        void MainFormShown(object sender, EventArgs e)
        {
            txtEMail.Focus();
        }
        
        void TxtEMailTextChanged(object sender, EventArgs e)
        {
            btnGenerate.Enabled = !string.IsNullOrEmpty(txtEMail.Text);
        }
    }
}
