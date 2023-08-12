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
        private const string AppEXEName = "\\DataLoader.exe";
        
        private int GetRandomIntNotEqualTo(int max, int value)
        {
            int result;
            var rnd = new Random();
                
            do {
                result = rnd.Next(max);
            } while (result == value);

            return result;
        }
        
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
            folderBrowserDialog.SelectedPath = Application.StartupPath;
            
            foreach (var db in License.DBList)
            {
                cboSourceDB.Items.Add(db.Key);
                cboTargetDB.Items.Add(db.Key);
            }
            
            if (cboSourceDB.Items.Count > 0)
                cboSourceDB.SelectedIndex = GetRandomIntNotEqualTo(cboSourceDB.Items.Count, -1);
                
            if (cboTargetDB.Items.Count > 0)
                cboTargetDB.SelectedIndex = GetRandomIntNotEqualTo(cboSourceDB.Items.Count, cboSourceDB.SelectedIndex);                
                                    
            int index = 0;
            
            foreach (var edition in License.EditionList)
            {
                cboEdition.Items.Add(edition.Key);
                
                if (edition.Value == License.EditionType.Enterprise)
                    index = License.EditionList.IndexOf(edition);                
            }
                        
            if (cboEdition.Items.Count > 0)
                cboEdition.SelectedIndex = index;
        }
        
        void BtnAboutClick(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("{0}\n\nVersion {1}\n\n© 2019, RadiXX11", Application.ProductName, Application.ProductVersion), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        
        void LblHomepageLinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                Process.Start("https://www.dbload.com");
            }
            catch
            {
                MessageBox.Show("Cannot open default web browser!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        
        void BtnActivateClick(object sender, EventArgs e)
        {
            if (cboEdition.SelectedIndex >= 0 && cboSourceDB.SelectedIndex >= 0 && cboTargetDB.SelectedIndex >= 0)
            {
                string path = Application.StartupPath;
                
                if (!File.Exists(path + AppEXEName))
                    path = folderBrowserDialog.SelectedPath;
                
                if (!File.Exists(path + AppEXEName))
                {                    
                    while (true)
                    {
                        if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
                        {                 
                            path = folderBrowserDialog.SelectedPath;
                            
                            if (string.IsNullOrEmpty(path))
                                return;
                            
                            if (path[path.Length - 1] == '\\')
                                path = path.Remove(path.Length - 1, 1);
                            
                            if (File.Exists(path + AppEXEName))
                                break;
                            
                            MessageBox.Show(string.Format("{0} is not a valid Data Loader installation folder!", path), Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        }
                        else
                            return;
                    }
                }
                
                License.EditionType edition = License.EditionList[cboEdition.SelectedIndex].Value;
                License.DBType sourceDB = License.DBList[cboSourceDB.SelectedIndex].Value;
                License.DBType targetDB = License.DBList[cboTargetDB.SelectedIndex].Value;                 
                
                if (License.Activate(path, edition, sourceDB, targetDB))
                    MessageBox.Show("Data Loader successfully activated.", Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
                else
                    MessageBox.Show("Cannot activate Data Loader!", Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);                
            }
        }
        
        void DBSelectedIndexChanged(object sender, EventArgs e)
        {
            if (cboSourceDB.SelectedIndex == cboTargetDB.SelectedIndex)
            {
                int index = GetRandomIntNotEqualTo(cboSourceDB.Items.Count, cboSourceDB.SelectedIndex);

                if (sender == cboSourceDB)
                    cboTargetDB.SelectedIndex = index;
                else
                    cboSourceDB.SelectedIndex = index;
            }
        }
        
        void CboEditionSelectedIndexChanged(object sender, EventArgs e)
        {            
            gboDBType.Enabled = (cboEdition.SelectedIndex >= 0 && License.EditionList[cboEdition.SelectedIndex].Value == License.EditionType.DataLoader);
        }
    }
}
