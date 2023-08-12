using Microsoft.VisualBasic;
using Microsoft.VisualBasic.CompilerServices;
using System;
using System.IO;
using System.Management;
using System.Text;
using System.Text.RegularExpressions;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Security.Cryptography;

namespace Activator
{
    /// <summary>
    /// Description of ProductLicense.
    /// </summary>
    public class ProductLicense
    {
        private static readonly byte[] lbtVector = new byte[] {240, 3, 45, 29, 0, 76, 173, 59};
        private readonly string productName;
        private readonly string productSCN;
       
        [DllImport("kernel32.dll", CharSet = CharSet.Ansi, EntryPoint = "WritePrivateProfileStringA", ExactSpelling = true, SetLastError = true)]
        private static extern int FlushPrivateProfileString(int lpApplicationName, int lpKeyName, int lpString, [MarshalAs(UnmanagedType.VBByRefStr)] ref string lpFileName);
        
        [DllImport("kernel32.dll", CharSet = CharSet.Ansi, EntryPoint = "WritePrivateProfileStringA", ExactSpelling = true, SetLastError = true)]
        private static extern int WritePrivateProfileString([MarshalAs(UnmanagedType.VBByRefStr)] ref string lpApplicationName, [MarshalAs(UnmanagedType.VBByRefStr)] ref string lpKeyName, [MarshalAs(UnmanagedType.VBByRefStr)] ref string lpString, [MarshalAs(UnmanagedType.VBByRefStr)] ref string lpFileName);

        private static bool CheckFolder(string FolderName)
        {
            try
            {
                return new DirectoryInfo(FolderName).Exists;
            }
            catch
            {
                return false;
            }
        }
        
        private static string GeneratePCID()
        {
            string text = string.Empty;
            
            text = text + pcidGeneratorHelper("ProcessorID", "Win32_Processor") + "|";
            text = text + pcidGeneratorHelper("Manufacturer", "Win32_Processor") + "|";
            text = text + pcidGeneratorHelper("SerialNumber", "Win32_BaseBoard") + "|";
            text = text + pcidGeneratorHelper("Manufacturer", "Win32_BaseBoard") + "|";
            text = text + pcidGeneratorHelper("Product", "Win32_BaseBoard") + "|";
            text = text + pcidGeneratorHelper("SerialNumber", "win32_bios") + "|";
            text = text + pcidGeneratorHelper("Manufacturer", "win32_bios") + "|";
            text = text + pcidGeneratorHelper("Capacity", "Win32_PhysicalMemory") + "|";
            text = text + pcidGeneratorHelper("Manufacturer", "Win32_PhysicalMemory") + "|";
            text = text + pcidGeneratorHelper("SerialNumber", "Win32_PhysicalMemory") + "|";
            text = text + pcidGeneratorHelper("Model", "Win32_DiskDrive where InterfaceType = 'IDE'") + "|";
            text = text + pcidGeneratorHelper("SerialNumber", "Win32_DiskDrive where InterfaceType = 'IDE'") + "|";
            
            if (text.Length < 20)
            {
                try
                {
                    text += GetDiskSerialNumber(Environment.GetFolderPath(Environment.SpecialFolder.System).Substring(0, 1));
                }
                catch
                {
                }
            }

            if (text.Length > 1000)
                text = text.Substring(0, 1000);

            return "NET1" + GetMD5string(text);
        }
        
        private static string GetDiskSerialNumber(string DriveLetter)
        {
            string result;
            
            try
            {
                object objectValue = RuntimeHelpers.GetObjectValue(Interaction.CreateObject("Scripting.FileSystemObject", ""));
                object instance = objectValue;
                Type type = null;
                const string memberName = "GetDrive";
                var array = new object[] {DriveLetter};
                object[] arguments = array;
                string[] argumentNames = null;
                Type[] typeArguments = null;
                var array2 = new bool[] {true};
                
                object obj = NewLateBinding.LateGet(instance, type, memberName, arguments, argumentNames, typeArguments, array2);
                
                if (array2[0])
                    DriveLetter = (string)Conversions.ChangeType(RuntimeHelpers.GetObjectValue(array[0]), typeof(string));
                
                object objectValue2 = RuntimeHelpers.GetObjectValue(obj);
                
                result = Conversions.ToBoolean(NewLateBinding.LateGet(objectValue2, null, "IsReady", new object[0], null, null, null)) ? Conversion.Hex(RuntimeHelpers.GetObjectValue(NewLateBinding.LateGet(objectValue2, null, "SerialNumber", new object[0], null, null, null))) : "00000000";
            }
            catch
            {
                result = "00000000";
            }
            
            return result;
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
                    int num2 = array.Length - 1;
                    
                    for (int i = 0; i <= num2; i++)
                    {
                        stringBuilder.Append(array[i].ToString("x2"));
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
            try
            {
                return DateAndTime.DateDiff(DateInterval.Second, new DateTime(1970, 1, 1), dateTimeUTCnow, FirstDayOfWeek.Sunday, FirstWeekOfYear.Jan1);
            }
            catch
            {
                return 1L;
            }
        }
        
        public static string pcidGeneratorHelper(string what2select, string whatDB)
        {
            string text = string.Empty;
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
                            text2 = Regex.Match(text2, "([A-Za-z0-9\\-\\ \\.]+)", RegexOptions.IgnoreCase).ToString();
                            
                            if (text2.Length > 1)
                            {
                                Array.Resize<string>(ref array, array.Length + 1);
                                array[array.Length - 1] = text2;
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
                
                text = text.Replace("|", "");
                
                return text;
            }
        }
        
        public static string PsEncrypt(string sInputVal, string Password)
        {
            try
            {
                using (var tripleDESCryptoServiceProvider = new TripleDESCryptoServiceProvider())
                {
                    using (var md5CryptoServiceProvider = new MD5CryptoServiceProvider())
                    {
                        byte[] bytes = Encoding.ASCII.GetBytes(sInputVal);
                        tripleDESCryptoServiceProvider.Key = md5CryptoServiceProvider.ComputeHash(Encoding.ASCII.GetBytes(Password));
                        tripleDESCryptoServiceProvider.IV = lbtVector;
                        sInputVal = Convert.ToBase64String(tripleDESCryptoServiceProvider.CreateEncryptor().TransformFinalBlock(bytes, 0, bytes.Length));
                        return sInputVal;
                    }
                }
            }
            catch
            {
                return string.Empty;
            }
        }
        
        private static void WriteINI(string Section, string Key, string Value, string FileName)
        {
            try
            {
                WritePrivateProfileString(ref Section, ref Key, ref Value, ref FileName);
                FlushPrivateProfileString(0, 0, 0, ref FileName);
            }
            catch
            {
            }
        }
                
        private void saveSet(string area, string codeID, string valueE)
        {
            var appSettsFolder = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + "\\" + ProductName;
            
            try
            {
                if (!CheckFolder(appSettsFolder))
                    FileSystem.MkDir(appSettsFolder);
            }
            catch
            {
            }
            
            WriteINI(area, codeID, valueE, appSettsFolder + "\\settings.ini");
        }
        
        public ProductLicense(string productName, string productSCN)
        {
            this.productName = productName;
            this.productSCN = productSCN;
        }
        
        public void ActivatePRO()
        {
            string oid = new Random().Next().ToString();
            string text = GeneratePCID() + oid + productSCN;
            string valueE = PsEncrypt(text, text);
                        
            saveSet("PRO", "ORDERID", oid);
            saveSet("PRO", "KEY", valueE);
            saveSet("PRO", "TIME", (GetUnixTime(DateTime.UtcNow) + 31536000).ToString());
        }

        public string ProductName
        {
            get { return productName; }
        }
    }
}
