using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Security.Cryptography;
using System.Text;

namespace LicGen
{   
    public static class License
    {
        private static readonly string licensePath = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData) + "\\com.tinyapp.TablePlus\\.licensewin";
        private const string credentialPass = "JfatmQbk2rqpWjjsH8XgG7eNa9BzhyNRLdZmChV9KeJ53ZHmk9pdnsJt7NsQrvkpkyQfGVyqU9LASqQgWUSYAKHG3kZpRgUBjRLPmVwfAjVXHkWhtBp9vQ7vs7akn3Dvj2ZBXcdKfQM7y4yeYJ2tHa7nzYKXv2KaBE5XacgZGPNzJb7mbLtTZepg9LjwTv4RYCvL3ZEqBNY8tr4xsatv6y9xhGddvUqsEsJz8mDh9d4tgVjjqRq98g7V2hLb82ju";
        
        private static string Base64Encode(string plainText)
        {
            return string.IsNullOrEmpty(plainText) ? "" : Convert.ToBase64String(Encoding.UTF8.GetBytes(plainText));
        }
        
        private static string CreateMD5(string input)
        {
            string result;
            
            using (MD5 md = MD5.Create())
            {
                byte[] bytes = Encoding.ASCII.GetBytes(input);
                byte[] array = md.ComputeHash(bytes);
                var stringBuilder = new StringBuilder();
                
                for (int i = 0; i < array.Length; i++)
                    stringBuilder.Append(array[i].ToString("X2"));

                result = stringBuilder.ToString();
            }
            
            return result;
        }
        
        public static string Encrypt(string plainText, string passPhrase)
        {
            byte[] array = Generate256BitsOfRandomEntropy();
            byte[] array2 = Generate256BitsOfRandomEntropy();
            byte[] bytes = Encoding.UTF8.GetBytes(plainText);
            string result;
            
            using (var rfc2898DeriveBytes = new Rfc2898DeriveBytes(passPhrase, array, 1000))
            {
                byte[] bytes2 = rfc2898DeriveBytes.GetBytes(32);
                
                using (var rijndaelManaged = new RijndaelManaged())
                {
                    rijndaelManaged.BlockSize = 256;
                    rijndaelManaged.Mode = CipherMode.CBC;
                    rijndaelManaged.Padding = PaddingMode.PKCS7;
                    
                    using (ICryptoTransform cryptoTransform = rijndaelManaged.CreateEncryptor(bytes2, array2))
                    {
                        using (var memoryStream = new MemoryStream())
                        {
                            using (var cryptoStream = new CryptoStream(memoryStream, cryptoTransform, CryptoStreamMode.Write))
                            {
                                cryptoStream.Write(bytes, 0, bytes.Length);
                                cryptoStream.FlushFinalBlock();
                                byte[] inArray = array.Concat(array2).ToArray<byte>().Concat(memoryStream.ToArray()).ToArray<byte>();
                                memoryStream.Close();
                                cryptoStream.Close();
                                result = Convert.ToBase64String(inArray);
                            }
                        }
                    }
                }
            }
            
            return result;
        }
        
        private static byte[] Generate256BitsOfRandomEntropy()
        {
            var array = new byte[32];
            
            using (var rngcryptoServiceProvider = new RNGCryptoServiceProvider())
            {
                rngcryptoServiceProvider.GetBytes(array);
            }
            
            return array;
        }
        
        private static string GetDeviceID()
        {
            string macAdress = GetMacAdress();            
            return !string.IsNullOrEmpty(macAdress) ? CreateMD5(macAdress).ToLower() : null;
        }

        private static string GetLine(Dictionary<string, string> d)
        {
            var stringBuilder = new StringBuilder();
            
            foreach (KeyValuePair<string, string> keyValuePair in d)
                stringBuilder.Append(keyValuePair.Key).Append(":").Append(keyValuePair.Value).Append(',');

            return stringBuilder.ToString().TrimEnd(new char[] {','});
        }
        
        private static string GetMacAdress()
        {
            return (from nic in NetworkInterface.GetAllNetworkInterfaces()
            where nic.OperationalStatus == OperationalStatus.Up && nic.NetworkInterfaceType != NetworkInterfaceType.Loopback
            select nic.GetPhysicalAddress().ToString()).FirstOrDefault<string>();
        }

        private static bool WriteFile(string content, string path)
        {
            bool result;
            
            try
            {
                new FileInfo(path).Directory.Create();
                File.WriteAllText(path, content);
                result = true;
            }
            catch
            {                
                result = false;
            }
            
            return result;
        }
        
        public static bool GenerateLicenseFile(string email)
        {
            bool result = false;
            
            try
            {
                var dict = new Dictionary<string, string>
                {
                    {
                        "deviceID",
                        GetDeviceID()
                    },
                    {
                        "updatesAvailableUntil",
                        "unused"
                    },
                    {
                        "email",
                        email
                    },
                    {
                        "sign",
                        Base64Encode(new Random().Next().ToString())
                    }
                };
                
                if (File.Exists(licensePath))
                    File.SetAttributes(licensePath, FileAttributes.Normal);
                    
                if (WriteFile(Encrypt(GetLine(dict), credentialPass), licensePath))
                {
                    File.SetAttributes(licensePath, File.GetAttributes(licensePath) | FileAttributes.Hidden);
                    result = true;
                }
            }
            catch
            {
            }
            
            return result;
        }
    }
}
