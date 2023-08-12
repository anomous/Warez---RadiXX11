using Microsoft.VisualBasic.CompilerServices;
using System;
using System.IO;
using System.Management;
using System.Security.Cryptography;
using System.Text;

namespace Keygen
{
    public static class License
    {
        private const string sKy = "lkirwf897+22#bbtrm8814z5qq=498j5";
        private const string sIV = "741952hheeyy66#cs!9hjv887mxx7@8y";
        
        private static object EncryptRJ256(string prm_key, string prm_iv, string prm_text_to_encrypt)
        {
            var rijndaelManaged = new RijndaelManaged();
            rijndaelManaged.Padding = PaddingMode.Zeros;
            rijndaelManaged.Mode = CipherMode.CBC;
            rijndaelManaged.KeySize = 256;
            rijndaelManaged.BlockSize = 256;
            byte[] bytes = Encoding.ASCII.GetBytes(prm_key);
            byte[] bytes2 = Encoding.ASCII.GetBytes(prm_iv);
            ICryptoTransform transform = rijndaelManaged.CreateEncryptor(bytes, bytes2);
            var memoryStream = new MemoryStream();
            var cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Write);
            byte[] bytes3 = Encoding.ASCII.GetBytes(prm_text_to_encrypt);
            cryptoStream.Write(bytes3, 0, bytes3.Length);
            cryptoStream.FlushFinalBlock();
            byte[] inArray = memoryStream.ToArray();
            
            return Convert.ToBase64String(inArray);
        }
        
        private static string Encrypt(string str)
        {
            return Conversions.ToString(EncryptRJ256(sKy, sIV, str));
        }
        
        private static string GetMotherBoardUUID()
        {
            string result;
            
            try
            {
                var managementObjectSearcher = new ManagementObjectSearcher("root\\CIMV2", "SELECT * FROM Win32_ComputerSystemProduct");
                ManagementObjectCollection.ManagementObjectEnumerator enumerator = null;
                
                try
                {
                    enumerator = managementObjectSearcher.Get().GetEnumerator();
                    
                    if (enumerator.MoveNext())
                    {
                        var managementObject = (ManagementObject)enumerator.Current;
                        
                        return Conversions.ToString(managementObject["UUID"]);
                    }
                }
                finally
                {                    
                    if (enumerator != null)
                        ((IDisposable)enumerator).Dispose();
                }
                
                result = Conversions.ToString(true);
            }
            catch
            {
                result = Conversions.ToString(false);
            }
            
            return result;
        }
        
        public static bool CreateLicenseDataFile(string userName, string userEmail)
        {
            const string LicenseKeyCharset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            const int LicenseKeyLen = 24;
            
            try
            {
                var random = new Random();
                var licenseKey = new StringBuilder(LicenseKeyLen);
                licenseKey.Length = LicenseKeyLen;
                
                for (int i = 0; i < LicenseKeyLen; i++)
                    licenseKey[i] = LicenseKeyCharset[random.Next(LicenseKeyCharset.Length)];
                
                string userLicenseCode = Encrypt(GetMotherBoardUUID());
                string path = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\NUMShared";
                
                if (!Directory.Exists(path))
                    Directory.CreateDirectory(path);
                
                var fileStream = new FileStream(path + "\\NUMData.txt", FileMode.Create);
                var streamWriter = new StreamWriter(fileStream);
                
                streamWriter.Write("");
                streamWriter.Flush();
                streamWriter.WriteLine("UN:" + Encrypt(userName));
                streamWriter.WriteLine("UE:" + Encrypt(userEmail));
                streamWriter.WriteLine("EDDLK:" + licenseKey);
                streamWriter.WriteLine("ULC:" + userLicenseCode);
                streamWriter.Flush();
                streamWriter.Close();
                fileStream.Close();
                
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}
