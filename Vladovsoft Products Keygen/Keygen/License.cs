using System;
using System.Globalization;
using System.Management;
using System.Text;

namespace Keygen
{
    public static class License
    {
        private static string Base10ToBaseX(ulong value, uint radix)
        {
            const string Charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            
            if (radix < 2u || (ulong)radix > (ulong)((long)Charset.Length))
                throw new ArgumentException("The radix must be >= 2 and <= " + Charset.Length);

            if (value == 0UL)
                return "0";
            
            int num = 63;
            ulong num2 = value;
            var array = new char[64];
            
            while (num2 != 0UL)
            {
                int index = (int)(num2 % (ulong)radix);
                array[num--] = Charset[index];
                num2 /= (ulong)radix;
            }
            
            return new string(array, num + 1, 64 - num - 1);
        }
        
        private static uint CalcProductID(uint value, uint min, uint max)
        {
            while (value < min || value > max)
            {
                uint num = GetSum(value);
                
                if (num < 2u)
                    num += 8u;

                if (value < min)
                    value *= num;
                else if (value > max)
                    value = (uint)(value / num);
            }
            
            return value;
        }
                
        private static void Encode(char[] buffer, ulong value)
        {
            ulong num = (ulong)((long)buffer.Length);
            
            while (value > 0UL)
            {
                int num2 = (int)(value % num);
                value /= num;
                int num3 = (int)(value % num);
                value /= num;
                
                if (num2 != num3)
                {
                    char c = buffer[num2];
                    buffer[num2] = buffer[num3];
                    buffer[num3] = c;
                }
            }
        }

        private static ulong GetChecksum1(char[] buffer)
        {
            ulong num = 5381UL;
            int i = 0;
            int num2 = buffer.Length;
            
            while (i < num2)
            {
                num = (num << 5) + num + (ulong)buffer[i];
                i++;
            }
            
            return num;
        }

        private static ulong GetChecksum2(char[] buffer)
        {
            ulong num = 3074457345618258791UL;
            int i = 0;
            int num2 = buffer.Length;
            
            while (i < num2)
            {
                num += (ulong)buffer[i];
                num *= 3074457345618258799UL;
                i++;
            }
            
            return num;
        }      
        
        private static ulong GetChecksum3(char[] buffer)
        {
            const ulong num = 378551UL;
            ulong num2 = 63689UL;
            ulong num3 = 0UL;
            int i = 0;
            int num4 = buffer.Length;
            
            while (i < num4)
            {
                num3 = num3 * num2 + (ulong)buffer[i];
                num2 *= num;
                i++;
            }
            
            return num3;
        }
        
        private static uint GetDiskDriveSignature()
        {
            uint result = 0u;
            object obj = GetWMIProperty("Win32_DiskDrive", "Signature");
            
            try
            {
                result = (uint)obj;
            }
            catch
            {
                result = 0u;
            }
            
            return result;
        }    

        private static uint GetProcessorHash()
        {
            string environmentVariable = Environment.GetEnvironmentVariable("PROCESSOR_IDENTIFIER");
            string environmentVariable2 = Environment.GetEnvironmentVariable("PROCESSOR_REVISION");
            string text = environmentVariable + environmentVariable2;
            
            if (text == null)
                text = Environment.MachineName + "_" + Environment.ProcessorCount.ToString(CultureInfo.InvariantCulture);

            return (uint)text.GetHashCode();
        }

        private static uint GetSum(uint value)
        {
            uint num = value;
            uint num2 = 0u;
            
            while (num != 0u)
            {
                num2 += num % 10u;
                num /= 10u;
            }
            
            while (num2 > 9u)
            {
                num = num2;
                num2 = 0u;
                
                while (num != 0u)
                {
                    num2 += num % 10u;
                    num /= 10u;
                }
            }
            
            return num2;
        }
        
        private static object GetWMIProperty(string wmiClass, string wmiProperty)
        {
            object result = null;
            
            try
            {
                var managementObjectSearcher = new ManagementObjectSearcher(string.Format("SELECT {0} FROM {1}", wmiProperty, wmiClass));
                ManagementObjectCollection managementObjectCollection = managementObjectSearcher.Get();
                ManagementObjectCollection.ManagementObjectEnumerator enumerator = managementObjectCollection.GetEnumerator();
                
                if (enumerator.MoveNext())
                    result = enumerator.Current.Properties[wmiProperty].Value;
            }
            catch
            {
                result = null;
            }
            
            return result;
        }        
            
        public static string GetProductID()
        {
            uint hardwareID = GetDiskDriveSignature();
            
            if (hardwareID != 0u)
                return CalcProductID(hardwareID, 100000u, 999999u).ToString(CultureInfo.InvariantCulture);
            
            hardwareID = GetProcessorHash();
            return "99" + CalcProductID(hardwareID, 1000u, 9999u).ToString(CultureInfo.InvariantCulture);
        }
        
        public static string GetUnlockCode(string appName, string productID)
        {
            string text = appName.ToLower() + productID;
            char[] buffer = text.ToCharArray();
            ulong value1 = GetChecksum1(productID.ToCharArray());
            var unlockCode = new StringBuilder();
            int num = 0;
            
            while (unlockCode.Length < 30)
            {
                Encode(buffer, value1);
                ulong value2 = GetChecksum2(buffer);
                ulong value3 = GetChecksum3(buffer);
                unlockCode.Append(Base10ToBaseX(value2, 36u));
                unlockCode.Append(Base10ToBaseX(value3, 36u));
                value1 = GetChecksum1(buffer);
                
                while (unlockCode.Length > num)
                {
                    char c = unlockCode[0];
                    
                    if (c < '0' || c > '9')
                        break;

                    unlockCode.Remove(0, 1);
                }
                
                num++;
            }
            
            return unlockCode.ToString(0, 30);
        }

        public static readonly string[] AppNames = {"Bargen", "Fitorg", "Hotel", "Sklad"};
    }
}
