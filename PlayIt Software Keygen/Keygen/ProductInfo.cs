using System;

namespace Keygen
{
    public class ProductInfo
    {
        private readonly string name;
        private readonly string guid;
        private readonly string[] modules;
            
        public ProductInfo(string name, string guid, string[] modules)
        {
            this.name = name;
            this.guid = guid;
            this.modules = modules;
        }
        
        public string Name
        {
            get { return name; }
        }
        
        public string Guid
        {
            get { return guid; }
        }
        
        public string[] Modules
        {
            get { return modules;  }
        }
        
        public static ProductInfo[] ProductList = {
            new ProductInfo("PlayIt Cartwall", "2EEDDEB4-C8BE-4386-8C03-D3ECF1A640B0", null),
            new ProductInfo("PlayIt Live", "421EBA4E-86BA-46CD-A489-5706225A69C5", new string[] {"Advanced Scheduling", "Remote Management", "Voice Tracking"}),
            new ProductInfo("PlayIt Manager", "6AA23697-FE10-4531-A648-2EB4679CF6AD", new string[] {"Advanced Scheduling"}),
            new ProductInfo("PlayIt Recorder", "3F2EEDF8-A606-4746-BEC4-AD7DFCBECE2A", null),
            new ProductInfo("PlayIt VoiceTrack", "11924FAF-98A9-48E5-8B3E-B46A69EA2F7E", null)
        };
    }
}
