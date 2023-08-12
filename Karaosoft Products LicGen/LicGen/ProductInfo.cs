using System;

namespace LicGen
{
    public class ProductInfo
    {
        private readonly string name;
        private readonly int id;
        private readonly string licensePath;
        
        public ProductInfo(string name, int id, string licensePath)
        {
            this.name = name;
            this.id = id;
            this.licensePath = licensePath;
        }
        
        public string Name
        {
            get { return name; }
        }
        
        public int Id
        {
            get { return id; }
        }
        
        public string LicensePath
        {
            get { return licensePath; }
        }
        
        public static ProductInfo[] ProductList = {
            new ProductInfo("Karma", 1248, @"\Karaosoft\Karma\KARMA_License.txt"),
            new ProductInfo("KJ File Manager", 1999, @"\Karaosoft\KJ File Manager\KFM3_License.txt"),
            new ProductInfo("Song List Generator", 1944, @"\Karaosoft\Song List Generator\SLG4_License.txt")
        };
    }
}
