using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Management;
using System.Security.Cryptography;
using System.Text;
using ServiceStack;

namespace Keygen
{
    public static class LicenseManager
    {                             
        private static string Encrypt(string data)
        {
            string result = "";
            
            try
            {
                byte[] buffer = Encoding.UTF8.GetBytes(data);
                byte[] key = null;
                int count = buffer.Length;
    
                using (var memoryStream = new MemoryStream())
                {            
                    using (Rijndael rijndael = Rijndael.Create())
                    {
                        rijndael.KeySize = 256;
                        rijndael.BlockSize = 128;
                        rijndael.IV = Encoding.UTF8.GetBytes("916BFAAF6A4D478A");
                        rijndael.GenerateKey();
                        
                        key = rijndael.Key;
                    
                        using (ICryptoTransform cryptoTransform = rijndael.CreateEncryptor())
                        {
                            using (var cryptoStream = new CryptoStream(memoryStream, cryptoTransform, CryptoStreamMode.Write))
                            {
                                cryptoStream.Write(buffer, 0, count);
                                cryptoStream.FlushFinalBlock();
                            }
                        }
                    }
                    
                    buffer = memoryStream.ToArray();
                }

                using (var rsacryptoServiceProvider = new RSACryptoServiceProvider())
                {
                    rsacryptoServiceProvider.FromXmlString("<RSAKeyValue><Modulus>6brvserpsXRlf6sfGU8gwgMR/fxLdd/wpJUEBSaXZeVaJyOwVdJ7VVDSPiyN0MqzTS25Xk5t8zU6DREAH770oigSvv4zlJaHy6MxOQjLCXxzaleKa9eLxlIi4pMkjbpVYm08fHvt7UmPOugAq3UX6OtaDnZeA2exEQBOHYxKz+s=</Modulus><Exponent>AQAB</Exponent><P>7bQzPyq7b0E7mOIjOevvF+Sm4E6oBc4hUmNcsfX4SGeFbRdajGw6WR3nj9UlibRwXOL275yxsn+Oi8uXiQpxtQ==</P><Q>+7hv7gdkbFomoYhX76rf14U6cLCQyDIhdflZ/921ks/j3TNbIdAivh8PMb2BMi4ky715HJKaXhkfunUBtw2/Hw==</Q><DP>o3Ktalnv2Gh6mn2ky0c4eK15MfPkBVnf/87jBlukBeVpEcJlOPmShYTSnUxrK20vdi96rPiKF7suQWIVKN5NoQ==</DP><DQ>h28DogEOMhILKOwPzB6W0wGWoN0O+Pen8y6XEsh6EiSSSAiCpt2yY7KYXT3FznbvS0OFby8dqTVBUfP0WUYnJw==</DQ><InverseQ>RrN+uRbM94YBLm92J2cNPI+cElIiHAsFvGy4RkS+DeD7q49tf6YVs729fR763UMdD80XQwPvUxBtAg7+qgvO2A==</InverseQ><D>HfNUb8oYdCLkNr3o2EdpfTMDhTZlPQ+bOJvXzgkp8Wa4bLeICxdTspUOu+Tdr1mqLEOls039jOLPM4lwKKFBm58rjfj0ZM7nKILCpOYLPU2BYUuzXrDkbdCj0k+nG2jt4FT4Am+tRzsLi6wZAQXyrW8QdhpJLjk86LnKrZ9OBVE=</D></RSAKeyValue>");
                    key = rsacryptoServiceProvider.Encrypt(key, true);
                }
                                
                using (var memoryStream = new MemoryStream())
                {
                    using (var binaryWriter = new BinaryWriter(memoryStream))
                    {
                        binaryWriter.Write(key.Length);
                        binaryWriter.Write(key);
                        binaryWriter.Write(count);
                        binaryWriter.Write(buffer.Length);
                        binaryWriter.Write(buffer);
                    }
                    
                    result = Convert.ToBase64String(memoryStream.ToArray());
                }
            }
            catch
            {
            }
            
            return result;
        }
        
        private static string GetBaseBoardHash()
        {
            return GetManagementObjectHash("Win32_BaseBoard", false, new string[]
            {
                "Manufacturer",
                "Model",
                "Product",
                "SerialNumber"
            });
        }
        
        private static string GetMachineCode()
        {
            return ToHex(new string[]
            {
                Environment.MachineName,
                GetProcessorHash(),
                GetBaseBoardHash()
            });
        }

        private static string GetManagementObjectHash(string sClass, bool bAll, params string[] asKeys)
        {
            if (sClass == null)
                throw new ArgumentNullException("sClass");

            string result;
            
            try
            {
                using (var managementObjectSearcher = new ManagementObjectSearcher(string.Format("SELECT {0} FROM {1}", string.Join(", ", asKeys), sClass)))
                {
                    IEnumerable<ManagementObject> en = from o in managementObjectSearcher.Get().OfType<ManagementObject>() orderby o.Path.ToString() select o;
                    var stringBuilder = new StringBuilder();
                    
                    using (IEnumerator<ManagementObjectWrapper> enumerator = en.Wrap().GetEnumerator())
                    {
                        while (enumerator.MoveNext())
                        {
                            ManagementObjectWrapper oObject = enumerator.Current;
                            stringBuilder.AppendLine(string.Join("-", (from sKey in asKeys select oObject[sKey].Trim()).ToList<string>()));
                            
                            if (!bAll)
                                break;
                        }
                    }
                    
                    result = stringBuilder.ToString().Trim();
                }
            }
            catch (Exception)
            {
                result = string.Empty;
            }
            
            return result;
        }
        
        private static string GetProcessorHash()
        {
            return GetManagementObjectHash("Win32_Processor", true, new string[]
            {
                "Description",
                "Manufacturer",
                "Name",
                "ProcessorId",
                "NumberOfCores",
                "NumberOfLogicalProcessors",
                "SocketDesignation"
            });
        }
        
        private static string Md5(string value)
        {
            string result = string.Empty;
            
            try
            {
                using (var md5CryptoServiceProvider = new MD5CryptoServiceProvider())
                {
                    var stringBuilder = new StringBuilder();
                    
                    foreach (byte b in md5CryptoServiceProvider.ComputeHash(Encoding.ASCII.GetBytes(value)))
                        stringBuilder.Append(b.ToString("x2"));
                    
                    result = stringBuilder.ToString();
                }
            }
            catch
            {                
            }
            
            return result;
        }

        private static string ToHex(params string[] string_0)
        {
            var random = new System.Random(int.Parse(Md5(string.Join("-", string_0)).Substring(0, 7), NumberStyles.HexNumber));
            string text = "";
            
            for (int i = 0; i < 20; i++)
            {
                if (i > 0 && i % 5 == 0)
                    text += "-";
                
                text += string.Format("{0:X}", random.Next(0, 16));
            }
            
            return text;
        }

        public static string GenerateLicenseKey(ProductInfo productInfo, string name, string email, string notes, DateTime expirationDate)
        {
            string result = string.Empty;
            
            try
            {
                var licenseInfo = new LicenseInfo();
    
                licenseInfo.ApplicationGuid = new Guid(productInfo.Guid);            
                licenseInfo.Name = name;
                licenseInfo.Email = email;
                licenseInfo.ClientId = Md5(Guid.NewGuid().ToString());
                licenseInfo.AllowBuildsBefore = null;
                licenseInfo.Valid = DateTime.Now.ToUniversalTime();
                licenseInfo.Expires = expirationDate.ToUniversalTime();
                licenseInfo.Modules = new List<ModuleLicense>();
                
                // Add default "Core" module
                licenseInfo.Modules.Add(new ModuleLicense() {
                    Name = "Core",
                    Valid = DateTime.Now.ToUniversalTime(),
                    Expires = expirationDate.ToUniversalTime(),
                    AllowBuildsBefore = null,
                    NumberOfSeats = int.MaxValue
                });
                
                // Add any other extra module used by the product
                if (productInfo.Modules != null)
                {
                    foreach (var module in productInfo.Modules)
                    {
                        licenseInfo.Modules.Add(new ModuleLicense() {
                            Name = module,
                            Valid = DateTime.Now.ToUniversalTime(),
                            Expires = expirationDate.ToUniversalTime(),
                            AllowBuildsBefore = null,
                            NumberOfSeats = int.MaxValue
                        });
                    }
                }
                
                licenseInfo.Hash = null;            
                licenseInfo.MachineName = Environment.MachineName;
                licenseInfo.MachineCode = GetMachineCode();
                licenseInfo.Notes = notes;                        
                licenseInfo.Hash = LicenseManager.Encrypt(licenseInfo.ToJsv());
                
                result = licenseInfo.ClientId + '-' + Convert.ToBase64String(Encoding.UTF8.GetBytes(licenseInfo.ToJsv()));
            }
            catch
            {
                result = string.Empty;
            }
            
            return result;
        }
    }
}
