using System;
using System.Text;

namespace Keygen
{
    public class Data
    {
        public Data(byte[] b)
        {
            this._b = b;
        }

        public Data(string s)
        {
            this.Text = s;
        }

        public Data(string s, Encoding encoding)
        {
            this.Encoding = encoding;
            this.Text = s;
        }

        public bool IsEmpty
        {
            get
            {
                bool flag = this._b == null;
                bool result;
                
                if (flag)
                {
                    result = true;
                }
                else
                {
                    bool flag2 = this._b.Length == 0;
                    result = flag2;
                }
                
                return result;
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

        public byte[] Bytes
        {
            get
            {
                bool flag = this._MaxBytes > 0;
                
                if (flag)
                {
                    bool flag2 = this._b.Length > this._MaxBytes;
                    
                    if (flag2)
                    {
                        byte[] array = new byte[this._MaxBytes];
                        Array.Copy(this._b, array, array.Length);
                        this._b = array;
                    }
                }
                
                bool flag3 = this._MinBytes > 0;
                
                if (flag3)
                {
                    bool flag4 = this._b.Length < this._MinBytes;
                    
                    if (flag4)
                    {
                        byte[] array2 = new byte[this._MinBytes];
                        Array.Copy(this._b, array2, this._b.Length);
                        this._b = array2;
                    }
                }
                
                return this._b;
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
                bool flag = this._b == null;
                string result;
                
                if (flag)
                {
                    result = "";
                }
                else
                {
                    int num = Array.IndexOf<byte>(this._b, 0);
                    bool flag2 = num >= 0;
                    
                    if (flag2)
                    {
                        result = this.Encoding.GetString(this._b, 0, num);
                    }
                    else
                    {
                        result = this.Encoding.GetString(this._b);
                    }
                }
                
                return result;
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
                return Utils.ToHex(this._b);
            }
            set
            {
                this._b = Utils.FromHex(value);
            }
        }

        public string ToHex()
        {
            return this.Hex;
        }

        private byte[] _b;
        private int _MaxBytes = 0;
        private int _MinBytes = 0;
        private int _StepBytes = 0;

        public static Encoding DefaultEncoding = Encoding.GetEncoding("Windows-1252");
        public Encoding Encoding = Data.DefaultEncoding;
    }
}
