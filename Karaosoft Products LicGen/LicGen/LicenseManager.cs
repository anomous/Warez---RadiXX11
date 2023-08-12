using System;
using System.IO;

namespace LicGen
{
    public static class LicenseManager
    {
        private static string GenerateKey(int productId, string name)
        {
            int key = 0;
            
            foreach (var c in name.Trim())
                key += c;
            
            return (key * productId + 12151967).ToString();
        }        
        
        public static bool GenerateLicenseFile(ProductInfo productInfo, string name, DateTime expiration)
        {
            bool result = false;
            
            if (!string.IsNullOrEmpty(name))
            {
                try
                {
                    string path = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + productInfo.LicensePath;
                    string dir = Path.GetDirectoryName(path);
                    
                    if (!Directory.Exists(dir))
                        Directory.CreateDirectory(dir);
                    
                    if (File.Exists(path))
                        File.Delete(path);
                            
                    File.WriteAllText(path, "");
                    
                    var creationTime = File.GetCreationTime(path);            
                    var expirationTime = (long)Math.Round((double)expiration.ToBinary() / 24434607.0) + (long)creationTime.Year + (long)(creationTime.DayOfYear * 1234567);            
                    var data = string.Format("\"{0}\",{1},{2},{3},{4},", name.Trim(), GenerateKey(productInfo.Id, name), creationTime.DayOfYear * 1967 + creationTime.Millisecond * 77, expiration.ToBinary(), expirationTime);
        
                    File.WriteAllText(path, data);
                    
                    result = true;
                }
                catch
                {
                }
            }
            
            return result;
        }        
    }
}
