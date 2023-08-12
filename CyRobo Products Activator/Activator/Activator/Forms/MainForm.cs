using System;
using System.Diagnostics;
using System.Windows.Forms;

namespace Activator
{
    /// <summary>
    /// Description of MainForm.
    /// </summary>
    public partial class MainForm : Form
    {
        private void LoadProductList()
        {
            cbProduct.BeginUpdate();
            cbProduct.Items.Clear();
            
            foreach (var productInfo in ProductLicensing.ProductList)
                cbProduct.Items.Add(productInfo.ProductName);
            
            cbProduct.EndUpdate();
            
            if (cbProduct.Items.Count > 0)
                cbProduct.SelectedIndex = 0;
        }        
        
        public MainForm()
        {
            //
            // The InitializeComponent() call is required for Windows Forms designer support.
            //
            InitializeComponent();
            
            try
            {
                Version version = new Version(Application.ProductVersion);            
                Text = string.Format("{0} {1}.{2}", Application.ProductName, version.Major, version.Minor);
                dtpExpiration.Value = new DateTime(2100, 12, 31);
                nudVersion.Minimum = 1;
                nudVersion.Maximum = 99;
            }
            catch
            {
                Text = Application.ProductName;
            }
            
            LoadProductList();
        }
        
        void MainFormKeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)27)
                Close();
        }
        
        void BtnAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("{0}\n\n© 2018, RadiXX11", Text), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
            cbProduct.Focus();
        }
        
        void LblHomepageLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                Process.Start("https://www.cyrobo.com");
            }
            catch
            {                
            }
        }
        
        void BtnActivateClick(object sender, EventArgs e)
        {
            if (cbProduct.SelectedIndex >= 0)
            {                
                if (nudVersion.Value < 0 || nudVersion.Value > 99)
                {
                    MessageBox.Show("Version number must be between 0 and 99.", "Activation", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    dtpExpiration.Focus();
                    return;                    
                }
                
                if (DateTime.Compare(dtpExpiration.Value, DateTime.Now) <= 0)
                {
                    MessageBox.Show("Expiration date must be greater than the current date.", "Activation", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    dtpExpiration.Focus();
                    return;
                }

                var productLicense = ProductLicensing.ProductList[cbProduct.SelectedIndex];
                productLicense.ProductVersion = (int)nudVersion.Value;
                productLicense.ProductExpiration = dtpExpiration.Value;
                
                if (productLicense.IsProductActivated())
                {
                    if (MessageBox.Show(string.Format("{0} is already activated.\n\nOverwrite registration data?", productLicense.ProductName), "Activation", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                        return;
                }

                Cursor.Current = Cursors.WaitCursor;
                btnActivate.Enabled = false;
                bool result = productLicense.ActivateProduct();
                btnActivate.Enabled = true;
                Cursor.Current = Cursors.Default;

                if (result)
                    MessageBox.Show(string.Format("{0} was sucessfully activated.", productLicense.ProductName), "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                else
                    MessageBox.Show(string.Format("Cannot activate {0}.\n\nMake sure to run this activator with admin rights and try again.", productLicense.ProductName), "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                
                cbProduct.Focus();
            }
        }
        
        void CbProductSelectedIndexChanged(object sender, EventArgs e)
        {
            if (cbProduct.SelectedIndex >= 0)
                nudVersion.Value = ProductLicensing.ProductList[cbProduct.SelectedIndex].ProductVersion;
        }
    }
}
