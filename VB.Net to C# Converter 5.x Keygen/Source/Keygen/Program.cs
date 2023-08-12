using System;
using System.Globalization;
using System.Text;

using Microsoft.VisualBasic;

namespace Keygen
{
    class Program
    {
        public static int GetCode(string key)
        {
            long num = 0L;
            string text = Strings.Replace(key, "-", "", 1, -1, CompareMethod.Binary);
            text = Strings.Replace(text, " ", "", 1, -1, CompareMethod.Binary);
            int num2 = 0;
            int num3 = text.Length - 1;
            for (int i = num2; i <= num3; i++)
            {
                char @string = text[i];
                num += (long)Strings.Asc(@string);
                if (num > 1000L)
                {
                    num -= 1000L;
                }
            }
            return (int)num;
        }
        
        public static string GenerateKey()
        {
            const string CharSet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            string key;
            var rnd = new Random();
            var sb = new StringBuilder(25);
            
            sb.Length = 25;

            do
            {
                for (int i=0; i < 25; i++)
                    sb[i] = CharSet[rnd.Next(CharSet.Length)];
                
                sb[0] = 'P';
                sb[4] = 'S';
                
                var s = DateTime.Today.ToString("mmddyy", CultureInfo.InvariantCulture);
                
                sb[7] = s[0];
                sb[10] = s[1];
                sb[14] = s[2];
                sb[19] = s[3];
                sb[22] = s[4];
                sb[24] = s[5];
                key = sb.ToString();
            } while (GetCode(key) != 481);
            
            key = key.Insert(5, "-");
            key = key.Insert(11, "-");
            key = key.Insert(17, "-");
            key = key.Insert(23, "-");

            return key;
        }
        
        public static void Main(string[] args)
        {
            Console.WriteLine("VB.Net to C# Converter 5.x Keygen [by RadiXX11]");
            Console.WriteLine("===============================================");
            Console.WriteLine();
            Console.WriteLine("Key: {0}", GenerateKey());
            Console.WriteLine();
            
            Console.Write("Press any key to continue . . . ");
            Console.ReadKey(true);
        }
    }
}