using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace LicGen
{
    internal static class StringCipher
    {
        internal static string Encrypt(string plainText, string passPhrase)
        {
            byte[] array = StringCipher.Generate256BitsOfRandomEntropy();
            byte[] array2 = StringCipher.Generate256BitsOfRandomEntropy();
            byte[] bytes = Encoding.UTF8.GetBytes(plainText);
            string result;
            
            using (var rfc2898DeriveBytes = new Rfc2898DeriveBytes(passPhrase, array, 1000))
            {
                byte[] bytes2 = rfc2898DeriveBytes.GetBytes(32);
                
                using (var rijndaelManaged = new RijndaelManaged())
                {
                    rijndaelManaged.BlockSize = 256;
                    rijndaelManaged.Mode = CipherMode.CBC;
                    rijndaelManaged.Padding = PaddingMode.PKCS7;
                    using (ICryptoTransform cryptoTransform = rijndaelManaged.CreateEncryptor(bytes2, array2))
                    {
                        using (var memoryStream = new MemoryStream())
                        {
                            using (var cryptoStream = new CryptoStream(memoryStream, cryptoTransform, CryptoStreamMode.Write))
                            {
                                cryptoStream.Write(bytes, 0, bytes.Length);
                                cryptoStream.FlushFinalBlock();
                                byte[] inArray = array.Concat(array2).ToArray<byte>().Concat(memoryStream.ToArray()).ToArray<byte>();
                                memoryStream.Close();
                                cryptoStream.Close();
                                result = Convert.ToBase64String(inArray);
                            }
                        }
                    }
                }
            }
            
            return result;
        }

        internal static string Decrypt(string cipherText, string passPhrase)
        {
            byte[] array = Convert.FromBase64String(cipherText);
            byte[] salt = array.Take(32).ToArray<byte>();
            byte[] rgbIV = array.Skip(32).Take(32).ToArray<byte>();
            byte[] array2 = array.Skip(64).Take(array.Length - 64).ToArray<byte>();
            string @string;
            
            using (var rfc2898DeriveBytes = new Rfc2898DeriveBytes(passPhrase, salt, 1000))
            {
                byte[] bytes = rfc2898DeriveBytes.GetBytes(32);
                
                using (var rijndaelManaged = new RijndaelManaged())
                {
                    rijndaelManaged.BlockSize = 256;
                    rijndaelManaged.Mode = CipherMode.CBC;
                    rijndaelManaged.Padding = PaddingMode.PKCS7;
                    
                    using (ICryptoTransform cryptoTransform = rijndaelManaged.CreateDecryptor(bytes, rgbIV))
                    {
                        using (var memoryStream = new MemoryStream(array2))
                        {
                            using (var cryptoStream = new CryptoStream(memoryStream, cryptoTransform, CryptoStreamMode.Read))
                            {
                                var array3 = new byte[array2.Length];
                                int count = cryptoStream.Read(array3, 0, array3.Length);
                                memoryStream.Close();
                                cryptoStream.Close();
                                @string = Encoding.UTF8.GetString(array3, 0, count);
                            }
                        }
                    }
                }
            }
            
            return @string;
        }

        private static byte[] Generate256BitsOfRandomEntropy()
        {
            var array = new byte[32];
            
            using (var rngcryptoServiceProvider = new RNGCryptoServiceProvider())
            {
                rngcryptoServiceProvider.GetBytes(array);
            }
            
            return array;
        }

        private const int Keysize = 256;
        private const int DerivationIterations = 1000;
    }
}
