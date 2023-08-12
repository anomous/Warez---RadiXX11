using System;
using System.Text;

namespace Activator
{
    public class Data
    {
        internal static string ToHex(byte[] ba)
        {
            if (ba == null || ba.Length == 0)
                return "";

            StringBuilder stringBuilder = new StringBuilder();
            
            foreach (byte b in ba)
                stringBuilder.Append(string.Format("{0:X2}", b));

            return stringBuilder.ToString();
        }

        internal static byte[] FromHex(string hexEncoded)
        {
            if (hexEncoded == null || hexEncoded.Length == 0)
                return null;

            checked
            {
                byte[] result;
                
                try
                {
                    int num = Convert.ToInt32((double)hexEncoded.Length / 2.0);
                    byte[] array = new byte[num - 1 + 1];
                    int num2 = 0;
                    int num3 = num - 1;
                    
                    for (int i = num2; i <= num3; i++)
                        array[i] = Convert.ToByte(hexEncoded.Substring(i * 2, 2), 16);
                    
                    result = array;
                }
                catch (Exception innerException)
                {
                    throw new FormatException("The provided string does not appear to be Hex encoded:" + Environment.NewLine + hexEncoded + Environment.NewLine, innerException);
                }
                
                return result;
            }
        }
        
        internal static byte[] FromBase64(string base64Encoded)
        {
            if (base64Encoded == null || base64Encoded.Length == 0)
                return null;

            byte[] result;
            
            try
            {
                result = Convert.FromBase64String(base64Encoded);
            }
            catch (FormatException innerException)
            {
                throw new FormatException("The provided string does not appear to be Base64 encoded:" + Environment.NewLine + base64Encoded + Environment.NewLine, innerException);
            }
            
            return result;
        }

        internal static string ToBase64(byte[] b)
        {
            if (b == null || b.Length == 0)
                return "";

            return Convert.ToBase64String(b);
        }
        
        public Data()
        {
            this._MaxBytes = 0;
            this._MinBytes = 0;
            this._StepBytes = 0;
            this.Encoding = Data.DefaultEncoding;
        }

        public Data(byte[] b)
        {
            this._MaxBytes = 0;
            this._MinBytes = 0;
            this._StepBytes = 0;
            this.Encoding = Data.DefaultEncoding;
            this._b = b;
        }

        public Data(string s)
        {
            this._MaxBytes = 0;
            this._MinBytes = 0;
            this._StepBytes = 0;
            this.Encoding = Data.DefaultEncoding;
            this.Text = s;
        }

        public Data(string s, Encoding encoding)
        {
            this._MaxBytes = 0;
            this._MinBytes = 0;
            this._StepBytes = 0;
            this.Encoding = Data.DefaultEncoding;
            this.Encoding = encoding;
            this.Text = s;
        }

        public bool IsEmpty
        {
            get
            {
                return this._b == null || this._b.Length == 0;
            }
        }

        public int StepBytes
        {
            get
            {
                return this._StepBytes;
            }
            set
            {
                this._StepBytes = value;
            }
        }

        public int StepBits
        {
            get
            {
                return checked(this._StepBytes * 8);
            }
            set
            {
                this._StepBytes = value / 8;
            }
        }

        public int MinBytes
        {
            get
            {
                return this._MinBytes;
            }
            set
            {
                this._MinBytes = value;
            }
        }

        public int MinBits
        {
            get
            {
                return checked(this._MinBytes * 8);
            }
            set
            {
                this._MinBytes = value / 8;
            }
        }

        public int MaxBytes
        {
            get
            {
                return this._MaxBytes;
            }
            set
            {
                this._MaxBytes = value;
            }
        }

        public int MaxBits
        {
            get
            {
                return checked(this._MaxBytes * 8);
            }
            set
            {
                this._MaxBytes = value / 8;
            }
        }

        public byte[] Bytes
        {
            get
            {
                checked
                {
                    if (this._MaxBytes > 0 && this._b.Length > this._MaxBytes)
                    {
                        byte[] array = new byte[this._MaxBytes - 1 + 1];
                        Array.Copy(this._b, array, array.Length);
                        this._b = array;
                    }
                    
                    if (this._MinBytes > 0 && this._b.Length < this._MinBytes)
                    {
                        byte[] array2 = new byte[this._MinBytes - 1 + 1];
                        Array.Copy(this._b, array2, this._b.Length);
                        this._b = array2;
                    }
                    
                    return this._b;
                }
            }
            set
            {
                this._b = value;
            }
        }

        public string Text
        {
            get
            {
                if (this._b == null)
                    return "";

                int num = Array.IndexOf<byte>(this._b, 0);
                
                if (num >= 0)
                    return this.Encoding.GetString(this._b, 0, num);

                return this.Encoding.GetString(this._b);
            }
            set
            {
                this._b = this.Encoding.GetBytes(value);
            }
        }

        public string Hex
        {
            get
            {
                return ToHex(this._b);
            }
            set
            {
                this._b = FromHex(value);
            }
        }

        public string Base64
        {
            get
            {
                return ToBase64(this._b);
            }
            set
            {
                this._b = FromBase64(value);
            }
        }

        public new string ToString()
        {
            return this.Text;
        }

        public string ToBase64()
        {
            return this.Base64;
        }

        public string ToHex()
        {
            return this.Hex;
        }

        private byte[] _b;
        private int _MaxBytes;
        private int _MinBytes;
        private int _StepBytes;
        
        public static Encoding DefaultEncoding = Encoding.GetEncoding("Windows-1252");
        public Encoding Encoding;
    }
}
