//------------------------------------------------------------------------------
// Programming.de Software Keygen
//
// Products homepage: https://www.programming.de
//
// © 2020, RadiXX11
// https://radixx11rce2.blogspot.com
//
// DISCLAIMER: This source code is distributed AS IS, for educational purposes
// ONLY. No other use is permitted without expressed permission from the author.
//------------------------------------------------------------------------------

using System;
using System.Collections;
using System.Text;
using System.Security.Cryptography;
using System.Management;
using Microsoft.Win32;

namespace Keygen
{
    public class ProductLicense
    {
        private readonly string name;
        private readonly string password;
        private readonly bool usesNewLicense;        
        
        private static string Boring(string st)
        {
            for (int i = 0; i < st.Length; i++)
            {
                int num = i * (int)Convert.ToUInt16(st[i]);
                num %= st.Length;
                char c = st[i];
                st = st.Remove(i, 1);
                st = st.Insert(num, c.ToString());
            }
            
            return st;
        }
        
        private static string DecodeProductKey(byte[] digitalProductId)
        {
            var array = new []
            {
                'B',
                'C',
                'D',
                'F',
                'G',
                'H',
                'J',
                'K',
                'M',
                'P',
                'Q',
                'R',
                'T',
                'V',
                'W',
                'X',
                'Y',
                '2',
                '3',
                '4',
                '6',
                '7',
                '8',
                '9'
            };
            var array2 = new char[29];
            var arrayList = new ArrayList();
            
            for (int i = 52; i <= 67; i++)
                arrayList.Add(digitalProductId[i]);

            for (int j = 28; j >= 0; j--)
            {
                if ((j + 1) % 6 == 0)
                    array2[j] = '-';
                else
                {
                    int num = 0;
                    
                    for (int k = 14; k >= 0; k--)
                    {
                        int num2 = num << 8 | (int)((byte)arrayList[k]);
                        arrayList[k] = (byte)(num2 / 24);
                        num = num2 % 24;
                        array2[j] = array[num];
                    }
                }
            }
            
            return new string(array2);
        }
    
        private static string DecodeProductKeyWin8AndUp(byte[] digitalProductId)
        {
            string text = string.Empty;
            digitalProductId[66] = (byte)(digitalProductId[66] & 247);
            int num = 0;
            
            for (int i = 24; i >= 0; i--)
            {
                int num2 = 0;
                
                for (int j = 14; j >= 0; j--)
                {
                    num2 *= 256;
                    num2 = (int)digitalProductId[j + 52] + num2;
                    digitalProductId[j + 52] = (byte)(num2 / 24);
                    num2 %= 24;
                    num = num2;
                }
                
                text = "BCDFGHJKMPQRTVWXY2346789"[num2] + text;
            }
            
            text = text.Substring(1, num) + "N" + text.Substring(num + 1, text.Length - (num + 1));
            
            for (int i = 5; i < text.Length; i += 6)
                text = text.Insert(i, "-");

            return text;
        }
        
        private static string GetComputerID(string secret_string)
        {
            string text;
            string text2;
            int i;
            string systemInfo = GetSystemInfo();
            string s = Boring(InverseByBase(systemInfo, 50));
            var md5CryptoServiceProvider = new MD5CryptoServiceProvider();
            byte[] array = Encoding.UTF8.GetBytes(s);
            array = md5CryptoServiceProvider.ComputeHash(array);
            text = BitConverter.ToString(array).Replace("-", "");
            text2 = string.Empty;
            i = 0;

            while (i < text.Length)
            {
                text2 += text.Substring(i, 1);
                
                if ((i + 1) % 4 == 0 && i < text.Length - 1)
                    text2 += "-";

                i++;
            }
            
            return text2;
        }
        
        private static string GetSystemInfo()
        {
            string text = string.Empty;
            string text2 = string.Empty;
            string text3 = string.Empty;
            
            try
            {
                text2 = Environment.UserName;
            }
            // disable once EmptyGeneralCatchClause
            catch
            {
            }
            try
            {
                text = GetWindowsSerial();
            }
            // disable once EmptyGeneralCatchClause
            catch
            {
            }
            
            if (!string.IsNullOrWhiteSpace(text2))
                text2 = RemoveUseless(text2).ToUpper();

            if (!string.IsNullOrWhiteSpace(text))
                text = RemoveUseless(text).ToUpper();

            text3 = text2 + text + new string('3', 50);
            
            return text3.Substring(0, 50);
        }
        
        private static string GetWindowsProductKey()
        {
            var registryKey = Environment.Is64BitOperatingSystem ? RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry64) : RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry32);
            var digitalProductId = (byte[])registryKey.OpenSubKey("SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion").GetValue("DigitalProductId");
            string result = ((Environment.OSVersion.Version.Major == 6 && Environment.OSVersion.Version.Minor >= 2) || Environment.OSVersion.Version.Major > 6) ? DecodeProductKeyWin8AndUp(digitalProductId) : DecodeProductKey(digitalProductId);
            registryKey.Close();
            return result;
        }
        
        private static string GetWindowsSerial()
        {
            var managementObjectSearcher = new ManagementObjectSearcher("Select * from Win32_OperatingSystem");
            
            using (ManagementObjectCollection.ManagementObjectEnumerator enumerator = managementObjectSearcher.Get().GetEnumerator())
            {
                if (enumerator.MoveNext())
                {
                    var managementObject = (ManagementObject)enumerator.Current;
                    return managementObject["SerialNumber"].ToString();
                }
            }
            
            return string.Empty;
        }
        
        private static string InverseByBase(string st, int MoveBase)
        {
            var stringBuilder = new StringBuilder();
            
            for (int i = 0; i < st.Length; i += MoveBase)
            {
                int length;
                
                if (i + MoveBase > st.Length - 1)
                    length = st.Length - i;
                else
                    length = MoveBase;
                
                stringBuilder.Append(InverseString(st.Substring(i, length)));
            }
            
            return stringBuilder.ToString();
        }

        private static string InverseString(string st)
        {
            var stringBuilder = new StringBuilder();
            
            for (int i = st.Length - 1; i >= 0; i--)
                stringBuilder.Append(st[i]);

            return stringBuilder.ToString();
        }
        
        private static string MD5KeyFromString(string s)
        {
            HashAlgorithm hashAlgorithm = new MD5CryptoServiceProvider();
            byte[] array = Encoding.UTF8.GetBytes(s);
            array = hashAlgorithm.ComputeHash(array);
            string text = BitConverter.ToString(array).Replace("-", "");
            var stringBuilder = new StringBuilder();
            
            for (int i = 0; i < text.Length; i++)
            {
                stringBuilder.Append(text.Substring(i, 1));
                
                if ((i + 1) % 4 == 0 && i < text.Length - 1)
                    stringBuilder.Append("-");
            }
            
            return stringBuilder.ToString();
        }
        
        private static string RemoveUseless(string st)
        {
            for (int i = st.Length - 1; i >= 0; i--)
            {
                char c = char.ToUpper(st[i]);
                
                if ((c < 'A' || c > 'Z') && (c < '0' || c > '9'))
                    st = st.Remove(i, 1);
            }
            
            return st;
        }
        
        private string GenerateActivationKeyV1(string licenseKey)
        {
            return MD5KeyFromString(GetComputerID(password) + licenseKey + password);
        }
        
        private string GenerateActivationKeyV2(string licenseKey)
        {
            return MD5KeyFromString(MD5KeyFromString(GetWindowsProductKey() + Environment.UserName + licenseKey) + licenseKey + password);
        }

        public ProductLicense(string name, string password, bool usesNewLicense)
        {
            this.name = name;
            this.password = password;
            this.usesNewLicense = usesNewLicense;
        }
        
        public string GenerateActivationKey(string licenseKey)
        {
            if (!string.IsNullOrEmpty(licenseKey))
                return (usesNewLicense) ? GenerateActivationKeyV2(licenseKey) : GenerateActivationKeyV1(licenseKey);
            
            return string.Empty;
        }
        
        public string Name
        {
            get { return name; }
        }
    }
    
    public static class License
    {
        public static string GenerateLicenseKey()
        {
            var rnd = new Random();
            var stringBuilder = new StringBuilder(32);
            
            for (int i=0; i<32; i++)
            {
                stringBuilder.Append(string.Format("{0:X}", rnd.Next(16)));
                
                if (((i + 1) % 4 == 0) && (i < 31))
                    stringBuilder.Append("-");
            }

            return stringBuilder.ToString();
        }
        
        public static readonly ProductLicense[] ProductList = {
            new ProductLicense("Jumbo Timer", "JumbTmr 08XYZ", false),
            new ProductLicense("MultiTimer", "peVxtLe00qAeA8mWLHrSDJ4KA8RtJk", true),
            new ProductLicense("Notebook", "NotEs 2013", false),
            new ProductLicense("Sharp World Clock 8", "8z2jmAlkInE5m20xMi234jHBbA", true),
            new ProductLicense("TelePrompter", "eAAWFuf76vh6K70uSkqHsLJ4u02FgP", true)
        };
    }
}
