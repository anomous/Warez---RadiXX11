using System;
using System.Management;
using System.Runtime.CompilerServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Security.Cryptography;
using System.Security.Principal;

using Microsoft.VisualBasic;
using Microsoft.VisualBasic.CompilerServices;
using Microsoft.Win32;

namespace Activator
{    
    /// <summary>
    /// Description of ProductLicense.
    /// </summary>
    public class ProductLicense
    {
        private const string KeyCharset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        
        private readonly string activationCC;
        private readonly string activationCCRootKey;
        private readonly string activationExpires;
        private readonly string activationKey;
        private readonly string activationOrder;
        private readonly string activationRootKey;
        private readonly string activationStatus;
        private readonly string productName;
        private readonly string productRootKey;
        private readonly string updateCheckKey;
        private readonly string updateCheckValue;
        private readonly bool usesOldRegEx;
        
        private DateTime productExpiration = new DateTime(2100, 12, 31);
        private int productVersion;
        
        private static string GenerateKey()
        {
            var rnd = new Random();
            var key = new StringBuilder();
            key.Length = 16;
                    
            for (int i = 0; i < key.Length; i++)
                key[i] = KeyCharset[rnd.Next(KeyCharset.Length)];

            return key.ToString();
        }
        
        private static string GenerateOrder()
        {
            return new Random().Next(10000000, 100000000).ToString();
        }
        
        private static string GetDiskSerialNumber(string DriveLetter)
        {            
            try
            {
                object objectValue = RuntimeHelpers.GetObjectValue(Interaction.CreateObject("Scripting.FileSystemObject", ""));
                object instance = objectValue;
                Type type = null;
                const string memberName = "GetDrive";
                object[] array = new object[]
                {
                    DriveLetter
                };
                object[] arguments = array;
                string[] argumentNames = null;
                Type[] typeArguments = null;
                bool[] array2 = new bool[]
                {
                    true
                };
                
                object obj = NewLateBinding.LateGet(instance, type, memberName, arguments, argumentNames, typeArguments, array2);
                
                if (array2[0])
                    DriveLetter = (string)Conversions.ChangeType(RuntimeHelpers.GetObjectValue(array[0]), typeof(string));
                
                object objectValue2 = RuntimeHelpers.GetObjectValue(obj);
                bool flag = Conversions.ToBoolean(NewLateBinding.LateGet(objectValue2, null, "IsReady", new object[0], null, null, null));
                
                return flag ? Conversion.Hex(RuntimeHelpers.GetObjectValue(NewLateBinding.LateGet(objectValue2, null, "SerialNumber", new object[0], null, null, null))) : "00000000";
            }
            catch
            {
                return "00000000";
            }
        }
        
        private static string GetMD5string(string theString)
        {
            var stringBuilder = new StringBuilder();
            checked
            {
                try
                {
                    MD5 md = MD5.Create();
                    byte[] bytes = Encoding.ASCII.GetBytes(theString);
                    byte[] array = md.ComputeHash(bytes);
                    int num = 0;
                    int num2 = array.Length - 1;
                    int num3 = num;
                    
                    for (;;)
                    {
                        int num4 = num3;
                        int num5 = num2;
                        
                        if (num4 > num5)
                        {
                            break;
                        }
                        stringBuilder.Append(array[num3].ToString("x2"));
                        num3++;
                    }
                }
                catch
                {
                }
                
                return stringBuilder.ToString();
            }
        }
        
        private static long GetUnixTime(DateTime dateTimeUTCnow)
        {
            long result;
            
            try
            {
                var date = new DateTime(1970, 1, 1);
                result = DateAndTime.DateDiff(DateInterval.Second, date, dateTimeUTCnow, FirstDayOfWeek.Sunday, FirstWeekOfYear.Jan1);
            }
            catch
            {
                result = 1L;
            }
            
            return result;
        }
        
        private static long GetUnixTimeNOW()
        {
            return GetUnixTime(DateTime.UtcNow);
        }
        
        private static string MyRegEx_SeeSub4Samples(string incomingString, string RegExPattern)
        {
            Regex regex = new Regex(RegExPattern);
            string text = "";
            MatchCollection matchCollection = regex.Matches(incomingString);
            int num = 0;
            
            checked
            {
                int num2 = matchCollection.Count - 1;
                int num3 = num;
                
                for (;;)
                {
                    int num4 = num3;
                    int num5 = num2;
                    
                    if (num4 > num5)
                    {
                        break;
                    }
                    
                    text += matchCollection[num3].Value;
                    num3++;
                }
                
                return text;
            }
        }
        
        private static string PCIDGeneratorHelper(string what2select, string whatDB, bool useOldRegEx)
        {
            string text = "";
            var array = new string[0];
            checked
            {
                try
                {
                    var query = new ObjectQuery("select " + what2select + " from " + whatDB);
                    var managementObjectSearcher = new ManagementObjectSearcher(query);
                    
                    try
                    {
                        foreach (ManagementBaseObject managementBaseObject in managementObjectSearcher.Get())
                        {
                            var managementObject = (ManagementObject)managementBaseObject;
                            string text2 = managementObject[what2select].ToString();
                            bool flag = Strings.Len(text2) > 0;
                            
                            if (flag)
                            {
                                if (useOldRegEx)
                                    text2 = Regex.Match(text2, "([A-Za-z0-9\\-\\ \\.]+)", RegexOptions.IgnoreCase).ToString();
                                else
                                    text2 = MyRegEx_SeeSub4Samples(text2, "[A-Za-z0-9 \\-\\.]");
                                
                                flag = (Strings.Len(text2) > 1);
                                
                                if (flag)
                                {
                                    Array.Resize<string>(ref array, array.Length + 1);
                                    array[array.Length - 1] = text2;
                                }
                            }
                        }
                    }
                    finally
                    {
                    }
                }
                catch
                {
                }
                
                Array.Sort<string>(array);
                
                foreach (string str in array) text = text + str + ",";
                
                text = Strings.Replace(text, "|", "", 1, -1, CompareMethod.Binary);
                return text;
            }
        }        
                
        private static string PCID(bool useOldRegEx)
        {
            string text = "";
            text = text + PCIDGeneratorHelper("Name", "Win32_VideoController", useOldRegEx) + "|";
            text = text + PCIDGeneratorHelper("ProcessorID", "Win32_Processor", useOldRegEx) + "|";
            text = text + PCIDGeneratorHelper("Manufacturer", "Win32_Processor", useOldRegEx) + "|";
            text = text + PCIDGeneratorHelper("SerialNumber", "Win32_BaseBoard", useOldRegEx) + "|";
            text = text + PCIDGeneratorHelper("Manufacturer", "Win32_BaseBoard", useOldRegEx) + "|";
            text = text + PCIDGeneratorHelper("Product", "Win32_BaseBoard", useOldRegEx) + "|";
            text = text + PCIDGeneratorHelper("SerialNumber", "win32_bios", useOldRegEx) + "|";
            text = text + PCIDGeneratorHelper("Manufacturer", "win32_bios", useOldRegEx) + "|";
            text = text + PCIDGeneratorHelper("Capacity", "Win32_PhysicalMemory", useOldRegEx) + "|";
            text = text + PCIDGeneratorHelper("Manufacturer", "Win32_PhysicalMemory", useOldRegEx) + "|";
            text = text + PCIDGeneratorHelper("SerialNumber", "Win32_PhysicalMemory", useOldRegEx) + "|";
                        
            string text2 = Conversions.ToString(Registry.GetValue("HKEY_LOCAL_MACHINE\\Software", "Disks", ""));
            bool flag = Strings.Len(text2) == 0;
            
            if (flag)
            {
                string text3 = "";
                text3 = text3 + PCIDGeneratorHelper("Model", "Win32_DiskDrive where InterfaceType = 'IDE'", useOldRegEx) + "|";
                text3 = text3 + PCIDGeneratorHelper("SerialNumber", "Win32_DiskDrive where InterfaceType = 'IDE'", useOldRegEx) + "|";
                text += text3;
                flag = IsRunningAsAdministrator();
                
                if (flag)
                    Registry.SetValue("HKEY_LOCAL_MACHINE\\Software", "Disks", text3);
            }
            else
                text += text2;
            
            flag = (Strings.Len(text) < 20);
            
            if (flag)
            {
                try
                {
                    string diskSerialNumber = GetDiskSerialNumber(Strings.Mid(Environment.GetFolderPath(Environment.SpecialFolder.System), 1, 1));
                    text += diskSerialNumber;
                }
                catch
                {
                    RegistryKey registryKey = Registry.LocalMachine.OpenSubKey("SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", false);
                    text += registryKey.GetValue("ProductId").ToString();
                }
            }
           
            return Strings.LCase(GetMD5string(text));
        }
        
        public static bool IsRunningAsAdministrator()
        {
            bool result;
            
            try
            {
                WindowsIdentity current = WindowsIdentity.GetCurrent();
                var windowsPrincipal = new WindowsPrincipal(current);
                result = windowsPrincipal.IsInRole(WindowsBuiltInRole.Administrator);
            }
            catch
            {
                result = false;
            }
            
            return result;
        }        
        
        private static string GetGlobalSetting(string codeID)
        {
            return Conversions.ToString(Registry.GetValue("HKEY_CURRENT_USER\\Software\\Cyrobo.com", codeID, ""));
        }
        
        private string GetSetting(string keyName, string valueName, string defaultValue)
        {
            return Conversions.ToString(Registry.GetValue("HKEY_CURRENT_USER\\Software\\" + string.Format("{0} {1}", productRootKey, productVersion) + "\\" + keyName, valueName, defaultValue));
        }

        private static void SetGlobalSetting(string codeID, string valueE)
        {
            Registry.SetValue("HKEY_CURRENT_USER\\Software\\Cyrobo.com", codeID, valueE);
        }
        
        private void SetSetting(string keyName, string valueName, string value)
        {
            Registry.SetValue("HKEY_CURRENT_USER\\Software\\" + string.Format("{0} {1}", productRootKey, productVersion) + "\\" + keyName, valueName, value);
        }
        
        public ProductLicense(string productName, int productVersion, string productRootKey, string activationRootKey, string activationExpires, string activationKey, string activationOrder, string activationStatus, string activationCCRootKey, string activationCC, string updateCheckKey, string updateCheckValue, bool usesOldRegEx)
        {
            this.productName = productName;
            this.productVersion = productVersion;
            this.productRootKey = productRootKey;
            this.activationRootKey = activationRootKey;
            this.activationExpires = activationExpires;
            this.activationKey = activationKey;
            this.activationOrder = activationOrder;
            this.activationStatus = activationStatus;
            this.activationCCRootKey = activationCCRootKey;
            this.activationCC = activationCC;
            this.updateCheckKey = updateCheckKey;
            this.updateCheckValue = updateCheckValue;
            this.usesOldRegEx = usesOldRegEx;
        }       
        
        public bool ActivateProduct()
        {
            if (IsRunningAsAdministrator())
            {
                try
                {              
                    SetSetting(activationRootKey, activationKey, GenerateKey());
                    SetSetting(activationRootKey, activationStatus, "1");
                    SetSetting(activationRootKey, activationExpires, GetUnixTime(productExpiration.ToUniversalTime()).ToString());
                    SetSetting(activationRootKey, activationOrder, GenerateOrder());
                    
                    string text = string.Concat(new string[]
                    {
                        GetSetting(activationRootKey, activationKey, ""),
                        GetSetting(activationRootKey, activationStatus, ""),
                        GetSetting(activationRootKey, activationExpires, ""),
                        GetSetting(activationRootKey, activationOrder, ""),
                        PCID(usesOldRegEx),
                        "t"
                    });
                    
                    SetSetting(activationCCRootKey, activationCC, GetMD5string(text));
                    SetSetting(updateCheckKey, updateCheckValue, GetUnixTimeNOW().ToString());
                    SetGlobalSetting("ANDOX", "");
                    SetGlobalSetting("PERFIDON", "");
                    
                    return true;
                }
                catch
                {
                    return false;
                }
            }
            
            return false;
        }
        
        public bool IsProductActivated()
        {
            try
            {
                bool value1 = string.IsNullOrEmpty(GetSetting(activationRootKey, activationKey, ""));
                bool value2 = string.IsNullOrEmpty(GetSetting(activationRootKey, activationStatus, ""));
                bool value3 = string.IsNullOrEmpty(GetSetting(activationRootKey, activationExpires, ""));
                bool value4 = string.IsNullOrEmpty(GetSetting(activationRootKey, activationOrder, ""));
                bool value5 = string.IsNullOrEmpty(GetSetting(activationCCRootKey, activationCC, ""));
                bool value6 = string.IsNullOrEmpty(GetGlobalSetting("ANDOX")) && string.IsNullOrEmpty(GetGlobalSetting("PERFIDON"));
                
                return (!value1 && !value2 && !value3 && !value4 && !value5 && value6);
            }
            catch
            {
                return false;
            }
        }     
        
        public DateTime ProductExpiration
        {
            get { return productExpiration; }
            set { productExpiration = (DateTime.Compare(value, DateTime.Now) > 0) ? value : DateTime.Now.AddDays(1); }
        }
        
        public string ProductName
        {
            get { return string.Format("{0} [{1}.x]", productName, productVersion); }
        }
        
        public int ProductVersion
        {
            get { return productVersion; }
            set { productVersion = (value >= 1 && value <= 99) ? value : 1; }
        }
    }
    
    /// <summary>
    /// Description of ProductLicensing.
    /// </summary>
    public static class ProductLicensing
    {
        // productName, productRootKey, activationRootKey, activationExpires, activationKey, activationOrder, activationStatus, activationCCRootKey, activationCC, updateNotifyRootKey, updateNotifyValue
        public static readonly ProductLicense[] ProductList =
        {
            //new ProductLicense("Auto Recycle Bin", 1, "Cyrobo.com\\rebina", "ServerResponse", "ActivationExpires", "ActivationKey", "ActivationOrder", "ActivationStatus", "General", "System-ActivationCC"),
            new ProductLicense("Clean Space", 7, "clnspc", string.Empty, "System-ActivationExpires", "System-ActivationKey", "System-ActivationOrder", "System-ActivationStatus", string.Empty, "System-ActivationCC", string.Empty, "ConnectToServer-Recent", true),
            new ProductLicense("Hidden Disk", 4, "hiddis", string.Empty, "System-ActivationExpires", "System-ActivationKey", "System-ActivationOrder", "System-ActivationStatus", string.Empty, "System-ActivationCC", string.Empty, "ConnectToServer-Recent", true),
            new ProductLicense("Prevent Recovery", 3, "prerec", string.Empty, "System-ActivationExpires", "System-ActivationKey", "System-ActivationOrder", "System-ActivationStatus", string.Empty, "System-ActivationCC", string.Empty, "ConnectToServer-Recent", true),
            new ProductLicense("Secure File Deleter", 6, "Cyrobo.com\\sfdlt", "ServerResponse", "ActivationExpires", "ActivationKey", "ActivationOrder", "ActivationStatus", "General", "ActivationCC", "General", "ConnectToServer-Recent", false)
        };        
    }
}
