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
            
            foreach (var product in Activation.ProductList)
                cboProduct.Items.Add(product.Name);
            
            if (cboProduct.Items.Count > 0)
                cboProduct.SelectedIndex = 0;
        }
        
        void MainFormKeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 27)
                Close();
        }
        
        void BtnCopyClick(object sender, EventArgs e)
        {
            txtActivationCode.SelectAll();
            txtActivationCode.Copy();
            txtActivationCode.SelectionLength = 0;
        }
        
        void BtnAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("{0}\n\nVersion {1}\n\n© 2019, RadiXX11", Application.ProductName, Application.ProductVersion), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        
        void LblHomepageLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                Process.Start("https://www.vinitysoft.com");
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
                var product = Activation.ProductList[cboProduct.SelectedIndex];
                
                cboEdition.Items.Clear();
                
                foreach (var edition in product.Editions)                    
                    cboEdition.Items.Add(edition.Key);
                
                if (cboEdition.Items.Count > 0)
                    cboEdition.SelectedIndex = 0;
            }
        }
        
        void OnChange(object sender, EventArgs e)
        {
            string idCode = txtIdCode.Text.Trim();
            
            if (cboProduct.SelectedIndex >= 0 && cboEdition.SelectedIndex >= 0 && !string.IsNullOrEmpty(idCode))
            {
                txtActivationCode.Text = Activation.ProductList[cboProduct.SelectedIndex].GenerateActivationCode(idCode, cboEdition.SelectedIndex);
                btnCopy.Enabled = true;
            }
            else
            {
                txtActivationCode.Text = "Enter your Identification Code...";
                btnCopy.Enabled = false;
            }
        }
        
        void MainFormShown(object sender, EventArgs e)
        {
            txtIdCode.Focus();
        }
    }
}
