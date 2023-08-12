using System;

namespace LicGen
{
    public class LicenseInfo
    {
        public LicenseType Type { get; set; }

        public string TypeAsString
        {
            get
            {
                return this.Type.ToString().Replace("_", " ");
            }
        }

        public string RegisteredToName { get; set; }
        
        public string RegisteredToEMail { get; set; }
        
        public string MaxUsersAsString
        {
            get
            {
                int? num = 0;
                return ((this.MaxUsers != null) ? num.GetValueOrDefault().ToString() : null) ?? "";
            }
        }

        public int? MaxUsers { get; set; }

        public DateTime LastChecked { get; set; }

        public DateTime? Expires { get; set; }

        public string LicenseKey { get; set; }

        public string ProductName { get; set; }

        public VersionInfo Version { get; set; }
    }
}
