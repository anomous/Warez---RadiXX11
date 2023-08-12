using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Keygen
{
    class Program
    {
        private static readonly long Magic1 = 100000000000L;
        private static readonly long Magic2 = 144115188075855872L;
        private static readonly long Modulus = Magic2 / Magic1;        
        private static readonly byte[] Key = new byte[]
        {
            155,
            174,
            241,
            30,
            186,
            152,
            250,
            79,
            210,
            2,
            37,
            58,
            187,
            25,
            164,
            18,
            0,
            55,
            201,
            28,
            251,
            14,
            14,
            138,
            172,
            242,
            250,
            29,
            70,
            30,
            12,
            172
        };
        private static readonly byte[] IV = new byte[]
        {
            101,
            206,
            148,
            153,
            75,
            161,
            225,
            136,
            63,
            251,
            99,
            221,
            56,
            227,
            224,
            89
        };

        private static string BinToHex(byte[] buffer)
        {
            var result = new StringBuilder(buffer.Length * 2);
            
            for (int i = 0; i < buffer.Length; i++)
                result.Append(buffer[i].ToString("X2"));
            
            return result.ToString();
        }
        
        private static long RandInt64(long min, long max, Random rand)
        {
            var buf = new byte[8];
            rand.NextBytes(buf);
            long longRand = BitConverter.ToInt64(buf, 0);

            return (Math.Abs(longRand % (max - min)) + min);
        }
        
        public static string GenerateKey()
        {                
            using (var aes = Aes.Create())
            {
                aes.Key = Key;
                aes.IV = IV;
                ICryptoTransform transform = aes.CreateEncryptor(aes.Key, aes.IV);
                
                using (var memoryStream = new MemoryStream())
                {
                    using (var cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Write))
                    {
                        using (var streamWriter = new StreamWriter(cryptoStream))
                        {
                            var rand = new Random();            
                            long value;
                
                            do {
                                value = RandInt64(Modulus, 0xFFFFFFFFFFFFFFFL, rand);
                            } while (value % Modulus != 0L);
                            
                            streamWriter.Write(value.ToString("X15"));
                        }                                        
                    }
                    
                    return BinToHex(memoryStream.ToArray());
                }
            }
        }
        
        public static void Main(string[] args)
        {
            // MP3jam - http://www.mp3jam.org
            
            Console.WriteLine("MP3jam Keygen [by RadiXX11]");
            Console.WriteLine("===========================\n");            
            Console.WriteLine("Key: {0}\n", GenerateKey());            
            Console.Write("Press any key to continue . . . ");
            Console.ReadKey(true);
        }
    }
}