using System;

namespace Keygen
{
    /// <summary>
    /// Supported license types.
    /// </summary>
    [Flags]
    public enum LicenseTypes
    {
        Single = 1,
        Personal = 2,
        Home = 4,
        Team = 8,
        Enterprise = 16,
        All = Single | Personal | Home | Team | Enterprise            
    }
    
    /// <summary>
    /// Product info and license key generator (base class). 
    /// </summary>
    public class ProductInfo
    {
        protected readonly string id;
        protected readonly string num2LetterCharset;
        
        public readonly string Name;
        public readonly LicenseTypes LicenseTypes;
        
        /// <summary>
        /// Converts each numeric character of the specified string to its
        /// equivalent alphabetic character, according to the "tuples" (pair
        /// of digit+letter) assigned to num2LetterCharset.
        /// </summary>
        /// <param name="num">
        /// String with numeric characters.
        /// </param>
        /// <returns>
        /// String with the equivalent alphabetic characters.
        /// </returns>
        protected string Num2Letter(string num)
        {
            string result = string.Empty;
            int index;
            
            foreach (char c in num)
            {
                index = num2LetterCharset.IndexOf(c);
                
                if (index >= 0 && index < num2LetterCharset.Length - 1)
                    result += num2LetterCharset[index + 1];
            }
            
            return result;
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
        /// String with "tuples" or pair of characters (format is digit+letter+digit+letter...) used by method Num2Letter.
        /// Example: "0X1L2B3Y4S5D6Z7R8Q9P" (no spaces between "tuples" and all characters must be in uppercase).
        /// </param>
        /// <param name="licenseTypes">
        /// Set of license types supported by this product.
        /// </param>
        public ProductInfo(string name, string id, string num2LetterCharset, LicenseTypes licenseTypes)
        {
            this.Name = name;
            this.id = id;
            this.num2LetterCharset = num2LetterCharset;
            this.LicenseTypes = licenseTypes;            
        }
        
        /// <summary>
        /// License key generator.
        /// </summary>
        /// <param name="licenseType">
        /// License type for witch to generate a key (must be supported by the product).
        /// </param>
        /// <returns>
        /// String with license key.
        /// </returns>
        public virtual string GetLicenseKey(LicenseTypes licenseType)
        {
            var random = new Random();
            string key = id + "-";

            switch (licenseType)
            {
                case LicenseTypes.Single:
                    key += "SG";
                    break;
                case LicenseTypes.Personal:
                    key += "PS";
                    break;                    
                case LicenseTypes.Home:
                    key += "HM";
                    break;                    
                case LicenseTypes.Team:
                    key += "TM";
                    break;                    
                case LicenseTypes.Enterprise:
                    key += "EP";
                    break;                    
            }

            key += Num2Letter(random.Next(0, 23).ToString("D2"));
            key += "-";
            key += Num2Letter(random.Next(1, 31).ToString("D2"));
            key += Num2Letter(random.Next(1, 12).ToString("D2"));
            key += "-";
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            
            return key;
        }        
    }
    
    /// <summary>
    /// This class implements an alternative license key generator used with some earlier versions. 
    /// </summary>
    public class ProductInfo2 : ProductInfo
    {
        public ProductInfo2(string name, string id, string num2LetterCharset, LicenseTypes licenseTypes) :
            base(name, id, num2LetterCharset, licenseTypes) {}
                
        public override string GetLicenseKey(LicenseTypes licenseType)
        {
            var random = new Random();
            string key = id + "-";

            switch (licenseType)
            {
                case LicenseTypes.Single:
                    key += Num2Letter("10");
                    break;                    
                case LicenseTypes.Team:
                    key += Num2Letter("38");
                    break;                    
                default:
                    return string.Empty;                   
            }

            key += Num2Letter(random.Next(0, 23).ToString("D2"));
            key += "-";            
            key += Num2Letter(random.Next(1, 12).ToString("D2"));
            key += Num2Letter(random.Next(1, 31).ToString("D2"));
            key += "-";

            switch (licenseType)
            {
                case LicenseTypes.Single:
                    key += Num2Letter("01");
                    break;                  
                case LicenseTypes.Team:
                    key += Num2Letter("89");
                    break;                    
                default:
                    return string.Empty;                    
            }
            
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            
            return key;
        }        
    }
    
    /// <summary>
    /// This class implements an alternative license key generator used with some earlier versions. 
    /// </summary>
    public class ProductInfo3 : ProductInfo
    {
        public ProductInfo3(string name, string id, string num2LetterCharset, LicenseTypes licenseTypes) :
            base(name, id, num2LetterCharset, licenseTypes) {}

        public override string GetLicenseKey(LicenseTypes licenseType)
        {
            var random = new Random();
            string key = id + "-";
            
            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += Num2Letter(random.Next(1, 31).ToString("D2"));
            key += "-";
            
            switch (licenseType)
            {
                case LicenseTypes.Single:
                    key += "SG";
                    break;                  
                case LicenseTypes.Team:
                    key += "TM";
                    break;                    
                default:
                    return string.Empty;                    
            }

            key += Num2Letter(random.Next(0, 59).ToString("D2"));
            key += "-";
            key += Num2Letter(random.Next(1, 12).ToString("D2"));
            key += Num2Letter(random.Next(0, 23).ToString("D2"));

            return key;            
        }
    }
    
    /// <summary>
    /// This static class contains a list of supported products, each one with
    /// its corresponding license key generator.
    /// </summary>
    public static class ProductLicense
    {
        public static readonly ProductInfo[] ProductList = 
        {
            new ProductInfo("PDF to DOC 9.0", "DDUP", "0X1L2B3Y4S5D6Z7R8Q9P", LicenseTypes.All),
            new ProductInfo("PDF to HTML 4.0", "ZJZL", "0P1H2X3L4D5S6E7G8Q9M", LicenseTypes.All),
            new ProductInfo("PDF to JPG 10.0", "NGIP", "0Z1S2Q3J4W5L6D7T8M9X", LicenseTypes.All),
            new ProductInfo("PDF to Text 9.0", "HZWZ", "0Q1J2W3Z4P5H6X7L8S9D", LicenseTypes.All),
            new ProductInfo("PDF to X 5.0", "TPBP", "0P1H2X3L4Z5Q6C7J8N9M", LicenseTypes.All)            
        };        
    }
}
