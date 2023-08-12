using System;
using System.Text;

namespace Keygen
{
    public class RegData
    {
        public string GetRegKey()
        {
            var array = new byte[10];
            byte[] bytes = BitConverter.GetBytes(this.Number);
            
            for (int i = 0; i < 4; i++)
                array[i] = bytes[i];
            
            array[4] = (byte)this.MajorVersion;
            bytes = BitConverter.GetBytes(this.Product);
            
            for (int j = 0; j < 2; j++)
                array[5 + j] = bytes[j];

            array[7] = (byte)this.Expires.Day;
            array[8] = (byte)this.Expires.Month;
            array[9] = (byte)(this.Expires.Year % 100);
            
            for (int k = 1; k < array.Length; k++)
                array[k] ^= array[0];

            string text = this.BytesToString(array);
            
            return string.Concat(new string[]
            {
                text.Substring(0, 4),
                "-",
                text.Substring(4, 4),
                "-",
                text.Substring(8, 4),
                "-",
                text.Substring(12)
            });
        }
        
        private string BytesToString(byte[] data)
        {
            var stringBuilder = new StringBuilder();
            
            for (int i = 0; i < data.Length * 8; i += 5)
            {
                int num = i / 8;
                int num2 = i % 8;
                int num3 = data[num] >> num2 & 31;
                
                if (num2 > 3)
                    num3 += ((int)data[num + 1] << 8 - num2 & 31);
                
                int num4;
                
                if (num3 < 10)
                    num4 = num3 + 48;
                else
                    num4 = num3 - 10 + 65;

                var bytes = new byte[] {(byte)num4};                
                char[] chars = Encoding.Default.GetChars(bytes);
                stringBuilder.Append(chars[0]);
            }
            
            return stringBuilder.ToString();
        }

        public int Number;
        public short Product;
        public short MajorVersion;
        public DateTime Expires;
    }
  
    class Program
    {
        public static void Main(string[] args)
        {
            var regData = new RegData();
            regData.Number = new Random().Next(32000);
            regData.Product = 1;
            regData.MajorVersion = 3;
            regData.Expires = new DateTime(2050, 12, 31);   // any expiry date you want here
            
            Console.WriteLine("Kainet LogViewPro Keygen [by RadiXX11]");
            Console.WriteLine("======================================\n");
            Console.WriteLine("Reg Key: {0}\n", regData.GetRegKey());           
            Console.Write("Press any key to continue . . . ");
            Console.ReadKey(true);
        }
    }
}