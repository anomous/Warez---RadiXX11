using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Keygen
{
    class Program
    {
        public static string GenerateKey(string name, string email)
        {
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email))
                return string.Empty;
            
            byte[] inArray;
            
            using (var aesManaged = new AesManaged())
            {
                var iv = Encoding.UTF8.GetBytes("hjU78sda67dw2441");
                var rgbSalt = Encoding.UTF8.GetBytes("aselrias38490a32");
                var buffer = Encoding.UTF8.GetBytes(name + "|" + email);                
                var passwordDeriveBytes = new PasswordDeriveBytes("b56e8460-4f56-4495-868a-392bba1bbf2d", rgbSalt, "SHA1", 2);
                var key = passwordDeriveBytes.GetBytes(32);
                aesManaged.Mode = CipherMode.CBC;
                aesManaged.Mode = CipherMode.CBC;
                
                using (ICryptoTransform cryptoTransform = aesManaged.CreateEncryptor(key, iv))
                {
                    using (var memoryStream = new MemoryStream())
                    {
                        using (var cryptoStream = new CryptoStream(memoryStream, cryptoTransform, CryptoStreamMode.Write))
                        {
                            cryptoStream.Write(buffer, 0, buffer.Length);
                            cryptoStream.FlushFinalBlock();
                            inArray = memoryStream.ToArray();
                        }
                    }
                }
                
                aesManaged.Clear();
            }
            
            return Convert.ToBase64String(inArray);
        }
        
        public static void Main(string[] args)
        {
            Console.WriteLine("Helium Music Manager 13.x Premium Keygen [by RadiXX11]");
            Console.WriteLine("======================================================");
            Console.WriteLine();
            
            Console.Write("Name.: ");
            string name = Console.ReadLine();
            
            if (!string.IsNullOrEmpty(name))
            {
                Console.Write("EMail: ");
                string email = Console.ReadLine();            
            
                if (!string.IsNullOrEmpty(email))
                    Console.WriteLine("Key..: {0}", GenerateKey(name, email));
            }
            
            Console.WriteLine();
            Console.Write("Press any key to continue...");
            Console.ReadKey(true);
        }
    }
}