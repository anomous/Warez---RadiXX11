using System;
using System.Globalization;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Keygen
{
    /// <summary>
    /// Description of ProductLicense.
    /// </summary>
    public class ProductLicense
    {
        public const long ValidKeyCount = 100000000000L;
        public const long MaxKey = 144115188075855872L;
        public const long Factor = MaxKey / ValidKeyCount;
        
        private readonly byte[] aesIV;
        private readonly byte[] aesKey;
        private readonly string productName;
        
        private static string EncodeKey(byte[] key)
        {
            if (key == null || key.Length != 16)
                throw new ArgumentException("Invalid key");
            
            var stringBuilder = new StringBuilder();
            
            foreach (byte b in key)
                stringBuilder.Append(b.ToString("X2"));

            return stringBuilder.ToString();
        }
        
        private static byte[] DecodeKey(string key)
        {
            if (key == null || key.Length != 32)
                throw new ArgumentException("Invalid key");
            
            var array = new byte[16];
            
            for (int i = 0; i < 16; i++)
                array[i] = byte.Parse(key.Substring(i * 2, 2), NumberStyles.HexNumber);

            return array;
        }

        private static long RandomLong(RNGCryptoServiceProvider rand, long min, long max)
        {
            ulong scale = ulong.MaxValue;
            
            while (scale == ulong.MaxValue)
            {
                var bytes = new byte[8];
                rand.GetBytes(bytes);
                scale = BitConverter.ToUInt64(bytes, 0);
            }
        
            return (long)(min + (max - min) * (scale / (double)ulong.MaxValue));
        }
        
        private static long RandomKey(RNGCryptoServiceProvider rand, short rounds)
        {
            long result = 0;

            while (rounds-- > 0)
            {
                result = Factor * (RandomLong(rand, 1, 100000000000L) >> (byte)RandomLong(rand, 0, 31));
            }
            
            return result;
        }   
        
        private bool DecryptKey(string key, out string result)
        {
            result = null;
            
            if (!string.IsNullOrEmpty(key))
            {
                try
                {
                    using (var aes = Aes.Create())
                    {
                        aes.Key = aesKey;
                        aes.IV = aesIV;
                        ICryptoTransform transform = aes.CreateDecryptor(aes.Key, aes.IV);
                        
                        using (var memoryStream = new MemoryStream(DecodeKey(key)))
                        {
                            using (var cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Read))
                            {
                                using (var streamReader = new StreamReader(cryptoStream))
                                {
                                    result = streamReader.ReadToEnd();
                                }
                            }
                        }
                    }
                }
                catch
                {                    
                }
            }
            
            return !string.IsNullOrEmpty(result);
        }        
    
        private bool EncryptKey(string key, out string result)
        {   
            result = null;
            
            if (!string.IsNullOrEmpty(key))
            {
                try
                {
                    using (var aes = Aes.Create())
                    {
                        aes.Key = aesKey;
                        aes.IV = aesIV;            
                        ICryptoTransform transform = aes.CreateEncryptor(aes.Key, aes.IV);
                        
                        using (var memoryStream = new MemoryStream())
                        {
                            using (var cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Write))
                            {
                                using (var streamWriter = new StreamWriter(cryptoStream))
                                {
                                    streamWriter.Write(key);
                                }
                            }
                            
                            result = EncodeKey(memoryStream.ToArray());
                        }
                    }
                }
                catch
                {                
                }
            }
            
            return !string.IsNullOrEmpty(result);
        }
        
        public ProductLicense(string productName, byte[] aesKey, byte[] aesIV)
        {
            this.productName = productName;
            this.aesKey = aesKey;
            this.aesIV = aesIV;
        }

        public bool CheckKey(string key)
        {
            long num;
            
            try
            {
                string s;
                
                if (!DecryptKey(key, out s) || !long.TryParse(s, NumberStyles.HexNumber, CultureInfo.InvariantCulture, out num))
                    return false;
            }
            catch
            {
                return false;
            }
                        
            return num % Factor == 0L;
        }        
        
        public string GenerateKey(short rounds)
        {
            if (rounds > 0)
            {
                var rand = new RNGCryptoServiceProvider();
                string result;            
                return EncryptKey(RandomKey(rand, rounds).ToString("X"), out result) ? result : null;
            }
            
            return null;
        }
        
        public string ProductName
        {
            get { return productName; }
        }
    }
}
