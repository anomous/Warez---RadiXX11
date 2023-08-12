using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Activator
{
    public static class License
    {
        public enum DBType
        {
            MySQL = 1,
            MSSQLServer,
            MSAccess,
            Oracle,
            FoxProDBFFiles,
            CSVText,
            CSVTextFolderPolling
        }
        
        public enum EditionType
        {
            Trial,
            Standard,
            Professional,
            Enterprise,
            DataLoader
        }
        
        public static readonly List<KeyValuePair<string, DBType>> DBList = new List<KeyValuePair<string, DBType>>()
        {
            new KeyValuePair<string, DBType>("MySQL", DBType.MySQL),
            new KeyValuePair<string, DBType>("MS SQL Server", DBType.MSSQLServer),
            new KeyValuePair<string, DBType>("MS Access", DBType.MSAccess),
            new KeyValuePair<string, DBType>("Oracle", DBType.Oracle),
            new KeyValuePair<string, DBType>("FoxPro/DBF Files", DBType.FoxProDBFFiles),
            new KeyValuePair<string, DBType>("CSV/Text", DBType.CSVText),
            new KeyValuePair<string, DBType>("CSV/Text (Folder Polling)", DBType.CSVTextFolderPolling)
        };
        
        public static readonly List<KeyValuePair<string, EditionType>> EditionList = new List<KeyValuePair<string, EditionType>>()
        {
            new KeyValuePair<string, EditionType>("Standard", EditionType.Standard),
            new KeyValuePair<string, EditionType>("Professional", EditionType.Professional),
            new KeyValuePair<string, EditionType>("Enterprise", EditionType.Enterprise),
            new KeyValuePair<string, EditionType>("DataLoader", EditionType.DataLoader)
        };
        
        private static string Encrypt(string text, string key)
        {
            string result = string.Empty;
            
            try
            {
                var DES = new TripleDESCryptoServiceProvider()
                {
                    Key = MD5Hash(key),
                    Mode = CipherMode.ECB
                };
                var bytes = Encoding.ASCII.GetBytes(text);
                result = Convert.ToBase64String(DES.CreateEncryptor().TransformFinalBlock(bytes, 0, bytes.Length));
            }
            catch
            {
            }
            
            return result;            
        }
        
        private static byte[] MD5Hash(string value)
        {
            return new MD5CryptoServiceProvider().ComputeHash(Encoding.ASCII.GetBytes(value));
        }

        public static bool Activate(string appPath, EditionType editionType, DBType sourceDB, DBType targetDB)
        {
            bool result = false;
            
            try
            {
                // 1. Generate and save the license file to the app folder
                
                var sb = new StringBuilder("@#j%882z76%@00a7%28772##jz");
                
                switch (editionType)
                {
                    case EditionType.Trial:                    
                    case EditionType.Standard:
                    case EditionType.Professional:
                    case EditionType.Enterprise:
                        sb[12] = Convert.ToString((int)editionType)[0];
                        sb[13] = sb[12];
                        break;
                        
                    case EditionType.DataLoader:
                        sb[12] = Convert.ToString((int)sourceDB)[0];
                        sb[13] = Convert.ToString((int)targetDB)[0];                    
                        break;
                }
                
                File.WriteAllText(appPath + "\\DL.lic", Encrypt(sb.ToString(), "Bismillah"));
                
                // 2. Generate and save the license key to the registry
                
                const string Charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                var rnd = new Random();
                
                sb.Clear();
                
                for (int i=0; i<19; i++)
                    sb.Append(Charset[rnd.Next(Charset.Length)]);
                
                sb[4] = '-';
                sb[9] = '-';
                sb[14] = '-';
                
                switch (editionType)
                {
                    case EditionType.Trial:
                        sb[13] = '0';
                        break;
                        
                    case EditionType.Standard:
                        sb[13] = 'T';
                        break;
                        
                    case EditionType.Professional:
                        sb[13] = 'Q';
                        break;
                        
                    case EditionType.Enterprise:
                        sb[13] = 'F';
                        break;
                        
                    case EditionType.DataLoader:
                        sb[13] = rnd.Next(1, 4).ToString()[0];
                        break;
                }                
                
                RegistryKey registryKey = null;
                
                try
                {
                    registryKey = Registry.CurrentUser.CreateSubKey(@"Software\VB and VBA Program Settings\ICAHyd\DL");
                        
                    if (registryKey != null)
                    {
                        registryKey.SetValue("SKey", sb.ToString());
                        result = true;
                    }
                }
                finally
                {
                    if (registryKey != null)
                        registryKey.Close();
                }                
            }
            catch
            {
                result = false;
            }
            
            return result;
        }
    }
}
