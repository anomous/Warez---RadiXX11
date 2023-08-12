using System;
using System.Collections.Specialized;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Xml;

namespace Activator
{      
    public class LicenseInfo
    {        
        private readonly string appName;
        private readonly bool hasProLicense;
        private readonly string resourceName;
        private readonly string settingsFileName;
        private readonly bool usesEncryption;
        
        private static void CreateFolderRecursive(string path)
        {
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);
        }

        private static string GetEmbadedResourceFullName(Assembly assembly, string respath)
        {           
            return assembly.GetManifestResourceNames().FirstOrDefault((string b) => b.EndsWith("." + respath, StringComparison.OrdinalIgnoreCase));
        }
        
        private static Stream GetEntryAssemblyResourceStream(string embededResourcefileName)
        {
            Assembly entryAssembly = Assembly.GetEntryAssembly();
            string embadedResourceFullName = GetEmbadedResourceFullName(entryAssembly, embededResourcefileName);
            
            if (!string.IsNullOrEmpty(embadedResourceFullName))
            {
                Stream manifestResourceStream = entryAssembly.GetManifestResourceStream(embadedResourceFullName);
            
                if (manifestResourceStream != null)
                {
                    manifestResourceStream.Seek(0L, SeekOrigin.Begin);
            
                    return manifestResourceStream;
                }
            }
            
            return null;
        }
        
        private static string[] ReadAllLinesFromResource(string embededResourcefileName)
        {
            Stream entryAssemblyResourceStream = GetEntryAssemblyResourceStream(embededResourcefileName);
            
            if (entryAssemblyResourceStream != null)
            {
                using (var streamReader = new StreamReader(entryAssemblyResourceStream))
                    return streamReader.ReadToEnd().Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
            }
            
            return null;
        }
        
        private static void SetValue(NameValueCollection nameValueCollection, string name, string value, bool encrypted)
        {
            if (encrypted)
            {
                var data = new Data();
                var symmetric = new Symmetric(Symmetric.Provider.TripleDES, true);
                symmetric.Key.Text = "EzF6@CD4-72$C-49b3-96*-329di949mcoB49}";
                data.Text = value;
                value = symmetric.Encrypt(data).Hex;
            }
            
            nameValueCollection[name] = value;
        }
        
        public LicenseInfo(string appName, string resourceName, bool hasProLicense, string settingsFileName, bool usesEncryption)
        {
            this.appName = appName;            
            this.hasProLicense = hasProLicense;
            this.resourceName = resourceName;
            this.settingsFileName = settingsFileName;
            this.usesEncryption = usesEncryption;
        }
                
        public bool Save(string userFullName, bool proLicense)
        {
            try
            {
                if (string.IsNullOrEmpty(userFullName))
                {
                    userFullName = Environment.UserName;
                
                    if (string.IsNullOrEmpty(userFullName))
                        userFullName = "User";
                }                    
                
                // Get registration code hashes for this app from resources

                string[] stdRegCodeHashes = ReadAllLinesFromResource(resourceName + ".txt");                
                string[] proRegCodeHashes = null;
                
                if (hasProLicense)
                    proRegCodeHashes = ReadAllLinesFromResource(resourceName + ".pro.txt");
                
                if (proRegCodeHashes != null || stdRegCodeHashes != null)
                {
                    // Pick a random registration code hash according to the selected license type
                    
                    string regCodeHash = string.Empty;
                    
                    while (string.IsNullOrEmpty(regCodeHash))
                        regCodeHash = (proLicense && proRegCodeHashes != null) ? proRegCodeHashes[new Random().Next(proRegCodeHashes.Length)].Trim() : stdRegCodeHashes[new Random().Next(stdRegCodeHashes.Length)].Trim();
                    
                    // If the settings file doesn't exists, create it
                    
                    if (!File.Exists(settingsFileName))
                    {
                        string path = Path.GetDirectoryName(settingsFileName);
                    
                        if (!Directory.Exists(path))
                            CreateFolderRecursive(path);
    
                        File.WriteAllText(settingsFileName, "<?xml version=\"1.0\"?><configuration><appSettings></appSettings></configuration>");
                    }
                
                    // Load settings file and save license info into it
                    
                    var xmlDocument = new XmlDocument();
                    xmlDocument.Load(settingsFileName);
                    XmlNode xmlNode = xmlDocument.SelectSingleNode("configuration/appSettings");
                    
                    if (xmlNode.LocalName == "appSettings")
                    {
                        var nameValueSectionHandler = new NameValueSectionHandler();
                        var settings = new NameValueCollection((NameValueCollection)nameValueSectionHandler.Create(null, null, xmlNode));
                        
                        SetValue(settings, "RRLKH", regCodeHash, usesEncryption);
                        SetValue(settings, "RRLT", ((proLicense) ? 3 : 2).ToString(), usesEncryption);
                        SetValue(settings,"_LicensedUserFullName", userFullName, false);
                        SetValue(settings, "RD", DateTime.Today.ToString("yyyy-MM-dd"), usesEncryption);  // Registration Date
                        SetValue(settings, "RRLRD", DateTime.Today.ToString("yyyy-MM-dd"), usesEncryption);  // Registration Date
                        SetValue(settings, "RRLK", string.Empty, usesEncryption);  // Registration Code
                        SetValue(settings, "RROI", string.Empty, usesEncryption);  // Order ID
                        SetValue(settings, "RRLTL", string.Empty, usesEncryption);   // Expiration Date
                        SetValue(settings, "UNST", string.Empty, usesEncryption);
                    
                        xmlNode.RemoveAll();
    
                        for (int i = 0; i < settings.Count; i++)
                        {
                            XmlNode xmlNode2 = xmlDocument.CreateNode(XmlNodeType.Element, "add", "");
                            XmlAttribute xmlAttribute = xmlDocument.CreateAttribute("key");
                            xmlAttribute.Value = settings.GetKey(i);
                            xmlNode2.Attributes.Append(xmlAttribute);
                            xmlAttribute = xmlDocument.CreateAttribute("value");                            
                            xmlAttribute.Value = settings.Get(i);
                            xmlNode2.Attributes.Append(xmlAttribute);
                            xmlNode.AppendChild(xmlNode2);
                        }
                    
                        xmlDocument.Save(settingsFileName);
                        
                        return true;
                    }
                }
                
                return false;
            }
            catch
            {
                return false;
            }                 
        }
        
        public string AppName
        {
            get { return appName; }
        }
        
        public bool HasProLicense
        {
            get { return hasProLicense; }
        }
    }
}
