using System;
using System.Drawing;
using System.Windows.Forms;

namespace Keygen
{
    /// <summary>
    /// Description of MainForm.
    /// </summary>
    public partial class MainForm : Form
    {        
        private void FillLicenseTypeComboBox(ProductInfo productInfo)
        {
            comboBoxLicenseType.Items.Clear();
            
            foreach (var licenseType in Enum.GetValues(typeof(LicenseTypes)))
            {
                if (productInfo.LicenseTypes.HasFlag((LicenseTypes)licenseType) && (LicenseTypes)licenseType != LicenseTypes.All)
                    comboBoxLicenseType.Items.Add(licenseType);
            }
            
            if (comboBoxLicenseType.Items.Count > 0)
                comboBoxLicenseType.SelectedIndex = 0;
        }
        
        private void FillProductComboBox()
        {
            comboBoxProduct.Items.Clear();
            
            foreach (var product in ProductLicense.ProductList)
            {
                comboBoxProduct.Items.Add(product.Name);                    
            }
            
            if (comboBoxProduct.Items.Count > 0)
                comboBoxProduct.SelectedIndex = 0;            
        }
        
        public MainForm()
        {
            //
            // The InitializeComponent() call is required for Windows Forms designer support.
            //
            InitializeComponent();
            
            FillProductComboBox();
        }
        
        void ButtonAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(this.Text + "\n\n© 2017, RadiXX11\n\nFor educational and practical purposes ONLY.", "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        
        void ButtonCopyClick(object sender, EventArgs e)
        {
            textBoxLicenseKey.SelectAll();
            textBoxLicenseKey.Copy();
            textBoxLicenseKey.SelectionLength = 0;
        }
        
        void ButtonGenerateClick(object sender, EventArgs e)
        {
            if (comboBoxProduct.SelectedIndex >= 0 && comboBoxLicenseType.SelectedIndex >= 0)
            {
                LicenseTypes licenseType;
                
                if (Enum.TryParse<LicenseTypes>(comboBoxLicenseType.Text, out licenseType))
                {
                    textBoxLicenseKey.Text = ProductLicense.ProductList[comboBoxProduct.SelectedIndex].GetLicenseKey(licenseType);
                    textBoxLicenseKey.Enabled = true;
                    return;
                }
            }
            
            textBoxLicenseKey.Text = string.Empty;
            textBoxLicenseKey.Enabled = false;
        }
                
        void ComboBoxDrawItem(object sender, DrawItemEventArgs e)
        {
            var cbx = sender as ComboBox;
          
            if (cbx != null)
            {
                // Always draw the background
                e.DrawBackground();
            
                // Drawing one of the items?
                if (e.Index >= 0)
                {
                    // Set the string alignment.  Choices are Center, Near and Far
                    var sf = new StringFormat();
                    sf.LineAlignment = StringAlignment.Center;
                    sf.Alignment = StringAlignment.Center;
            
                    // Set the Brush to ComboBox ForeColor to maintain any ComboBox color settings
                    // Assumes Brush is solid
                    Brush brush = new SolidBrush(cbx.ForeColor);

                    // If drawing highlighted selection, change brush
                    if ((e.State & DrawItemState.Selected) == DrawItemState.Selected)
                        brush = SystemBrushes.HighlightText;

                    // Draw the string
                    e.Graphics.DrawString(cbx.Items[e.Index].ToString(), cbx.Font, brush, e.Bounds, sf);
                }
            }          
        }
        
        void ComboBoxLicenseTypeSelectedIndexChanged(object sender, EventArgs e)
        {
            buttonGenerate.PerformClick();
        }
                
        void ComboBoxProductSelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxProduct.SelectedIndex >= 0)
            {
                FillLicenseTypeComboBox(ProductLicense.ProductList[comboBoxProduct.SelectedIndex]);
                buttonGenerate.PerformClick();
            }
        }        
                
        void MainFormShown(object sender, EventArgs e)
        {
            textBoxLicenseKey.Text = "Select product/license or press Generate";
            textBoxLicenseKey.Enabled = false;
        }
    }
}
