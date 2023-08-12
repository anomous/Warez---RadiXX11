using Microsoft.Win32;
using System;
using System.Management;

namespace Activator
{
    class Program
    {
        private static string GetHardwareID()
        {
            string text = "";
            
            try
            {
                var managementObjectSearcher = new ManagementObjectSearcher("select * from Win32_Processor");            
                
                foreach (ManagementBaseObject managementBaseObject in managementObjectSearcher.Get())
                {
                    var managementObject = (ManagementObject)managementBaseObject;
                    text += managementObject.GetPropertyValue("ProcessorId");
                }
                
                managementObjectSearcher.Query = new ObjectQuery("select * from Win32_BIOS");
                
                foreach (ManagementBaseObject managementBaseObject2 in managementObjectSearcher.Get())
                {
                    var managementObject2 = (ManagementObject)managementBaseObject2;
                    text += managementObject2.GetPropertyValue("SerialNumber");
                }
                
                managementObjectSearcher.Query = new ObjectQuery("select * from Win32_BaseBoard");
                
                foreach (ManagementBaseObject managementBaseObject3 in managementObjectSearcher.Get())
                {
                    var managementObject3 = (ManagementObject)managementBaseObject3;
                    text += managementObject3.GetPropertyValue("SerialNumber");
                }
            }
            catch
            {
                text = "";
            }
            
            return text;
        }
        
        public static bool ActivateApp()
        {
            bool result = false;
            string hID = GetHardwareID();
            
            if (!string.IsNullOrEmpty(hID))
            {
                try
                {
                    RegistryKey currentUser = Registry.CurrentUser;
                    currentUser.CreateSubKey("Software\\PDFLinkEditor").SetValue("KSIIQ", hID);
                    currentUser.Close();
                    result = true;
                }
                catch
                {
                    result = false;
                }
            }

            return result;
        }
    
        public static void Main(string[] args)
        {
            // https://www.pdflinkeditor.com
            
            Console.WriteLine("PDF Link Editor Pro 2.x Activator [by RadiXX11]");
            Console.WriteLine("===============================================\n");
            
            if (ActivateApp())
                Console.WriteLine("Program activated successfully.\n");
            else
                Console.WriteLine("Cannot activate program!\n");
            
            Console.Write("Press any key to continue . . . ");
            Console.ReadKey(true);
        }
    }
}