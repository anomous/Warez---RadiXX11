using System;

namespace Keygen
{
    /// <summary>
    /// Description of Licensing.
    /// </summary>
    public static class Licensing
    {
        private static bool CheckValue(int value)
        {
            double num = Math.Sqrt((double)value);
            int num2 = 2;
            
            while ((double)num2 <= num)
            {
                double num3 = (double)value / (double)num2;
                
                if (Math.Floor(num3) == num3)
                {
                    return false;
                }
                
                num2++;
            }
            
            return true;
        }

        private static string GetRndValue()
        {
            var random = new Random();
            int result = 0;
            
            do
            {
                result = random.Next(100);
            } while (!CheckValue(result));
            
            return result.ToString("D2");
        }
        
        private static string GetRndOdd()
        {
            var random = new Random();
            int result = 0;
            
            do
            {
                result = random.Next(10);
            } while (result % 2 != 0);
            
            return result.ToString();
        }
        
        private static string GetRndString(int len)
        {
            const string Charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            var random = new Random();
            string result = "";
            
            for (int i=0; i < len; i++)
                result += Charset[random.Next(Charset.Length)];
            
            return result;
        }
        
        public static void GenerateRegCode(out string regCode, out string orderNum)
        {
            string s;
            int v1, v2;

            do
            {
                s = GetRndValue();
                v1 = int.Parse(s[0].ToString());
                v2 = int.Parse(s[1].ToString());
            } while (v1 < 2 || v2 < 1);
            
            regCode = v1.ToString() + (v1 - 1).ToString() + (v1 - 2).ToString() + GetRndValue() + GetRndString(2) + GetRndValue() + GetRndOdd() + GetRndString(3) + (v2 - 1).ToString() + v2.ToString();
            orderNum = new Random().Next(9400, 30001).ToString();
        }        
    }
}
