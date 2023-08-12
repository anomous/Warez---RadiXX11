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
            
            cboLicense.Items.AddRange(LicenseHandler.LicenseTypes);
            
            if (cboLicense.Items.Count > 0)
                cboLicense.SelectedIndex = (int)LicenseType.Professional_edition;
            
            txtMaxUsers.Minimum = 1;
            txtMaxUsers.Maximum = int.MaxValue;
            txtMaxUsers.Value = 1000;
            txtName.Text = Environment.UserName;
            txtEMail.Text = "some@email.com";
            
            OnChange(null, null);
        }
        
        void BtnAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("{0}\n\nVersion {1}\n\n© 2019, RadiXX11", Application.ProductName, Application.ProductVersion), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        
        void LblHomepageLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                Process.Start("http://dancode.dk");
            }
            catch
            {
                MessageBox.Show("Cannot open default web browser!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        
        void BtnGenerateClick(object sender, EventArgs e)
        {
            if (LicenseHandler.GenerateLicenseFile((LicenseType)cboLicense.SelectedIndex, (int)txtMaxUsers.Value, txtName.Text, txtEMail.Text))
                MessageBox.Show("License file has been created successfully", Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
            else
                MessageBox.Show("Cannot create license file!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }
        
        void OnChange(object sender, EventArgs e)
        {
            btnGenerate.Enabled = (cboLicense.SelectedIndex >= 0) &&
                                    (txtMaxUsers.Value > 0) &&
                                    (!string.IsNullOrEmpty(txtName.Text.Trim())) &&
                                    (!string.IsNullOrEmpty(txtEMail.Text.Trim()));
        }
    }
}
