using Microsoft.VisualBasic.CompilerServices;
using System;
using System.Security.Cryptography;
using System.Text;

namespace Keygen
{
    class Program
    {
        public enum LicenseType
        {
            Evaluation = 1,
            BetaTester,
            FullRetail
        }
        
        private static TripleDESCryptoServiceProvider DES = new TripleDESCryptoServiceProvider();
                
        private static byte[] EncryptArray(byte[] byte_0)
        {
            long num = 0L;
            var array = new byte[1025];
            int num2 = byte_0.Length;
            DES.Padding = PaddingMode.Zeros;
            var cryptoAPITransform = (CryptoAPITransform)DES.CreateEncryptor();
            int inputBlockSize = cryptoAPITransform.InputBlockSize;
            IntPtr keyHandle = cryptoAPITransform.KeyHandle;
            int outputBlockSize = cryptoAPITransform.OutputBlockSize;
            
            checked
            {
                try
                {
                    if (cryptoAPITransform.CanTransformMultipleBlocks)
                    {
                        while (unchecked((long)num2) - num > unchecked((long)inputBlockSize))
                        {
                            short num3 = (short)cryptoAPITransform.TransformBlock(byte_0, (int)num, inputBlockSize, array, (int)num);
                            num += unchecked((long)num3);
                        }
                        byte[] array2 = cryptoAPITransform.TransformFinalBlock(byte_0, (int)num, (int)(unchecked((long)num2) - num));
                        array2.CopyTo(array, num);
                        array = (byte[])Utils.CopyArray(array, new byte[(int)(num + unchecked((long)array2.Length) - 1L) + 1]);
                    }
                }
                catch
                {
                }
                
                if (!cryptoAPITransform.CanReuseTransform)
                    cryptoAPITransform.Clear();

                return array;
            }
        }
    
        private static string EncryptString(string string_17)
        {
            DES.Key = Convert.FromBase64String("DN036QYe8oX+9g8GNu2U3lPz2WIwnb4G");
            DES.IV = Convert.FromBase64String("R8vJV81r5Bo=");
            return Convert.ToBase64String(EncryptArray(Encoding.ASCII.GetBytes(string_17)));
        }
        
        private static string GenerateActivationCode(string userName, LicenseType licenseType)
        {
            return EncryptString(Microsoft.VisualBasic.Strings.Format((int)licenseType, "00") + userName.Trim()).TrimEnd(new char[] {'='});
        }
        
        public static void Main(string[] args)
        {
            Console.WriteLine("Swift E Logbook Keygen [by RadiXX11]");
            Console.WriteLine("====================================\n");
            
            Console.Write("User Name......: ");
            string userName = Console.ReadLine();
            
            if (!string.IsNullOrEmpty(userName))
            {
                Console.WriteLine("Activation Code: {0}", GenerateActivationCode(userName, LicenseType.FullRetail));
                Console.WriteLine();            
                Console.Write("Press any key to continue . . . ");
                Console.ReadKey(true);
            }
        }
    }
}