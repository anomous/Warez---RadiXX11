using System;
using System.Collections.Generic;

namespace Keygen
{
    public class ProductInfo
    {
        private readonly string name = string.Empty;
        private readonly List<KeyValuePair<string, int>> editions = null;
        
        internal static bool IsNumeric(string stringToTest)
        {
            int result;
            return int.TryParse(stringToTest, out result);
        }
        
        public ProductInfo(string name, List<KeyValuePair<string, int>> editions)
        {
            this.name = name;
            this.editions = editions;
        }
        
        public virtual string GenerateActivationCode(string idCode, int edition)
        {
            return string.Empty;
        }
        
        public List<KeyValuePair<string, int>> Editions
        {
            get { return editions; }
        }
        
        public string Name
        {
            get { return name; }
        }
    }
    
    public class TAM20Info : ProductInfo
    {
        public TAM20Info() : base(
            "Tool & Asset Manager 2.x", new List<KeyValuePair<string, int>> {
                new KeyValuePair<string, int>("Network", 6823),
                new KeyValuePair<string, int>("Standalone", 85)
            })
        {            
        }
        
        public override string GenerateActivationCode(string idCode, int edition)
        {
            var Values = new int[] {7, 3, 9, 3, 3, 5, 2, 7, 6, 8};
            long vNumTot = 0L;
            
            foreach (char c in idCode)
            {
                string cString = c.ToString();
                
                if (IsNumeric(cString))
                {
                    int vNum3 = Convert.ToInt32((Values[Convert.ToInt32(cString)] * 524).ToString().Substring(1, 3));
                    vNumTot = vNumTot * 3L + (long)vNum3;
                }
                else
                    vNumTot *= 44L;
            }
            
            do
            {
                if (vNumTot.ToString().Length >= 9)
                    break;
                
                vNumTot = (vNumTot + 1L) * 8L;
            }
            while (vNumTot.ToString().Length < 9);
            
            return (Convert.ToInt64(vNumTot.ToString().Substring(0, 9)) + (Int64)Editions[edition].Value).ToString();            
        }
    }
    
    public class VFM40Info : ProductInfo
    {
        public VFM40Info() : base(
            "Vehicle Fleet Manager 4.x", new List<KeyValuePair<string, int>> {
                new KeyValuePair<string, int>("Home", 13),
                new KeyValuePair<string, int>("Pro 15", 954),
                new KeyValuePair<string, int>("Pro 15 Network", -468),
                new KeyValuePair<string, int>("Pro 50", 5489),
                new KeyValuePair<string, int>("Pro 50 Network", 9814),
                new KeyValuePair<string, int>("Pro 200", -698),
                new KeyValuePair<string, int>("Pro 200 Network", 51),
                new KeyValuePair<string, int>("Pro Manager", 0),
                new KeyValuePair<string, int>("Pro Manager Network", 9416)
            })
        {            
        }
        
        public override string GenerateActivationCode(string idCode, int edition)
        {
            var Values = new int[] {3, 6, 2, 3, 2, 9, 5, 4, 8, 7};
            long vNumTot = 0L;
            
            foreach (char c in idCode)
            {
                string cString = c.ToString();
                
                if (IsNumeric(cString))
                {
                    int vNum3 = Convert.ToInt32((Values[Convert.ToInt32(cString)] * 612).ToString().Substring(1, 3));
                    vNumTot = vNumTot * 3L + (long)vNum3;
                }
                else
                    vNumTot *= 56L;
            }
            
            while (vNumTot.ToString().Length < 9)
            {
                vNumTot = (vNumTot + 1L) * 8L;
                
                if (vNumTot.ToString().Length >= 9)
                    break;
            }
            
            return (Convert.ToInt64(vNumTot.ToString().Substring(0, 9)) + (Int64)Editions[edition].Value).ToString();
        }
    }
    
    public static class Activation
    {
        public static readonly ProductInfo[] ProductList = {
            new TAM20Info(),
            new VFM40Info()
        };
    }
}
