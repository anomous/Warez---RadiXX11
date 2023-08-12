using System;
using System.Text;

namespace Keygen
{
    public class PluginLicense
    {
        private string name;
        private string passKey;
        
        public PluginLicense(string name, string passkey)
        {
            this.name = name;
            this.passKey = passkey;
        }
        
        public string GenerateKey(string name, int numLicenses)
        {
            if (!string.IsNullOrEmpty(name) && numLicenses > 0)
            {
                string key = string.Concat(name, "\r\n", DateTime.Now.ToString("yyyy-MM-dd"), "\r\n", numLicenses, "\r\nABCDEFG");
                return new BlowFish(Encoding.ASCII.GetBytes(passKey)).Encrypt_CBC(key);
            }
                        
            return string.Empty;
        }
        
        public string Name
        {
            get { return name; }
        }
        
        public string PassKey
        {
            get { return passKey; }
        }
    }
    
    public static class License 
    {
        public static readonly PluginLicense[] PluginList = {
            new PluginLicense("KS.CRM.DeDupe", "o0ßd$4jvJjövEuhlöbJj62iöHkvxb.mfs67klklpbdauümkggOGpühfd"),
            new PluginLicense("KS.CRM.Opportunities", "lkheEr#0Rtr(8=??aYgGkc%rjjvy(Wqi*ukF--$s>K++vLJPd%27WApX"),
            new PluginLicense("KS.CRM.Products", "kg(H4s)0Hipu7/dhN9b5%2c8krL0(WqGlcL4h/ffpp++vEEM5c27WApo"),
            new PluginLicense("KS.CRM.Sales", "?*{80=)0RtdF4§d2aYMkFPc8k::0(WqIIukFfd$s>K++vLJPd%27WApX")
        };
    }
}
