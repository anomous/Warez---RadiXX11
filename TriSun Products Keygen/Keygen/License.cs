using System;
using System.Text;

namespace Keygen
{
    /// <summary>
    /// Supported license types.
    /// </summary>
    [Flags]
    public enum LicenseTypes
    {
        Single = 1,         // 1 PC license
        Personal = 2,       // 3 PCs license
        Home = 4,           // 10 PCs license
        Team = 8,           // X PCs license
        Enterprise = 16,    // X PCs license
        All = Single | Personal | Home | Team | Enterprise            
    }
    
    /// <summary>
    /// Product info and license key generator (base class). 
    /// </summary>
    public class KeyGenerator1
    {
        protected readonly string id;
        protected readonly string[] num2LetterDic;
        
        public readonly string Name;
        public readonly LicenseTypes LicenseTypes;
        public readonly bool SupportsNumPCs;
        
        protected static string EncodeLicenseType(string licenseKey, LicenseTypes licenseType)
        {
            string result = licenseKey;
            
            switch (licenseType)
            {
                case LicenseTypes.Single:
                    result += "SG";
                    break;
                case LicenseTypes.Personal:
                    result += "PS";
                    break;                    
                case LicenseTypes.Home:
                    result += "HM";
                    break;                    
                case LicenseTypes.Team:
                    result += "TM";
                    break;                    
                case LicenseTypes.Enterprise:
                    result += "EP";
                    break;                    
            }
                        
            return result;
        }
        
        protected string EncodeNumPCs(string licenseKey, LicenseTypes licenseType, int numPCs)
        {
            string result = licenseKey;
            
            if (((licenseType == LicenseTypes.Team) || (licenseType == LicenseTypes.Enterprise)) &&
                ((numPCs >= 11) && (numPCs <= 999999)) && SupportsNumPCs)
            {
                result += "-";
                result += Num2Letter(numPCs.ToString("D6"));
            }

            return result;
        }
        
        /// <summary>
        /// Converts each numeric character of the specified string to its
        /// equivalent alphabetic character.
        /// </summary>
        /// <param name="num">
        /// String with numeric characters.
        /// </param>
        /// <returns>
        /// String with the equivalent alphabetic characters.
        /// </returns>
        protected string Num2Letter(string num)
        {            
            var result = new StringBuilder(num.Length);
            var random = new Random();       
                        
            foreach (char c in num)
            {
                foreach (string s in num2LetterDic)
                {
                    int i = s.IndexOf('=');
                    
                    if ((i >= 0) && (s.Substring(0, i).Trim() == c.ToString()))
                    {
                        string charset = s.Substring(i + 1).Trim();
                        
                        if (!string.IsNullOrEmpty(charset))
                            result.Append(charset[random.Next(0, charset.Length)]);
                    }
                }                
            }
            
            return result.ToString();
        }
        
        /// <summary>
        /// Constructor for the product info and key generator base class.
        /// </summary>
        /// <param name="name">
        /// Name of the product (should include version number).
        /// </param>
        /// <param name="id">
        /// Id string of this product/release (4 characters in uppercase).
        /// </param>
        /// <param name="num2LetterCharset">
        /// String with charset for method Num2Letter. Format used is:
        /// [digit]=[letter][letter]...,[digit]=[letter][letter]...,...
        /// </param>
        /// <param name="licenseTypes">
        /// Set of license types supported by this product.
        /// </param>
        /// <param name="supportsNumPCs">
        /// A flag that indicates if we can specify the number of PCs on Team and Enterprise licenses.
        /// </param>
        public KeyGenerator1(string name, string id, string num2LetterCharset, LicenseTypes licenseTypes, bool supportsNumPCs)
        {
            this.Name = name;
            this.id = id;
            this.num2LetterDic = num2LetterCharset.Split(new char[] {','});     
            this.LicenseTypes = licenseTypes;
            this.SupportsNumPCs = supportsNumPCs;
        }
        
        /// <summary>
        /// License key generator.
        /// </summary>
        /// <param name="licenseType">
        /// License type for witch to generate a key (must be supported by the product).
        /// </param>
        /// <param name="numPCs">
        /// Number of licensed PCs.
        /// </param>
        /// <returns>
        /// String with license key.
        /// </returns>
        public virtual string GenerateLicenseKey(LicenseTypes licenseType, int numPCs)
        {            
            var random = new Random();
            string key = id + "-";
            
            key = EncodeLicenseType(key, licenseType);
            key += Num2Letter(random.Next(0, 23).ToString("D2"));
            key += "-";
            key += Num2Letter(random.Next(1, 31).ToString("D2"));
            key += Num2Letter(random.Next(1, 12).ToString("D2"));
            key += "-";
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            
            return EncodeNumPCs(key, licenseType, numPCs);
        }        
    }
        
    /// <summary>
    /// This class implements an alternative license key generator used with some products. 
    /// </summary>
    public class KeyGenerator2 : KeyGenerator1
    {
        public KeyGenerator2(string name, string id, string num2LetterCharset, LicenseTypes licenseTypes, bool supportsNumPCs) :
            base(name, id, num2LetterCharset, licenseTypes, supportsNumPCs) {}

        public override string GenerateLicenseKey(LicenseTypes licenseType, int numPCs)
        {
            var random = new Random();
            string key = id + "-";
            
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += Num2Letter(random.Next(1, 31).ToString("D2"));
            key += "-";
            key = EncodeLicenseType(key, licenseType);
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += "-";
            key += Num2Letter(random.Next(1, 12).ToString("D2"));
            key += Num2Letter(random.Next(0, 23).ToString("D2"));
            
            return EncodeNumPCs(key, licenseType, numPCs);
        }
    }
    
    /// <summary>
    /// This class implements an alternative license key generator used with some products. 
    /// </summary>    
    public class KeyGenerator3 : KeyGenerator1
    {
        public KeyGenerator3(string name, string id, string num2LetterCharset, LicenseTypes licenseTypes, bool supportsNumPCs) :
            base(name, id, num2LetterCharset, licenseTypes, supportsNumPCs) {}

        public override string GenerateLicenseKey(LicenseTypes licenseType, int numPCs)
        {            
            var random = new Random();
            string key = id + "-";
            
            key += Num2Letter(random.Next(1, 12).ToString("D2"));
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += "-";
            key = EncodeLicenseType(key, licenseType);
            key += Num2Letter(random.Next(1, 31).ToString("D2"));
            key += "-";
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += Num2Letter(random.Next(0, 23).ToString("D2"));
            
            return EncodeNumPCs(key, licenseType, numPCs);            
        }
    }
    
    /// <summary>
    /// This class implements an alternative license key generator used with some products. 
    /// </summary>    
    public class KeyGenerator4 : KeyGenerator1
    {
        public KeyGenerator4(string name, string id, string num2LetterCharset, LicenseTypes licenseTypes, bool supportsNumPCs) :
            base(name, id, num2LetterCharset, licenseTypes, supportsNumPCs) {}

        public override string GenerateLicenseKey(LicenseTypes licenseType, int numPCs)
        {            
            var random = new Random();
            string key = id + "-";
            
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += Num2Letter(random.Next(1, 12).ToString("D2"));
            key += "-";
            key += Num2Letter(random.Next(1, 31).ToString("D2"));
            key = EncodeLicenseType(key, licenseType);
            key += "-";
            key += Num2Letter(random.Next(0, 23).ToString("D2"));
            key += Num2Letter(random.Next(0, 59).ToString("D2"));

            return EncodeNumPCs(key, licenseType, numPCs);
        }
    }
    
    /// <summary>
    /// This class implements an alternative license key generator used with some products. 
    /// </summary>    
    public class KeyGenerator5 : KeyGenerator1
    {
        public KeyGenerator5(string name, string id, string num2LetterCharset, LicenseTypes licenseTypes, bool supportsNumPCs) :
            base(name, id, num2LetterCharset, licenseTypes, supportsNumPCs) {}

        public override string GenerateLicenseKey(LicenseTypes licenseType, int numPCs)
        {            
            var random = new Random();
            string key = id + "-";
            
            key += Num2Letter(random.Next(1, 12).ToString("D2"));
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += "-";
            key = EncodeLicenseType(key, licenseType);
            key += Num2Letter(random.Next(1, 31).ToString("D2"));
            key += "-";
            key += Num2Letter(random.Next(0, 23).ToString("D2"));
            key += Num2Letter(random.Next(0, 59).ToString("D2"));            
            
            return EncodeNumPCs(key, licenseType, numPCs);            
        }
    }

    /// <summary>
    /// This class implements an alternative license key generator used with some products. 
    /// </summary>    
    public class KeyGenerator6 : KeyGenerator1
    {
        public KeyGenerator6(string name, string id, string num2LetterCharset, LicenseTypes licenseTypes, bool supportsNumPCs) :
            base(name, id, num2LetterCharset, licenseTypes, supportsNumPCs) {}

        public override string GenerateLicenseKey(LicenseTypes licenseType, int numPCs)
        {            
            var random = new Random();
            string key = id + "-";
            
            key += Num2Letter(random.Next(1, 12).ToString("D2"));
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += "-";
            key += Num2Letter(random.Next(1, 31).ToString("D2"));
            key = EncodeLicenseType(key, licenseType);            
            key += "-";
            key += Num2Letter(random.Next(0, 23).ToString("D2"));
            key += Num2Letter(random.Next(0, 59).ToString("D2"));            
            
            return EncodeNumPCs(key, licenseType, numPCs);            
        }
    }     
    
    /// <summary>
    /// This static class contains a list of supported products, each one with its corresponding license key generator.
    /// </summary>
    public static class License
    {
        public static readonly KeyGenerator1[] ProductList = 
        {
            new KeyGenerator5("1Tree Pro", "TOTP", "0=D,1=Z,2=G,3=J,4=X,5=L,6=C,7=P,8=Y,9=S", LicenseTypes.All, true),
            new KeyGenerator4("5 Icons Income", "THFF", "0=D,1=Y,2=C,3=X,4=P,5=W,6=M,7=J,8=B,9=F", LicenseTypes.Single | LicenseTypes.Personal | LicenseTypes.Home, true),
            new KeyGenerator4("Access Password Recovery", "TAPR", "0=L,1=B,2=Y,3=Q,4=H,5=E,6=Z,7=T,8=R,9=W", LicenseTypes.All, false),
            new KeyGenerator4("Advanced Date Time Calculator", "NRSP", "0=M,1=Q,2=S,3=Y,4=L,5=J,6=Z,7=C,8=H,9=G", LicenseTypes.All, true),
            new KeyGenerator4("Advanced Recent Access", "SBXD", "0=S,1=K,2=Z,3=G,4=B,5=Q,6=Y,7=D,8=X,9=C", LicenseTypes.All, true),
            new KeyGenerator3("Duplicate File Finder Plus", "TDFP", "0=D,1=X,2=W,3=N,4=C,5=A,6=Y,7=M,8=Z,9=L", LicenseTypes.All, true),
            new KeyGenerator4("Duplicate MP3 Finder Plus", "TDMF", "0=G,1=W,2=S,3=D,4=M,5=Q,6=J,7=C,8=N,9=A", LicenseTypes.All, true),
            new KeyGenerator4("Duplicate Photo Finder Plus", "TDPF", "0=G,1=Z,2=C,3=Y,4=D,5=P,6=K,7=T,8=X,9=S", LicenseTypes.All, true),            
            new KeyGenerator2("Email Checker Pro", "TEPS", "0=Z,1=U,2=P,3=N,4=K,5=L,6=Q,7=T,8=Y,9=V", LicenseTypes.Single | LicenseTypes.Team, false),
            new KeyGenerator4("KeyMusic", "TKMN", "0=L,1=B,2=Y,3=Q,4=H,5=E,6=Z,7=T,8=R,9=W", LicenseTypes.All, false),            
            new KeyGenerator6("PC WorkBreak", "TPNM", "0=Z,1=B,2=L,3=J,4=S,5=G,6=D,7=Y,8=K,9=W", LicenseTypes.All, true),
            new KeyGenerator1("PDF to DOC", "DDUP", "0=X,1=L,2=B,3=Y,4=S,5=D,6=Z,7=R,8=Q,9=P", LicenseTypes.All, true),
            new KeyGenerator1("PDF to HTML", "ZJZL", "0=P,1=H,2=X,3=L,4=D,5=S,6=E,7=G,8=Q,9=M", LicenseTypes.All, true),
            new KeyGenerator1("PDF to JPG", "IIGJ", "0=B,1=C,2=P,3=D,4=Q,5=S,6=G,7=J,8=Z,9=L", LicenseTypes.All, true),
            new KeyGenerator1("PDF to Text", "SMYD", "0=D,1=Y,2=N,3=B,4=S,5=W,6=R,7=G,8=Z,9=J", LicenseTypes.All, true),
            new KeyGenerator1("PDF to X", "TPBP", "0=P,1=H,2=X,3=L,4=Z,5=Q,6=C,7=J,8=N,9=M", LicenseTypes.All, true),
            new KeyGenerator4("Windows Explorer Tracker", "TWET", "0=L,1=B,2=Y,3=Q,4=H,5=E,6=Z,7=T,8=R,9=W", LicenseTypes.All, false),
            new KeyGenerator3("WinExt", "TFSP", "0=D,1=W,2=N,3=Z,4=C,5=T,6=P,7=M,8=S,9=L", LicenseTypes.All, true),
            new KeyGenerator3("WinExt Batch Operator", "SOWE", "0=J,1=Z,2=P,3=B,4=N,5=Y,6=O,7=S,8=E,9=W", LicenseTypes.All, true)
        };        
    }
}
