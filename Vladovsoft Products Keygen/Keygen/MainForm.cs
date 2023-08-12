using System;
using System.Diagnostics;
using System.Windows.Forms;

namespace Keygen
{
    public partial class MainForm : Form
    {
        private void UpdateUnlockCode()
        {
            if (cboProduct.SelectedItem != null && !string.IsNullOrEmpty(txtProductID.Text))
            {
                txtUnlockCode.Text = License.GetUnlockCode(cboProduct.SelectedItem as string, txtProductID.Text);
                btnCopy.Enabled = true;
            }
            else
            {
                txtUnlockCode.Text = "Enter a product ID...";
                btnCopy.Enabled = false;
            }
        }
        
        public MainForm()
        {
            InitializeComponent();
        }
        
        void MainFormLoad(object sender, EventArgs e)
        {
            Text = Application.ProductName;            
            cboProduct.Items.AddRange(License.AppNames);
            cboProduct.SelectedIndex = 0;
            btnRead.PerformClick();
        }
        
        void MainFormShown(object sender, EventArgs e)
        {
            txtProductID.Focus();
        }
        
        void BtnAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("{0}\n\nVersion 1.0\n\n© 2019, RadiXX11 [RdX11]", Text), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        
        void BtnCopyClick(object sender, EventArgs e)
        {
            txtUnlockCode.SelectAll();
            txtUnlockCode.Copy();
            txtUnlockCode.SelectionLength = 0;
        }
        
        void BtnReadClick(object sender, EventArgs e)
        {
            txtProductID.Text = License.GetProductID();
        }        
        
        void TxtProductIDTextChanged(object sender, EventArgs e)
        {
            UpdateUnlockCode();
        }
        
        void CboProductSelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateUnlockCode();
        }
        
        void TxtProductIDKeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar))
                e.Handled = true;
        }
        
        void LblHomepageLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                Process.Start("https://www.vladovsoft.com");
            }
            catch
            {
                MessageBox.Show("Cannot open default web browser!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
    }
}
