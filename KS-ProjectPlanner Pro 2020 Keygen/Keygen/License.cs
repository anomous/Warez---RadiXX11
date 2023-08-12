using System;
using System.Text;

namespace Keygen
{
    public static class License
    {
        public static string GenerateKey(string name, int numLicenses)
        {
            name = name.Trim();
            
            if (!string.IsNullOrEmpty(name) && numLicenses > 0)
            {
                string key = string.Concat(name, "\n", DateTime.Now.ToString("yyyy-MM-dd"), "\n", numLicenses, "\n", DateTime.Now.AddYears(100).ToString("yyyy-MM-dd"), "\nABCDEFG");
                return new BlowFish(Encoding.ASCII.GetBytes("jU6s&fmhsoP?jgbCsdoiwd98hkjrl0=zjiOlsap9POUjlkU)(jkot&$s")).Encrypt_CBC(key);
            }
            
            return string.Empty;
        }
    }
}
