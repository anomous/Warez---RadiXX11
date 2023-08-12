using System;
using System.IO;
using System.Xml;
using Newtonsoft.Json;

namespace LicGen
{
    public static class LicenseHandler
    {
        private static void SaveLicense(object licenseInfo)
        {
            string innerText = StringCipher.Encrypt(JsonConvert.SerializeObject(licenseInfo), FingerPrint.GenerateMachineIdentification());
            var xmlDocument = new XmlDocument();
            XmlElement xmlElement = xmlDocument.CreateElement("License");
            xmlDocument.AppendChild(xmlElement);
            XmlElement xmlElement2 = xmlDocument.CreateElement("Secret");
            xmlElement2.InnerText = innerText;
            xmlElement.AppendChild(xmlElement2);
            xmlDocument.Save(Path.Combine(FileSystem.GetAppDataFolder(), "license.xml"));
        }
        
        public static bool GenerateLicenseFile(LicenseType licenseType, int maxUsers, string name, string email)
        {
            try
            {
                SaveLicense(new LicenseInfo {
                    Expires = DateTime.MaxValue,
                    LastChecked = DateTime.MaxValue,
                    LicenseKey = new Random().Next().ToString(),
                    MaxUsers = maxUsers,
                    ProductName = "Goldilogs",            
                    RegisteredToEMail = email.Trim(),
                    RegisteredToName = name.Trim(),
                    Type = licenseType,
                    Version = new VersionInfo("1.0.1")                             
                });
                
                return true;
            }
            catch
            {
                return false;
            }
        }
        
        public static string[] LicenseTypes = {"Free Edition", "Standard Edition", "Professional Evaluation Edition", "Professional Edition", "Closed Beta Edition"};
    }
}
