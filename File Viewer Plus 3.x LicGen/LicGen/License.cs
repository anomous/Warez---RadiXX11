using System;
using System.IO;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Win32;

namespace LicGen
{
    public static class License
    {
        private static string Encrypt(string plainText, string passPhrase, string saltValue, string hashAlgorithm, int passwordIterations, string initVector, int keySize)
        {
            byte[] bytes = Encoding.ASCII.GetBytes(initVector);
            byte[] bytes2 = Encoding.ASCII.GetBytes(saltValue);
            byte[] bytes3 = Encoding.UTF8.GetBytes(plainText);
            byte[] bytes4 = new PasswordDeriveBytes(passPhrase, bytes2, hashAlgorithm, passwordIterations).GetBytes(keySize / 8);
            ICryptoTransform transform = new RijndaelManaged
            {
                Mode = CipherMode.CBC
            }.CreateEncryptor(bytes4, bytes);
            var memoryStream = new MemoryStream();
            var cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Write);
            
            cryptoStream.Write(bytes3, 0, bytes3.Length);
            cryptoStream.FlushFinalBlock();
            
            byte[] inArray = memoryStream.ToArray();
            
            memoryStream.Close();
            cryptoStream.Close();
            
            return Convert.ToBase64String(inArray);
        }
        
        private static string EncryptRegLicense(string key, DateTime lastVerifiedDate, bool deactivated)
        {
            string str = deactivated ? "2" : "1";
            string str2 = lastVerifiedDate.ToString("yyyy-MM-dd-HHmm", CultureInfo.InvariantCulture);
            key = key.Replace("-", "").ToUpper();
            
            return Encrypt(GetRegKeyPad() + str2 + str + key, GetMachineFingerprint() + GetRegEncryptKeyPass(), GetRegEncryptKeySalt(), "SHA1", 2, GetRegEncryptKeyInitVector(), 256);
        }
        
        private static string GenerateRegKey()
        {
            string regKey = string.Empty;
            var rand = new Random();
            
            for (int i=0; i < 10; i++)
                regKey += rand.Next(16).ToString("X");
                        
            regKey += SHA1(regKey.Substring(3, 5)).Substring(5, 2).ToUpper();
            regKey += SHA1(regKey.Substring(1, 3)).Substring(2, 2).ToUpper();
            regKey += SHA1(regKey.Substring(4, 4)).Substring(11, 2).ToUpper();
            regKey += SHA1(regKey.Substring(2, 6)).Substring(7, 2).ToUpper();
            
            for (int i=0; i < 2; i++)
                regKey += rand.Next(16).ToString("X");            

            regKey = "F3" + regKey;
            regKey += SHA1(GetRegKeyGenPrefix() + regKey).Substring(12, 3).ToUpper();
            regKey = regKey.Insert(5, "-");
            regKey = regKey.Insert(11, "-");
            regKey = regKey.Insert(17, "-");
            regKey = regKey.Insert(23, "-");
            
            return regKey;
        }
        
        private static string GetLicenseDir()
        {
            return KnownFolderUtils.GetFolderFromKnownFolderGUID(KnownFolderUtils.Public) + "\\File Viewer Plus";
        }
        
        private static string GetLicensePath()
        {
            return GetLicenseDir() + "\\fvp3.lic";
        }
        
        private static string GetMachineFingerprint()
        {
            string text = null;
            
            try
            {
                text = (string)RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry64).OpenSubKey("SOFTWARE\\Microsoft\\Cryptography").GetValue("MachineGuid");
            }
            catch
            {
            }
            
            if (text == null)
                text = "";

            return text;
        }
        
        private static string GetRegEncryptKeyInitVector()
        {
            return ReverseString("tG5a3h@L") + ReverseString("4jI@0mL2");
        }
        
        private static string GetRegEncryptKeyPass()
        {
            return string.Concat(new string[]
            {
                ReverseString("3Tp4Hc"),
                ReverseString("3nOR"),
                "ver53@",
                ReverseString("0R@!71"),
                "m4n5"
            });
        }

        private static string GetRegEncryptKeySalt()
        {
            return ReverseString(" 0rP") + ReverseString("T!sbR3v") + ReverseString("@!5E3rh");
        }        
        
        private static string GetRegKeyGenPrefix()
        {
            return ReverseString("o31v") + ReverseString("cCEf") + ReverseString("!21hC");
        }
        
        private static string GetRegKeyPad()
        {
            return ReverseString("hC3n0") + ReverseString("!1R3Tpa") + ReverseString("3G@@") + ReverseString("sI53n");
        }

        private static string ReverseString(string s)
        {
            char[] array = s.ToCharArray();
            
            Array.Reverse(array);
            return new string(array);
        }

        private static bool SaveLicenseFile(string licData)
        {
            try
            {
                File.WriteAllText(GetLicensePath(), licData, Encoding.UTF8);
            }
            catch
            {
                return false;
            }
            
            return true;
        }
        
        private static string SHA1(string input)
        {
            string result;
            
            using (var sha1Managed = new SHA1Managed())
            {
                byte[] array = sha1Managed.ComputeHash(Encoding.UTF8.GetBytes(input));
                var stringBuilder = new StringBuilder(array.Length * 2);
                
                foreach (byte b in array)
                    stringBuilder.Append(b.ToString("X2"));

                result = stringBuilder.ToString();
            }
            
            return result;
        }        
        
        public static bool GenerateLicenseFile()
        {
            try
            {
                var dir = GetLicenseDir();
                
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);
                
                return SaveLicenseFile(EncryptRegLicense(GenerateRegKey(), DateTime.UtcNow, false));
            }
            catch
            {
                return false;
            }
        }
    }
}
