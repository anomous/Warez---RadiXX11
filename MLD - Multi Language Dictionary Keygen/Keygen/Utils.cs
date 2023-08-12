using System;
using System.Text;

namespace Keygen
{
    internal static class Utils
    {
        internal static string ToHex(byte[] ba)
        {
            bool flag = ba == null || ba.Length == 0;
            string result;
            
            if (flag)
            {
                result = "";
            }
            else
            {
                var stringBuilder = new StringBuilder();
                
                foreach (byte b in ba)
                {
                    stringBuilder.Append(string.Format("{0:X2}", b));
                }
                
                result = stringBuilder.ToString();
            }
            
            return result;
        }

        internal static byte[] FromHex(string hexEncoded)
        {
            bool flag = string.IsNullOrEmpty(hexEncoded);
            
            checked
            {
                byte[] result;
                
                if (flag)
                {
                    result = null;
                }
                else
                {
                    try
                    {
                        int num = Convert.ToInt32(hexEncoded.Length / 2);
                        var array = new byte[num];
                        int num2;
                        
                        for (int i = 0; i <= num - 1; i = num2 + 1)
                        {
                            array[i] = Convert.ToByte(hexEncoded.Substring(i * 2, 2), 16);
                            num2 = i;
                        }
                        
                        result = array;
                    }
                    catch (Exception innerException)
                    {
                        throw new FormatException("The provided string does not appear to be Hex encoded:" + Environment.NewLine + hexEncoded + Environment.NewLine, innerException);
                    }
                }
                
                return result;
            }
        }
    }
}