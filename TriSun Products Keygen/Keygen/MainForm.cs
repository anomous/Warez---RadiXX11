using System;
using System.Collections.Generic;
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
            
            txtNumPCs.Minimum = 11;
            txtNumPCs.Maximum = 999999;
            txtNumPCs.Value = txtNumPCs.Minimum;
        }
        
        void MainFormKeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 27)
                Close();
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
                Process.Start("https://www.trisunsoft.com");
            }
            catch
            {
                MessageBox.Show("Cannot open default web browser!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        
        void CboProductSelectedIndexChanged(object sender, EventArgs e)
        {
            if (cboProduct.SelectedIndex >= 0)
            {
                cboLicense.Items.Clear();
                
                foreach (var license in Enum.GetValues(typeof(LicenseTypes)))
                {
                    if ((License.ProductList[cboProduct.SelectedIndex].LicenseTypes & (LicenseTypes)license) == (LicenseTypes)license && (LicenseTypes)license != LicenseTypes.All)
                        cboLicense.Items.Add(license);
                }
                
                if (cboLicense.Items.Count > 0)
                    cboLicense.SelectedIndex = 0;                
            }
        }
        
        void CboLicenseSelectedIndexChanged(object sender, EventArgs e)
        {
            if (cboProduct.SelectedIndex >= 0 && cboLicense.SelectedIndex >= 0)
            {
                var license = (LicenseTypes)cboLicense.SelectedItem;
                
                if ((license == LicenseTypes.Enterprise || license == LicenseTypes.Team) && License.ProductList[cboProduct.SelectedIndex].SupportsNumPCs)
                {
                    lblNumPCs.Enabled = true;
                    txtNumPCs.Enabled = true;
                }
                else
                {
                    lblNumPCs.Enabled = false;
                    txtNumPCs.Enabled = false;                    
                }
            
                btnGenerate.PerformClick();
            }
        }
        
        void TxtNumPCsValueChanged(object sender, EventArgs e)
        {
            btnGenerate.PerformClick();
        }
        
        void BtnGenerateClick(object sender, EventArgs e)
        {
            if (cboProduct.SelectedIndex >= 0 && cboLicense.SelectedIndex >= 0)
                txtKey.Text = License.ProductList[cboProduct.SelectedIndex].GenerateLicenseKey((LicenseTypes)cboLicense.SelectedItem, (int)txtNumPCs.Value);
        }
    }
}
