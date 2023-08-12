using System;
using System.Security.Cryptography;
using System.Text;
using System.Windows.Forms;

namespace Keygen
{
    class Program
    {
        public const string DSAKeyValue = "<DSAKeyValue><P>3N35IcqKMJLdrg5HmSYa6duURBVDNZgj7BCnwcz/ufmuTgBqQSf3cxqHNTX31BTKJWBBdfF2LxA+uLRmTXZGzw==</P><Q>hEN4EgQsu/HHDcZh9Qwxg43wkL8=</Q><G>gYixcJeFwqXYS9td15uvi1o5Ontd6U00qjtvo7aPo4ccNB7jt5SGLEBM9RPsYPKnmC8PRBze5gm2MBgZIm4YsQ==</G><Y>RSijtNxu4sTZc50YrQLR19KX3PEsIGSrvcRYdAUKb1nWGJNY0aAdt/E5HtbMbSqIFPI3mLcOYdgxu9WyzGkRNw==</Y><J>AAAAAat+p7co8MRenHZUQ+BsY94gSFBLvhftoBGgwzmSBZZc+PRlV6daw3iAVN6y</J><Seed>J0VzBGcedEyNe+AWgq/mC/Wf9RU=</Seed><PgenCounter>pg==</PgenCounter><X>EaOoelpYoydZvGFMZHUobAPlfSY=</X></DSAKeyValue>";
        
        public static string GenerateSerial(string userName, short expirationYear, short expirationMonth, bool releaseLimited)
        {
            try
            {
                byte[] signature = null;
                
                using (var dsacryptoServiceProvider = new DSACryptoServiceProvider(512))
                {
                    dsacryptoServiceProvider.FromXmlString(DSAKeyValue);
                    var data = Encoding.UTF8.GetBytes(userName);
                    signature = dsacryptoServiceProvider.SignData(data);                
                    dsacryptoServiceProvider.PersistKeyInCsp = false;
                }
                
                if (signature != null)
                {
                    var startDate = new DateTime(2000, 1, 1);
                    var endDate = new DateTime(expirationYear, expirationMonth, 1);
                    var value = Math.Abs(12 * (startDate.Year - endDate.Year) + startDate.Month - endDate.Month) << 1;
                    
                    if (releaseLimited)
                        value |= 1;
                    
                    Array.Resize<byte>(ref signature, signature.Length + 2);
                    
                    signature[signature.Length - 1] = (byte)(value & 0xFF);
                    signature[signature.Length - 2] = (byte)(value >> 8);
                    
                    return Convert.ToBase64String(signature);
                }
            }
            catch
            {
            }
            
            return string.Empty;
        }
        
        [STAThread]
        public static void Main(string[] args)
        {                                    
            Console.WriteLine("Jitbit Macro Recorder Keygen [by RadiXX11]");
            Console.WriteLine("==========================================\n");
            
            Console.Write("User Name: ");
            var userName = Console.ReadLine();
            Console.WriteLine();
            
            if (!string.IsNullOrEmpty(userName))
            {
                var serial = GenerateSerial(userName, 2050, 1, false);
                
                Clipboard.SetText(serial);                
                Console.WriteLine("Serial: {0}\n", serial);                
                Console.WriteLine("The serial number was copied to the clipboard. Enjoy!\n");
            }
            
            Console.Write("Press any key to continue . . . ");
            Console.ReadKey(true);
        }
    }
}