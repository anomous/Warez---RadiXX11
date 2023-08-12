using System;
using System.Management;
using System.Security.Cryptography;
using System.Text;

namespace LicGen
{
    internal class FingerPrint
    {
        internal static string GenerateMachineIdentification()
        {
            var array = new string[15, 2];
            array[0, 0] = "Win32_NetworkAdapterConfiguration";
            array[0, 1] = "MACAddress";
            array[1, 0] = "Win32_Processor";
            array[1, 1] = "UniqueId";
            array[2, 0] = "Win32_Processor";
            array[2, 1] = "ProcessorId";
            array[3, 0] = "Win32_Processor";
            array[3, 1] = "Name";
            array[4, 0] = "Win32_Processor";
            array[4, 1] = "Manufacturer";
            array[5, 0] = "Win32_BIOS";
            array[5, 1] = "Manufacturer";
            array[6, 0] = "Win32_BIOS";
            array[6, 1] = "SMBIOSBIOSVersion";
            array[7, 0] = "Win32_BIOS";
            array[7, 1] = "IdentificationCode";
            array[8, 0] = "Win32_BIOS";
            array[8, 1] = "SerialNumber";
            array[9, 0] = "Win32_BIOS";
            array[9, 1] = "ReleaseDate";
            array[10, 0] = "Win32_BIOS";
            array[10, 1] = "Version";
            array[11, 0] = "Win32_BaseBoard";
            array[11, 1] = "Model";
            array[12, 0] = "Win32_BaseBoard";
            array[12, 1] = "Manufacturer";
            array[13, 0] = "Win32_BaseBoard";
            array[13, 1] = "Name";
            array[14, 0] = "Win32_BaseBoard";
            array[14, 1] = "SerialNumber";
            string[,] array2 = array;
            var stringBuilder = new StringBuilder();
            
            for (int i = 0; i < array2.GetLength(0); i++)
            {
                using (ManagementObjectCollection.ManagementObjectEnumerator enumerator = new ManagementObjectSearcher(string.Format("SELECT {1} FROM {0}", array2[i, 0], array2[i, 1]) + ((i == 0) ? " WHERE IPEnabled = 'True'" : string.Empty)).Get().GetEnumerator())
                {
                    if (enumerator.MoveNext())
                    {
                        string text = ((ManagementObject)enumerator.Current)[array2[i, 1]] as string;
                        
                        if (text != null)
                            stringBuilder.AppendLine(text);
                    }
                }
            }
            
            HashAlgorithm hashAlgorithm = new MD5CryptoServiceProvider();
            byte[] array3 = new ASCIIEncoding().GetBytes(stringBuilder.ToString());
            array3 = hashAlgorithm.ComputeHash(array3);
            stringBuilder.Clear();
            
            for (int j = 0; j < array3.Length; j++)
            {
                if (j > 0 && j % 2 == 0)
                    stringBuilder.Append('-');

                stringBuilder.AppendFormat("{0:X2}", array3[j]);
            }
            
            return stringBuilder.ToString();
        }
    }
}
